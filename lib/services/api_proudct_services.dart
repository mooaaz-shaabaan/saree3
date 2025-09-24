import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:saree3/model/prodact_model.dart';

class ApiServices {
  Future<List<MenuItem>> prodacts({required String resturantName}) async {
    final url = Uri.parse(
      "https://mooaaz-shaabaan.github.io/saree3/$resturantName",
    );
    final result = await http.get(url);
    List<dynamic> data = jsonDecode(result.body);
    return data.map((item) => MenuItem.fromJson(item)).toList();
  }
}
