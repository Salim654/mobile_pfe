import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_pfe/Utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_pfe/Models/Category.dart';
import 'package:mobile_pfe/Models/Brand.dart';

class ServiceBrandCategory {
  //get categorys
  static Future<List<Category>> fetchCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/categorys'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((model) => Category.fromJson(model)).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  //get brands
  static Future<List<Brand>> fetchBrands() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/brands'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = jsonDecode(response.body);
      return list.map((model) => Brand.fromJson(model)).toList();
    } else {
      throw Exception('Failed to fetch brands');
    }
  }

//add category
  static Future<void> createCategory(Map<String, dynamic> category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/categorys'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(category),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create category');
    }
  }

//add brand
  static Future<void> createBrand(Map<String, dynamic> brand) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/brands'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(brand),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create brand');
    }
  }

//update category
  static Future<void> updateCategory(
      int idcategory, Map<String, dynamic> category) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/categorys/${idcategory}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(category),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update category');
    }
  }

//update brand
  static Future<void> updateBrand(
      int idbrand, Map<String, dynamic> brand) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/brands/${idbrand}'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(brand),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update brand');
    }
  }

//delete category
  static Future<void> deleteCategory(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/categorys/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }

// delete brand
  static Future<void> deleteBrand(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/brands/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete brand');
    }
  }
}
