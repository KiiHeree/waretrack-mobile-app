import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waretrack/api/apiService.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic>? _user;
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) return; // keluar kalo token ga ada

    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      print("User ID tidak ditemukan di SharedPreferences");
      return;
    }

    final userData = await ApiService().getUser(userId);

    if (userData != null) {
      setState(() {
        _user = userData['data']; // simpan ke state
      });
    } else {
      print("Gagal ambil data user");
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        title: Text("Profile", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(0),
                      child: Column(
                        children: [
                          // Driver Information
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Driver Information",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF13293B),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.lightBlue.withOpacity(
                                          0.1,
                                        ),
                                        blurRadius: 10,
                                        offset: Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _infoItem(
                                              context,
                                              'Driver Name',
                                              _user != null
                                                  ? "${_user!['name']}"
                                                  : "Loading...",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoItem(
                                              context,
                                              'Vehicle Info',
                                              _user != null
                                                  ? "${_user?['driver']?['vehicle_info'] ?? '-'}"
                                                  : "Loading...",
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _infoItem(
                                              context,
                                              'Phone',
                                              _user != null
                                                  ? "${_user!['phone']}"
                                                  : "Loading...",
                                            ),
                                          ),
                                          Expanded(
                                            child: _infoItem(
                                              context,
                                              'Driver License',
                                              _user != null
                                                  ? "${_user?['driver']?['license_no'] ?? '-'}"
                                                  : "Loading...",
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _infoItem(
                                              context,
                                              'Email',
                                              _user != null
                                                  ? "${_user!['email']}"
                                                  : "Loading...",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(BuildContext context, String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
