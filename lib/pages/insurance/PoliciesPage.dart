import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class PoliciesPage extends StatefulWidget {
  const PoliciesPage({super.key});

  @override
  State<PoliciesPage> createState() => _PoliciesPageState();
}

class _PoliciesPageState extends State<PoliciesPage> {
  final List<Map<String, dynamic>> policies = [
    {
      'name': 'Health Shield Plan',
      'id': 'POL123456',
      'company': 'ABC Health Insurance',
      'startDate': '2023-01-01',
      'endDate': '2026-01-01',
      'coverage': 1000000,
      'premium': 15000,
      'status': 'Active'
    },
    {
      'name': 'Family Secure',
      'id': 'POL789123',
      'company': 'XYZ Life Insurance',
      'startDate': '2022-06-01',
      'endDate': '2025-06-01',
      'coverage': 500000,
      'premium': 12000,
      'status': 'Expiring Soon'
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
                "My Policy",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              centerTitle: true,
            ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Policy Summary Overview", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              _buildOverviewSection(),
              SizedBox(height: 24.h),
              const Text("Upcoming Renewals", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              _buildRenewalReminders(),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("My Policies", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text("Add Existing Policies"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue,
                    ),
                  )
                ],
              ),
              SizedBox(height: 12.h),
              ...policies.map((policy) => _buildPolicyCard(policy)),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
          ),
       // ],
      //),
    );
  }

  Widget _buildOverviewSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildOverviewBox("Active Policies", 3, Colors.green),
          _buildOverviewBox("Expiring Soon", 1, Colors.orange),
          _buildOverviewBox("Expired", 0, Colors.red),
        ],
      ),
    );
  }

  Widget _buildOverviewBox(String title, int count, Color color) {
    return Column(
      children: [
        Text(count.toString(), style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: color)),
        SizedBox(height: 4.h),
        Text(title, style: TextStyle(fontSize: 14.sp))
      ],
    );
  }

  Widget _buildRenewalReminders() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Family Secure", style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("Expires on: 2025-06-01")
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text("Renew Now"),
          )
        ],
      ),
    );
  }

  Widget _buildPolicyCard(Map<String, dynamic> policy) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 6, offset: const Offset(0, 3))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(policy['name'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp)),
              Chip(
                label: Text(policy['status'], style: const TextStyle(color: Colors.white)),
                backgroundColor: policy['status'] == 'Active' ? Colors.green : Colors.orange,
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text("Policy ID: ${policy['id']}", style: TextStyle(fontSize: 13.sp)),
          Text("Company: ${policy['company']}", style: TextStyle(fontSize: 13.sp)),
          Text("Start: ${policy['startDate']} | End: ${policy['endDate']}", style: TextStyle(fontSize: 13.sp)),
          Text("Coverage: ₹${policy['coverage']}", style: TextStyle(fontSize: 13.sp)),
          Text("Premium Paid: ₹${policy['premium']}", style: TextStyle(fontSize: 13.sp)),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 10.w,
            children: [
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.file_present), label: const Text("Details")),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.payment), label: const Text("Renew")),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit), label: const Text("Modify")),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.shield), label: const Text("Claim")),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_box), label: const Text("Add To JeeId")),
            ],
          ),
          Divider(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("🔔 Renewal Reminder", style: TextStyle(fontSize: 13.sp)),
              Switch(value: true, onChanged: (_) {})
            ],
          )
        ],
      ),
    );
  }
}