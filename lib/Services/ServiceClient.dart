import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_pfe/Models/Client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_pfe/Utils/constants.dart';

class ServiceClient {
  //get clients
  static Future<List<Client>> getClients(String recherche) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/clients?recherche=$recherche'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['clients'];
      return jsonResponse.map((client) => Client.fromJson(client)).toList();
    } else {
      throw Exception('Failed to load clients');
    }
  }

// add client
  static Future<Client> addClient(Map<String, dynamic> clientData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/clients'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(clientData),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body)['client'];
      return Client.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to add client');
    }
  }

  //edit client
  static Future<Client> editClient(
      int idclient, Map<String, dynamic> clientData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/clients/${idclient}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(clientData),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body)['client'];
      return Client.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to edit client');
    }
  }

  static Future<void> deleteClient(int idclient) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/clients/$idclient'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('Client deleted successfully');
    } else {
      throw Exception('Failed to delete client');
    }
  }
}
