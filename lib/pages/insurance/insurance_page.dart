import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import '../../screens/notification_page.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  String userType = 'Individual';
  DateTime? dob;
  RangeValues coverageRange = const RangeValues(200000, 5000000);
  String city = '';
  int policyDuration = 1;
  String hasPreExisting = 'No';

  final List<String> userTypes = ['Individual', 'Family', 'Senior Citizen'];
  final List<String> durations = ['1 year', '2 years', '3 years'];
  final List<String> preExistingOptions = ['Yes', 'No'];

  final TextEditingController cityController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  void _resetForm() {
    setState(() {
      userType = 'Individual';
      dob = null;
      coverageRange = const RangeValues(200000, 5000000);
      city = '';
      cityController.clear();
      policyDuration = 1;
      hasPreExisting = 'No';
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainPage())),
          ),
          title: const Text("Find Insurance", style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationPage())),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search Insurance Policies...',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
              SizedBox(height: 16.h),
              const Text("Search for Best Policies", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              _buildDropdown("User Type", userTypes, userType, (val) => setState(() => userType = val!)),
              SizedBox(height: 12.h),
              _buildDatePicker("Date of Birth", dob, () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 3650)),
                  firstDate: DateTime(1940),
                  lastDate: DateTime.now(),
                );
                setState(() => dob = picked);
              }),
              SizedBox(height: 12.h),
              Text("Coverage Needed: ₹${coverageRange.start ~/ 1000}K - ₹${coverageRange.end ~/ 100000}L"),
              RangeSlider(
                min: 200000,
                max: 5000000,
                divisions: 24,
                values: coverageRange,
                onChanged: (val) => setState(() => coverageRange = val),
              ),
              SizedBox(height: 12.h),
              _buildTextField("City / PIN Code", cityController, (val) => setState(() => city = val)),
              SizedBox(height: 12.h),
              _buildDropdown("Policy Duration", durations, durations[policyDuration - 1], (val) {
                setState(() => policyDuration = durations.indexOf(val!) + 1);
              }),
              SizedBox(height: 12.h),
              _buildDropdown("Pre-existing Conditions", preExistingOptions, hasPreExisting, (val) => setState(() => hasPreExisting = val!)),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.search),
                      label: const Text("Find Policies"),
                      style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14.h)),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Reset"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.r),
                  image: const DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/600x150.png?text=🎉+Limited+Time+Offer+on+Top+Policies!'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4.h),
                    )
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              const Text("Popular Categories", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 12.h),
              SizedBox(
                height: 100.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCard("Best for Family"),
                    _buildCard("Low Premium Policies"),
                    _buildCard("Maternity Cover"),
                    _buildCard("COVID-19 Cover"),
                    _buildCard("Best for Senior Citizens"),
                  ],
                ),
              ),
              SizedBox(height: 30.h),
              const Text("Why Choose Us?", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10.h),
              _buildHighlight("IRDAI Approved Insurers"),
              _buildHighlight("Transparent Premiums & No Hidden Charges"),
              _buildHighlight("Secure & Encrypted Payments (ISO Certified)"),
              _buildHighlight("Trusted by Thousands of Users")
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String selected, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        SizedBox(height: 4.h),
        DropdownButtonFormField<String>(
          value: selected,
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r))),
        )
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime? value, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        child: Text(value == null ? 'Select Date' : '${value.year}-${value.month}-${value.day}'),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, Function(String) onChanged) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
      ),
    );
  }

  Widget _buildCard(String label) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3.h),
          )
        ],
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500, fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildHighlight(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          const Icon(Icons.verified, color: Colors.green, size: 20),
          SizedBox(width: 8.w),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
