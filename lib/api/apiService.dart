import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      "https://9738beb516a7.ngrok-free.app/api"; // url

  // Login
  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      String token = data['access_token'];
      int userId = data['user']['id'];

      // simpan token ke local storage (SharedPreferences)
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', userId);
      await prefs.setString('token', token);

      return true;
    } else {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );
      await prefs.remove('token');
    }
  }

  // Ambil Driver 
  Future<Map<String, dynamic>?> getUser(int? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('$baseUrl/get-driver/$id'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Ambil Delivery Order 
  Future<List<Map<String, dynamic>>> getOrders(int? id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("Token tidak ditemukan di SharedPreferences");
        return [];
      }

      final response = await http.get(
        Uri.parse('$baseUrl/get-order-by-driver/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json['status'] == true && json['data'] != null) {
          final List<dynamic> data = json['data'];
          return data.cast<Map<String, dynamic>>();
        } else {
          print("Response status false / data kosong");
          return [];
        }
      } else {
        print("Gagal ambil orders, status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getOrders: $e");
    }
    return [];
  }

  // Ambil Delivery Order Detail
  Future<Map<String, dynamic>?> getOrderDetail(int? id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("Token tidak ditemukan di SharedPreferences");
        return null;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/get-order-detail/$id'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json['status'] == true && json['data'] != null) {
          final Map<String, dynamic> data = json['data']; 
          return data;
        } else {
          print("Response status false / data kosong");
          return null;
        }
      } else {
        print("Gagal ambil orders, status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getOrders: $e");
    }
    return null;
  }


  // Update Order Status
  Future<void> updateOrderStatus(int orderId, String nextStatus) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return null;
    final response = await http.post(
      Uri.parse('$baseUrl/update-status-order/$orderId'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"status": nextStatus}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    return null;
  }

  // Ambil Order Delivered
  Future<List<Map<String, dynamic>>> getOrdersDelivered(
    int? driverId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        print("Token tidak ditemukan di SharedPreferences");
        return [];
      }

      // Build query params kalau ada tanggal
      Map<String, String> queryParams = {};
      if (startDate != null && endDate != null) {
        queryParams = {
          'start_date': startDate.toIso8601String(),
          'end_date': endDate.toIso8601String(),
        };
      }

      // Build URL sesuai kondisi
      final uri = Uri.parse(
        '$baseUrl/get-order-delivered-by-driver/$driverId',
      ).replace(queryParameters: queryParams.isNotEmpty ? queryParams : null);

      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print("Request URL: $uri");
      print("Status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json['status'] == true && json['data'] != null) {
          final List<dynamic> data = json['data'];
          return data.cast<Map<String, dynamic>>();
        } else {
          print("Response status false / data kosong");
          return [];
        }
      } else {
        print("Gagal ambil orders, status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error getOrders: $e");
    }
    return [];
  }
}
