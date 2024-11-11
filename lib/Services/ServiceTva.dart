import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_pfe/Models/Tva.dart';
import 'package:mobile_pfe/Models/Country.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_pfe/utils/constants.dart';

class ServiceTva {
  //get     Tvas
  static Future<List<Tva>> getTvasForUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/tvas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Tva> tvas = data.map((json) => Tva.fromJson(json)).toList();
      return tvas;
    } else {
      throw Exception('Failed to load Tvas');
    }
  }

  //get     Countrys
  static Future<List<Country>> getCountrys() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/countrys'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      List<Country> countrys =
          data.map((json) => Country.fromJson(json)).toList();
      return countrys;
    } else {
      throw Exception('Failed to load countrys');
    }
  }

//add
  static Future<void> addTva(Map<String, dynamic> tvaData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/tvas'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(tvaData),
    );
    if (response.statusCode == 200) {
      //print('add tva success');
    } else {
      throw Exception('Failed to add Tva');
    }
  }

//edit
  static Future<void> editTva(int id, Map<String, dynamic> tvaData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/tvas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(tvaData),
    );
    if (response.statusCode == 200) {
      //print('Tva edit success');
    } else {
      throw Exception('Failed to Edit Tva');
    }
  }

  static Future<void> deleteTva(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/tvas/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      //print('Tva deleted successfully');
    } else {
      throw Exception('Failed to delete Tva');
    }
  }
}
