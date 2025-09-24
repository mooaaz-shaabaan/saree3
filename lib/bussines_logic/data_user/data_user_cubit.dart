import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:saree3/constants/constants.dart';

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
          .collection('userAccount') // خليها موحدة زي ما اتفقنا
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

  void setData({
    required String newEmail,
    required String newFullName,
    required String newPhoneNumber,
    required String newBio,
    required String newImage,
  }) async {
    await FirebaseFirestore.instance.collection('users').doc(userUID).set({
      'email': newEmail,
      'full_name': newFullName,
      'phone_number': newPhoneNumber,
      'bio': newBio,
      'image': newImage,
    });
    emit(SetData());
  }
}
