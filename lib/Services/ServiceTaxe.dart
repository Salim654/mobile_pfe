import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_pfe/Utils/constants.dart';

import '../Models/Taxe.dart';

class ServiceTaxe {
  static Future<List<Taxe>> getTaxesForUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/taxes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Taxe> taxes = data.map((json) => Taxe.fromJson(json)).toList();
      return taxes;
    } else {
      throw Exception('Failed to load taxes');
    }
  }

  static Future<Taxe> addTaxe(Map<String, dynamic> taxeData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/taxes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(taxeData),
    );
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);
      return Taxe.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to add Taxe');
    }
  }

  static Future<void> editTaxe(int id, Map<String, dynamic> taxeData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/taxes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(taxeData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit tax');
    }
  }

  static Future<void> deleteTaxe(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/taxes/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete tax');
    }
  }
}
