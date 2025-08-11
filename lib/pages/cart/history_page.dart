import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';



  /*@override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Main Page")));
  }
}*/

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final List<Map<String, dynamic>> historyOrders = [
    {
      'orderId': 'ORD001245',
      'orderDate': '2024-07-21',
      'deliveryAddress': '123 Main Street, Mumbai',
      'paymentMethod': 'Credit Card',
      'status': 'Out for Delivery',
      'products': [
        {'name': 'Dolo 650', 'quantity': 1},
        {'name': 'Vitamin C Tablets', 'quantity': 2},
        {'name': 'Cough Syrup', 'quantity': 1},
      ]
    },
    {
      'orderId': 'ORD001231',
      'orderDate': '2024-06-14',
      'deliveryAddress': '42 Banjara Hills, Hyderabad',
      'paymentMethod': 'UPI',
      'status': 'Shipped',
      'products': [
        {'name': 'Face Wash', 'quantity': 1},
        {'name': 'Antiseptic Cream', 'quantity': 1},
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final popped = await Navigator.maybePop(context);
        return popped;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('Order History', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            iconSize: 24.r,
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.r),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainPage()),
                );
              }
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: ListView.builder(
            itemCount: historyOrders.length,
            itemBuilder: (context, index) {
              final order = historyOrders[index];
              final displayedProducts = order['products'].take(2).toList();
              final remainingCount = order['products'].length - displayedProducts.length;

              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Order ID: ${order['orderId']}",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
                        Chip(
                          label: Text(order['status'], style: TextStyle(fontSize: 10.sp)),
                          backgroundColor: Colors.blue.shade50,
                        )
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text("Order Date: ${order['orderDate']}", style: TextStyle(fontSize: 12.sp)),
                    Text("Address: ${order['deliveryAddress']}", style: TextStyle(fontSize: 12.sp)),
                    Text("Payment: ${order['paymentMethod']}", style: TextStyle(fontSize: 12.sp)),
                    Divider(height: 20.h, color: Colors.grey.shade300),
                    Text('Items:', style: TextStyle(fontWeight: FontWeight.w600)),
                    ...displayedProducts.map((p) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                          child: Text("• ${p['name']} x${p['quantity']}", style: TextStyle(fontSize: 12.sp)),
                        )),
                    if (remainingCount > 0)
                      Text("+ $remainingCount more", style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
