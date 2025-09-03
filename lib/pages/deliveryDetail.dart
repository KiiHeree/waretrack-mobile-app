import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:waretrack/api/apiService.dart';
import 'package:waretrack/pages/homePage.dart';

class DeliveryDetail extends StatefulWidget {
  // DeliveryDetail({super.key});
  final int orderId;
  const DeliveryDetail({required this.orderId, super.key});

  @override
  State<DeliveryDetail> createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetail> {
  Map<String, dynamic>? order;

  @override
  void initState() {
    super.initState();
    _fetchOrder();
  }

  Future<void> _fetchOrder() async {
    final data = await AuthService().getOrderDetail(widget.orderId);
    setState(() {
      order = data;
    });
  }

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
    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: Text("Order Detail")),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        title: Text("Delivery Details", style: TextStyle(fontSize: 20)),
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
                          // Delivery
                          Column(
                            children: [
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
                                            "From",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            '${order?['warehouse']['name']}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                          SizedBox(height: 2),
                                          Text(
                                            '${order?['warehouse']['city']}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF64748B),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.local_shipping,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ),
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
                                            '${order?['customer_name']}',
                                            maxLines: 1, // maksimal 2 baris
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
                                            '${order?['destination_address']}',
                                            maxLines: 1, // maksimal 2 baris
                                            overflow: TextOverflow
                                                .ellipsis, // kasih "..." kalo kepanjangan
                                            softWrap: true,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
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
                              Padding(
                                padding: EdgeInsets.all(10),
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
                                              color: Color(0xFF64748B),
                                              fontSize: 12,
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
                                              Text(
                                                '${order?['customer_name']}',
                                                maxLines: 1, // maksimal 2 baris
                                                overflow: TextOverflow
                                                    .ellipsis, // kasih "..." kalo kepanjangan
                                                softWrap: true,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12,
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
                                              color: Color(0xFF64748B),
                                              fontSize: 12,
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
                                                '${order?['total_items']}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E293B),
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

                          // Detail Delivery Information
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(height: 20, color: Color(0xFFF1F5F9)),
                                Text(
                                  "Delivery Information",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF13293B),
                                  ),
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _infoItem(
                                        context,
                                        'Order Number',
                                        '#${order?['order_number']}',
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        context,
                                        'Destination',
                                        '${order?['destination_address']}',
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
                                        'Customer Name',
                                        '${order?['customer_name']}',
                                      ),
                                    ),
                                    Expanded(
                                      child: _infoItem(
                                        context,
                                        'Customer Phone',
                                        '${order?['customer_phone']}',
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
                                        'Status',
                                        '${order?['status']}',
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
                    SizedBox(height: 24),

                    // Items Info
                    Text(
                      "Items Information",
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge!.copyWith(fontSize: 18),
                    ),
                    SizedBox(height: 24),
                    Container(
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                          bottom: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: order?['items']?.length ?? 0,
                        itemBuilder: (context, index) {
                          final itemData = order!['items'][index];
                          final item =
                              itemData['item']; // relasi item// relasi category
                          final qty = itemData['qty']; // quantity

                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 16,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://i.pinimg.com/736x/e6/f8/d3/e6f8d3fb3de4e58d6404a110aca371d5.jpg',
                                  ),
                                  radius: 24,
                                ),
                                SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item['name']}", // kalau ada nama item bisa diganti
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E293B),
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      "${item['sku']}",
                                      style: TextStyle(
                                        color: Color(0xFF64748B),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    "$qty ${item['unit']}",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    // Status Button
                    Row(
                      children: [
                        // Expanded(
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => HomePage(),
                        //         ),
                        //       );
                        //     },
                        //     child: Container(
                        //       padding: EdgeInsets.symmetric(vertical: 16),
                        //       decoration: BoxDecoration(
                        //         color: Theme.of(context).colorScheme.primary,
                        //         borderRadius: BorderRadius.circular(16),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Theme.of(
                        //               context,
                        //             ).colorScheme.primary.withOpacity(0.3),
                        //             blurRadius: 10,
                        //             offset: Offset(0, 5),
                        //           ),
                        //         ],
                        //       ),
                        //       child: Row(
                        //         mainAxisAlignment: MainAxisAlignment.center,
                        //         children: [
                        //           Text(
                        //             "Mark As Delivered",
                        //             style: TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 12,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           SizedBox(width: 8),
                        //           Icon(Icons.check, color: Colors.white),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        SizedBox(width: 16), // spacing antar tombol
                        Expanded(
                          child: GestureDetector(
                            onTap: order?['status'] == "delivered"
                                ? null // disable kalo udah delivered
                                : () async {
                                    String currentStatus = order!['status'];
                                    String nextStatus;

                                    if (currentStatus == "assigned") {
                                      nextStatus = "picked_up";
                                    } else if (currentStatus == "picked_up") {
                                      nextStatus = "in_transit";
                                    } else if (currentStatus == "in_transit") {
                                      nextStatus = "delivered";
                                    } else {
                                      return;
                                    }

                                    await AuthService().updateOrderStatus(
                                      order?['id'],
                                      nextStatus,
                                    );

                                    // biar UI langsung update
                                    setState(() {
                                      order!['status'] = nextStatus;
                                    });
                                  },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: getStatusColor(order!['status']),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: getStatusColor(order!['status']),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${order?['status']}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.local_shipping,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
