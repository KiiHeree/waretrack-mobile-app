import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waretrack/pages/deliveryComplete.dart';
import 'package:waretrack/pages/deliveryDetail.dart';
import 'package:waretrack/pages/loginPage.dart';
import 'package:waretrack/pages/profile.dart';
import 'package:waretrack/api/apiService.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _user;
  List<Map<String, dynamic>>? _orders;
  // int? driverId;
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
    // int? driver = prefs.getInt('user_id');

    if (userId == null) {
      print("User ID tidak ditemukan di SharedPreferences");
      return;
    }

    final userData = await AuthService().getUser(userId);

    if (userData != null) {
      setState(() {
        // driverId = userId;
        _user = userData['data']; // simpan ke state
      });
    } else {
      print("Gagal ambil data user");
    }
  }

  // Color
  Color getStatusColor(String status) {
    switch (status) {
      case "delivered":
        return const Color.fromARGB(255, 0, 230, 8);
      case "in_transit":
        return const Color.fromARGB(255, 53, 164, 255);
      case "picked_up":
        return const Color.fromARGB(255, 116, 87, 0);
      case "assigned":
        return const Color.fromARGB(255, 85, 85, 85);
      default:
        return Colors.grey.shade200; // default abu
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0, // biar flat
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    "images/logo.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                // Greeting
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user != null ? "Halo, ${_user!['name']}" : "Loading...",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Welcome back!",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: PopupMenuButton<String>(
                icon: Icon(Icons.menu, color: Colors.blue, size: 28),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (value) {
                  if (value == 'profile') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Profile()),
                    ).then((_) async {
                      final orders = await AuthService().getOrders(
                        _user?['id'],
                      );
                      setState(() {
                        _orders = orders; // update state biar UI ke-refresh
                      });
                    });
                  } else if (value == 'deliveryComplete') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryComplete(),
                      ),
                    ).then((_) async {
                      final orders = await AuthService().getOrders(
                        _user?['id'],
                      );
                      setState(() {
                        _orders = orders; // update state biar UI ke-refresh
                      });
                    });
                  } else if (value == 'logout') {
                    // 🔹 Panggil API logout
                    _handleLogout(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_2_rounded),
                      title: Text("Profile"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'deliveryComplete',
                    child: ListTile(
                      leading: Icon(Icons.assignment_turned_in),
                      title: Text("Delivery Complete"),
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout_outlined),
                      title: Text("Log Out"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            FutureBuilder<List<Map<String, dynamic>>>(
              future: AuthService().getOrders(_user?['id']),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                if (!snapshot.hasData) {
                  return Center(child: Text("Belum ada data"));
                }

                final orders = snapshot.data!;

                // Hitung statistik
                int totalOrders = orders.length;
                int delivered = orders
                    .where((o) => o['status'] == 'delivered')
                    .length;
                int onGoing = orders
                    .where(
                      (o) =>
                          o['status'] == 'picked_up' ||
                          o['status'] == 'in_transit',
                    )
                    .length;

                return Column(
                  children: [
                    Row(
                      children: [
                        _statBox("Orders Today", "$totalOrders"),
                        SizedBox(width: 12),
                        _statBox("Delivered", "$delivered"),
                        SizedBox(width: 12),
                        _statBox("On Going", "$onGoing"),
                      ],
                    ),
                  ],
                );
              },
            ),

            SizedBox(height: 24),
            Text(
              "Delivery Order",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: AuthService().getOrders(
                  _user?['id'],
                ), // pake id driver lo
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Belum ada order"));
                  }

                  final orders = snapshot.data!; // ini list dari API lo

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, i) {
                      final order = orders[i];

                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🔥 Status Order
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(order['status']),
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.work_history,
                                        size: 18,
                                        color: const Color.fromARGB(
                                          255,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        order['status'] ??
                                            "Unknown", // 👉 status dari API
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            255,
                                            255,
                                            255,
                                          ),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "#${order['order_number'] ?? 'NoID'}", // 👉 order number
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // 🔥 Card isi detail
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        DeliveryDetail(orderId: order['id']),
                                  ),
                                ).then((_) async {
                                  final orders = await AuthService().getOrders(
                                    _user?['id'],
                                  );
                                  setState(() {
                                    _orders =
                                        orders; // update state biar UI ke-refresh
                                  });
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.lightBlue.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // From - To
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              // mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  "From",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  order['warehouse']['city'] ??
                                                      'Unknown', // 👉 dari API
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  order['warehouse']['name'] ??
                                                      '',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.local_shipping,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "To",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  order['customer_name'] ??
                                                      'Unknown',
                                                  maxLines:
                                                      1, // maksimal 2 baris
                                                  overflow: TextOverflow
                                                      .ellipsis, // kasih "..." kalo kepanjangan
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                SizedBox(height: 2),
                                                Text(
                                                  order['destination_address'] ??
                                                      '',
                                                  maxLines:
                                                      1, // maksimal 2 baris
                                                  overflow: TextOverflow
                                                      .ellipsis, // kasih "..." kalo kepanjangan
                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: Color(0xFFF1F5F9),
                                    ),

                                    // Customer & Items
                                    Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Customer Name",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.person_outline,
                                                      size: 16,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Flexible(
                                                      child: Container(
                                                        constraints:
                                                            BoxConstraints(
                                                              maxWidth: 180,
                                                            ),
                                                        child: Text(
                                                          order['customer_name'] ??
                                                              'Unknown',
                                                          maxLines:
                                                              1, // maksimal 2 baris
                                                          softWrap: true,
                                                          overflow: TextOverflow
                                                              .visible,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Total Items",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xFF64748B),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Icon(
                                                      Icons.inventory_2,
                                                      size: 16,
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      "${order['total_items']} Items",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
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
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statBox(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.lightBlueAccent.withOpacity(0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    // Panggil API Logout
    final authService = AuthService();
    await authService.logout();

    // Hapus token JWT
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    // Redirect ke LoginPage
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }
}
