import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:saree3/constants/constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

part 'data_user_state.dart';

class DataUserLogic extends Cubit<DataUserState> {
  DataUserLogic() : super(DataUserInitial()) {
    userUID = FirebaseAuth.instance.currentUser!.uid;
  }

  void initialize() {
    getData();
  }

  String userUID = "0";
  String image = "";
  String fullName = "";
  String email = "";
  String phoneNumber = "";
  String bio = "";

  void getData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('User Account') // خليها موحدة زي ما اتفقنا
          .doc(userUID)
          .get();

      final data = userDoc.data() ?? {}; // ← هترجع Map أو فاضية

      image = data['image'] ?? Images.firstImageProfile;
      fullName = data['fullName'] ?? "Moaz Shaaban";
      email = data['email'] ?? "email@example.com";
      phoneNumber = data['phoneNumber'] ?? "16550";
      bio = data['bio'] ?? "I love fast food";

      emit(GetData());
    } catch (e) {
      print("/////////*********/////////////////*************** $e");
    }
  }

  Future<String> _uploadProfilePhoto(XFile imageFile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child("profile_photos")
          .child("$userUID.jpg");

      await ref.putFile(File(imageFile.path));
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return "";
    }
  }

  /// 🔹 اختيار صورة + رفعها + تخزين الرابط في Firestore
  Future<void> uploadAndSaveProfilePhoto() async {
    try {
      final picker = ImagePicker();
      final profilePhoto = await picker.pickImage(source: ImageSource.gallery);

      if (profilePhoto != null) {
        // ارفع الصورة على Storage
        final downloadUrl = await _uploadProfilePhoto(profilePhoto);

        if (downloadUrl.isNotEmpty) {
          // خزن في Firestore
          await FirebaseFirestore.instance
              .collection('User Account')
              .doc(userUID)
              .set({
                'image': downloadUrl,
                'fullName': fullName,
                'email': email,
                'phoneNumber': phoneNumber,
                'bio': bio,
              }, SetOptions(merge: true));

          image = downloadUrl; // حدّث القيمة المحلية
          emit(SetData());
        }
      }
    } catch (e) {
      print("Error in uploadAndSaveProfilePhoto: $e");
    }
  }

  void setData({
    required String newEmail,
    required String newFullName,
    required String newPhoneNumber,
    required String newBio,
    required String newImage,
  }) async {
    await FirebaseFirestore.instance
        .collection('User Account')
        .doc(userUID)
        .set({
          'image': newImage,
          'fullName': newFullName,
          'email': newEmail,
          'phoneNumber': newPhoneNumber,
          'bio': newBio,
        }, SetOptions(merge: true));

    image = newImage;
    fullName = newFullName;
    email = newEmail;
    phoneNumber = newPhoneNumber;
    bio = newBio;
    emit(SetData());
  }
}
