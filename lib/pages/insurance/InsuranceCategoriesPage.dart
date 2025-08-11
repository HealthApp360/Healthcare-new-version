import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';

class InsuranceCategoriesPage extends StatefulWidget {
  const InsuranceCategoriesPage({super.key});

  @override
  State<InsuranceCategoriesPage> createState() => _InsuranceCategoriesPageState();
}

class _InsuranceCategoriesPageState extends State<InsuranceCategoriesPage> {
  final TextEditingController _searchController = TextEditingController();

  final Map<String, List<Map<String, dynamic>>> categoryGroups = {
    'Health Insurance': [
      {'title': 'Individual Health Plan', 'description': 'Basic health coverage.', 'icon': Icons.local_hospital, 'tags': ['Individual']},
      {'title': 'Family Health Plan', 'description': 'Comprehensive family coverage.', 'icon': Icons.family_restroom, 'tags': ['Family']},
      {'title': 'Affordable Health Cover', 'description': 'Low premium for essential care.', 'icon': Icons.health_and_safety, 'tags': ['Low Premium']},
      {'title': 'Long Term Health', 'description': '5+ years of coverage.', 'icon': Icons.timer, 'tags': ['Long Term']},
      {'title': 'Maternity Plan', 'description': 'Coverage for maternity expenses.', 'icon': Icons.pregnant_woman, 'tags': ['Family']},
      {'title': 'Surgery Cover', 'description': 'Covers major surgeries.', 'icon': Icons.healing, 'tags': ['Individual', 'Long Term']},
    ],
    'Life Insurance': [
      {'title': 'Term Life Insurance', 'description': 'Fixed term financial security.', 'icon': Icons.favorite, 'tags': ['Individual']},
      {'title': 'Whole Life Insurance', 'description': 'Life-long protection plan.', 'icon': Icons.security, 'tags': ['Family']},
      {'title': 'Smart Life Saver', 'description': 'Low cost, high return.', 'icon': Icons.trending_up, 'tags': ['Low Premium']},
      {'title': 'Legacy Plus Plan', 'description': 'Coverage for the long haul.', 'icon': Icons.all_inclusive, 'tags': ['Long Term']},
      {'title': 'Child Life Plan', 'description': 'Protection for children\'s future.', 'icon': Icons.child_care, 'tags': ['Family']},
    ],
    'Critical Illness Insurance': [
      {'title': 'Cancer Cover', 'description': 'Dedicated plan for cancer treatment.', 'icon': Icons.sick, 'tags': ['Individual']},
      {'title': 'Heart Disease Cover', 'description': 'Support for cardiac conditions.', 'icon': Icons.favorite_border, 'tags': ['Family']},
      {'title': 'Stroke Recovery Plan', 'description': 'Post-stroke health support.', 'icon': Icons.bolt, 'tags': ['Long Term']},
      {'title': 'Multi-Illness Cover', 'description': 'Covers major critical illnesses.', 'icon': Icons.health_and_safety, 'tags': ['Individual', 'Low Premium']},
    ],
    'Accident & Disability': [
      {'title': 'Accident Shield', 'description': 'Covers accidental injuries.', 'icon': Icons.warning, 'tags': ['Individual']},
      {'title': 'Family Accident Plan', 'description': 'Family wide protection.', 'icon': Icons.groups, 'tags': ['Family']},
      {'title': 'Essential Accident Cover', 'description': 'Affordable safety plan.', 'icon': Icons.shield, 'tags': ['Low Premium']},
      {'title': 'Disability Income Plan', 'description': 'Income support on disability.', 'icon': Icons.money_off, 'tags': ['Long Term']},
    ]
  };

  String selectedTag = 'All';
  final List<String> tags = ['All', 'Individual', 'Family', 'Low Premium', 'Long Term'];

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
                "Insurance Categories",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              centerTitle: true,
            ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildSearchBar(),
            SizedBox(height: 10.h),
            _buildTagFilters(),
            SizedBox(height: 10.h),
            Expanded(child: _buildScrollableCategories()),
          ],
        ),
      ),
          ),
       // ],
      );
    //);
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search by Category or Provider...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  Widget _buildTagFilters() {
    return SizedBox(
      height: 35.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tags.length,
        separatorBuilder: (_, __) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final tag = tags[index];
          return ChoiceChip(
            label: Text(tag),
            selected: selectedTag == tag,
            onSelected: (_) => setState(() => selectedTag = tag),
          );
        },
      ),
    );
  }

  Widget _buildScrollableCategories() {
    return ListView(
      children: categoryGroups.entries.map((entry) {
        final filteredItems = entry.value.where((item) {
          if (selectedTag == 'All') return true;
          return (item['tags'] as List).contains(selectedTag);
        }).toList();

        if (filteredItems.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: Text(
                entry.key,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 200.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: filteredItems.length,
                separatorBuilder: (_, __) => SizedBox(width: 10.w),
                itemBuilder: (context, index) => _buildCard(filteredItems[index]),
              ),
            )
          ],
        );
      }).toList(),
    );
  }

  Widget _buildCard(Map<String, dynamic> data) {
    return Container(
      width: 180.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 6, offset: const Offset(2, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(data['icon'], size: 32.sp, color: Colors.blue),
          SizedBox(height: 10.h),
          Text(data['title'], style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 6.h),
          Text(data['description'], style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade700), maxLines: 3),
          const Spacer(),
          const Text("⭐ Top Rated Providers", style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
