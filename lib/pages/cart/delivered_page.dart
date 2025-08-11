import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class DeliveredPage extends StatefulWidget {
  const DeliveredPage({super.key});

  @override
  State<DeliveredPage> createState() => _DeliveredPageState();
}

class _DeliveredPageState extends State<DeliveredPage> {
  final List<Map<String, dynamic>> deliveredOrders = [
    {
      'orderId': 'ORD12345',
      'orderDate': '2025-07-01',
      'deliveredDate': '2025-07-03',
      'amount': 340,
      'prescription': true,
      'products': [
        {'name': 'Paracetamol', 'quantity': 2, 'image': Icons.medication},
        {'name': 'Vitamin C', 'quantity': 1, 'image': Icons.local_pharmacy},
      ]
    },
    {
      'orderId': 'ORD67890',
      'orderDate': '2025-06-15',
      'deliveredDate': '2025-06-17',
      'amount': 180,
      'prescription': false,
      'products': [
        {'name': 'Zincovit', 'quantity': 1, 'image': Icons.medical_services},
      ]
    },
  ];

  String searchQuery = '';
  DateTimeRange? selectedDateRange;

  List<Map<String, dynamic>> get filteredOrders {
    return deliveredOrders.where((order) {
      final matchSearch = searchQuery.isEmpty ||
          order['orderId'].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
          order['products'].any((product) =>
              product['name'].toLowerCase().contains(searchQuery.toLowerCase()));

      final matchDate = selectedDateRange == null ||
          (DateTime.parse(order['orderDate']).isAfter(selectedDateRange!.start.subtract(const Duration(days: 1))) &&
           DateTime.parse(order['orderDate']).isBefore(selectedDateRange!.end.add(const Duration(days: 1))));

      return matchSearch && matchDate;
    }).toList();
  }
@override
Widget build(BuildContext context) {
  return WillPopScope(
    onWillPop: () async {
      final popped = await Navigator.maybePop(context);
      return popped; // only allow back navigation if something was popped
    },
    child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          iconSize: 24.r,
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 24.r),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context); // just go back
            } else {
              // Optional: only if this is the root page and you want to go to main
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const MainPage()),
              );
            }
          },
        ),

        title: const Text('Delivered Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () async {
              DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2023),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                setState(() => selectedDateRange = picked);
              }
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search by medicine or order ID',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
              ),
              onChanged: (val) => setState(() => searchQuery = val.trim()),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView.builder(
                itemCount: filteredOrders.length,
                itemBuilder: (context, index) {
                  final order = filteredOrders[index];
                  return Container(
                    margin: EdgeInsets.only(bottom: 10.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Order ID: ${order['orderId']}', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text('₹ ${order['amount']}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500))
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text('Order Date: ${order['orderDate']}'),
                        Text('Delivered: ${order['deliveredDate']}'),
                        if (order['prescription'])
                          Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.description_outlined, size: 16),
                              label: const Text('Prescription'),
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.blue),
                            ),
                          ),
                        Divider(),
                        Column(
                          children: order['products'].map<Widget>((product) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(product['image'], size: 26.r),
                            title: Text(product['name']),
                            subtitle: Text('Qty: ${product['quantity']}'),
                            trailing: TextButton(
                              onPressed: () {},
                              child: const Text('Reorder'),
                            ),
                          )).toList(),
                        ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: [
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                              label: const Text('Invoice'),
                            ),
                            OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.star_border, size: 18),
                              label: const Text('Rate'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.shopping_cart_checkout, size: 18),
                              label: const Text('Reorder All'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
