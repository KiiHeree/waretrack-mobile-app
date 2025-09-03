import 'package:flutter/material.dart';
import 'package:waretrack/api/apiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waretrack/pages/deliveryDetail.dart';

class DeliveryComplete extends StatefulWidget {
  const DeliveryComplete({super.key});

  @override
  State<DeliveryComplete> createState() => _DeliveryCompleteState();
}

class _DeliveryCompleteState extends State<DeliveryComplete> {
  Map<String, dynamic>? _orders;
  List<Map<String, dynamic>>? _orders_by_date;
  Future<List<Map<String, dynamic>>>? _futureOrders;
  int? driverId;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    _loadDriverId();
    _fetchOrders(); // default
  }

  Future<void> _loadDriverId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      driverId = prefs.getInt('user_id'); // ambil dari shared
    });
  }

  void _fetchOrders({DateTime? start, DateTime? end}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? driverId = prefs.getInt("user_id");
    print(driverId);
    setState(() {
      _futureOrders = AuthService().getOrdersDelivered(
        driverId,
        startDate: start,
        endDate: end,
      );
    });
  }

  Future<void> _pickStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delivery Complete", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔥 Input Tanggal
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickStartDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startDate != null
                                ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                                : "Start Date",
                            style: TextStyle(
                              color: startDate != null
                                  ? Colors.black
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickEndDate,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            endDate != null
                                ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                                : "End Date",
                            style: TextStyle(
                              color: endDate != null
                                  ? Colors.black
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ), // bisa buat range dari-to
              ],
            ),
            ElevatedButton(
              onPressed: () {
                if (startDate != null && endDate != null) {
                  _fetchOrders(start: startDate, end: endDate);
                } else {
                  // fallback kalau ga pilih tanggal → tetap ambil default
                  _fetchOrders();
                }
              },
              child: Text("Search"),
            ),
            SizedBox(height: 24),
            Text(
              "Delivery Orders",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureOrders,
                // ganti driverId sesuai user
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada order"));
                  }

                  final orders = snapshot.data!;

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
                                color: Color.fromARGB(255, 0, 230, 8),
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
                                ).then((_) {
                                  // kalau sebelumnya user udah filter, pake filter lagi
                                  if (startDate != null && endDate != null) {
                                    _fetchOrders(
                                      start: startDate,
                                      end: endDate,
                                    );
                                  } else {
                                    _fetchOrders(); // default semua data
                                  }
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
}
