import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_pfe/Models/FactureProducts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/constants.dart';
import '../Models/Facture.dart';

class ServiceFacture {
  // Function to fetch facture details from the API
  static Future<Map<String, dynamic>?> fetchFactureDetails(
      int idFacture) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/factures/$idFacture'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      //print('Failed to fetch facture details: ${response.statusCode}');
      return null;
    }
  }

  //get invoices
  static Future<List<Facture>?> getInvoices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/invoices'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Facture.fromJson(json)).toList();
    } else {
      //print('Failed to fetch factures: ${response.statusCode}');
      Exception('Failed to load factures');
    }
  }

  //get Estimates
  static Future<List<Facture>?> getEstimates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/estimates'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Facture.fromJson(json)).toList();
    } else {
      //print('Failed to fetch factures: ${response.statusCode}');
      Exception('Failed to load factures');
    }
  }

  //get po
  static Future<List<Facture>?> getPOs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/purchases'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Facture.fromJson(json)).toList();
    } else {
      //print('Failed to fetch factures: ${response.statusCode}');
      Exception('Failed to load factures');
    }
  }

  //delete fac
  static Future<void> deleteFacture(int id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('${Constants.baseUrl}/factures/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete facture');
    }
  }

  //  add invoice
  static Future<Facture?> addInvoice({
    required String date,
    required String dueDate,
    required double discount,
    required int clientId,
    int? taxeId,
    required int type,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/factures'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': date,
        'due_date': dueDate,
        'discount': discount,
        'client_id': clientId,
        'taxe_id': taxeId,
        'type': type,
      }),
    );

    if (response.statusCode == 200) {
      return Facture.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add facture');
    }
  }

  // Edit facture
  static Future<Facture?> editFacture({
    required int id,
    required String date,
    required String dueDate,
    double? discount,
    int? clientId,
    int? taxeId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.put(
      Uri.parse('${Constants.baseUrl}/factures/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'date': date,
        'due_date': dueDate,
        'discount': discount,
        'client_id': clientId,
        'taxe_id': taxeId,
      }),
    );

    if (response.statusCode == 200) {
      return Facture.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to edit facture');
    }
  }

  // Function to fetch facture products from the API
  static Future<List<FactureProduct>?> getFactureProducts(int factureId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('${Constants.baseUrl}/factures/$factureId/factureprods'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => FactureProduct.fromJson(json)).toList();
    } else {
      //print('Failed to fetch facture products: ${response.statusCode}');
      return null;
    }
  }

  //add product to facture
  static Future<void> addProductInvoice({
    required int factureId,
    required int quantity,
    required double discount,
    required int productId,
    int? taxeId,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('${Constants.baseUrl}/factures/$factureId/factureprods'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'quantity': quantity,
        'discount': discount,
        'product_id': productId,
        'taxe_id': taxeId,
      }),
    );

    if (response.statusCode == 200) {
      print('work fine ');
    } else {
      throw Exception('Failed to add product to facture');
    }
  }

  //delete item from fac
  static Future<void> deleteItemFacture(int factureId, int idprod) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse(
          '${Constants.baseUrl}/factures/$factureId/factureprods/$idprod'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete item from facture');
    }
  }
}
