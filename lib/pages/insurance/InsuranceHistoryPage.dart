import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:intl/intl.dart';

class InsuranceHistoryPage extends StatefulWidget {
  const InsuranceHistoryPage({super.key});

  @override
  State<InsuranceHistoryPage> createState() => _InsuranceHistoryPageState();
}

class _InsuranceHistoryPageState extends State<InsuranceHistoryPage> {
  final TextEditingController searchController = TextEditingController();
  DateTimeRange? dateRange;
  String selectedStatus = 'All';
  final List<String> statusOptions = ['All', 'Active', 'Expired', 'Claimed', 'Cancelled'];

  final List<Map<String, dynamic>> historyData = [
    {
      'type': 'Purchased',
      'date': DateTime(2022, 1, 10),
      'policy': 'Health Shield Plan',
      'insurer': 'ABC Health Insurance'
    },
    {
      'type': 'Renewed',
      'date': DateTime(2023, 1, 8),
      'policy': 'Health Shield Plan',
      'insurer': 'ABC Health Insurance'
    },
    {
      'type': 'Claimed',
      'date': DateTime(2023, 7, 15),
      'policy': 'Family Secure',
      'insurer': 'XYZ Life Insurance',
      'amount': 30000
    },
    {
      'type': 'Expired',
      'date': DateTime(2021, 6, 1),
      'policy': 'Basic Travel Plan',
      'insurer': 'TravelEasy'
    },
  ];
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

              title: Text(
                "Insurance History",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              centerTitle: true,
            ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchAndFilters(),
            SizedBox(height: 20.h),
            const Text("Claim Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            _buildClaimSummary(),
            SizedBox(height: 20.h),
            const Text("History Timeline", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.separated(
                itemCount: historyData.length,
                separatorBuilder: (_, __) => Divider(height: 16.h),
                itemBuilder: (context, index) {
                  final item = historyData[index];
                  return ListTile(
                    tileColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    leading: Icon(_getIcon(item['type']), color: Colors.blue),
                    title: Text("${item['type']} - ${item['policy']}", style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text("${item['insurer']}\n${DateFormat('yyyy-MM-dd').format(item['date'])}"),
                    trailing: item['type'] == 'Claimed'
                        ? Text("+₹${item['amount']}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold))
                        : const Icon(Icons.arrow_forward_ios, size: 16),
                    isThreeLine: true,
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
          ),
       // ],
      //),
    );
  }

  Widget _buildSearchAndFilters() {
    return Column(
      children: [
        TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search by Policy ID or Insurer Name',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: selectedStatus,
                items: statusOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => selectedStatus = val ?? 'All'),
                decoration: InputDecoration(
                  labelText: 'Filter by Status',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade100),
              onPressed: () async {
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => dateRange = picked);
              },
              icon: const Icon(Icons.date_range, color: Colors.purple),
              label: const Text("Filter Dates", style: TextStyle(color: Colors.purple)),
            )
          ],
        )
      ],
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'Purchased':
        return Icons.shopping_cart;
      case 'Renewed':
        return Icons.refresh;
      case 'Claimed':
        return Icons.assignment_turned_in;
      case 'Expired':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  Widget _buildClaimSummary() {
    int claims = historyData.where((e) => e['type'] == 'Claimed').length;
    int total = historyData.length;
    int totalAmount = historyData
        .where((e) => e['amount'] != null)
        .fold(0, (sum, e) => sum + (e['amount'] as num).toInt());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildSummaryBox("Claims Made", claims.toString(), Icons.assignment),
        _buildSummaryBox("Success Rate", total > 0 ? "${((claims / total) * 100).toStringAsFixed(1)}%" : "0%", Icons.percent),
        _buildSummaryBox("Total Reimbursed", "₹$totalAmount", Icons.payments),
      ],
    );
  }

  Widget _buildSummaryBox(String title, String value, IconData icon) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 26, color: Colors.blue),
          SizedBox(height: 6.h),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 4.h),
          Text(title, style: TextStyle(fontSize: 12.sp), textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
