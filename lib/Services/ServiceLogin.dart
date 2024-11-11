import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_pfe/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceLogin {

  static Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String token = responseData['token'];
      await saveTokenToPrefs(token);
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.post(
        Uri.parse('${Constants.baseUrl}/logout'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await prefs.remove('token');
      } else {
        throw Exception('Failed to logout');
      }
    }
  }

  static Future<void> saveTokenToPrefs(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }
}
