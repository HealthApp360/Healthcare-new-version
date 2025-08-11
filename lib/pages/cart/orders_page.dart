import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  static const List<Map<String, dynamic>> orderHistory = [
    {
      "orderId": "ORD123456",
      "date": "Aug 4, 2025",
      "address": "123 Health St, Wellness City",
      "payment": "Credit Card",
      "status": "Out for Delivery",
      "items": ["Paracetamol", "Cough Syrup", "Vitamin C"],
    },
    {
      "orderId": "ORD789012",
      "date": "July 30, 2025",
      "address": "456 Med Lane, Curetown",
      "payment": "UPI",
      "status": "Packed",
      "items": ["Ibuprofen", "Antacid"],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final popped = await Navigator.maybePop(context);
        return popped; // allow back only if popped
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text('My Orders', style: TextStyle(color: Colors.black)),
          leading: IconButton(
            iconSize: 24.r,
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.r),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/main'); // replace with your actual route
              }
            },
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(12.w),
          itemCount: orderHistory.length,
          itemBuilder: (context, index) {
            final order = orderHistory[index];
            final items = order['items'] as List<String>;

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
                      Text('Order ID: ${order['orderId']}',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp)),
                      Text(order['date'],
                          style: TextStyle(color: Colors.grey[600], fontSize: 12.sp)),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text('Delivery to: ${order['address']}', style: TextStyle(fontSize: 12.sp)),
                  Text('Payment: ${order['payment']}', style: TextStyle(fontSize: 12.sp)),
                  SizedBox(height: 6.h),
                  Chip(
                    label: Text(order['status']),
                    backgroundColor: Colors.blue.shade50,
                  ),
                  Divider(height: 20.h, color: Colors.grey.shade200),
                  Text('Items:', style: TextStyle(fontWeight: FontWeight.w600)),
                  ...items.take(2).map((e) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        child: Text('• $e'),
                      )),
                  if (items.length > 2)
                    Text('+${items.length - 2} more',
                        style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.track_changes, size: 18),
                          label: const Text("Track"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 74, 204, 236),
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                          ),
                          child: const Text("Cancel / Modify"),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.picture_as_pdf, size: 18),
                        label: const Text("Invoice"),
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart, size: 18),
                        label: const Text("Reorder"),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
