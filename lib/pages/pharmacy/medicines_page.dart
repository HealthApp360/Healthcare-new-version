import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/cart_storage.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/cart/cart_page.dart' ;
//import 'package:healthcare_app/cart/cart_storage.dart';

class MedicinesPage extends StatefulWidget {
  const MedicinesPage({super.key});

  @override
  State<MedicinesPage> createState() => _MedicinesPageState();
}

class _MedicinesPageState extends State<MedicinesPage> {
  final List<String> brands = ["Cipla", "Sun Pharma", "Himalaya", "Zydus", "Dr. Reddy's"];
  final List<String> combos = ["ORS + Paracetamol", "Vitamin D + Calcium", "Cough Syrup + Antacid"];
  final List<String> medicineCards = ["Paracetamol", "Azithromycin", "Zincovit", "Dolo 650"];
  final List<String> bestDeals = ["Flat 20% Off", "Buy 1 Get 1", "₹50 Off on 2 Packs"];
  final List<String> recent = ["Crocin", "Cetirizine", "Metformin"];

  List<Map<String, dynamic>> cartItems = [];

void addToCart(String name) {
  final existingIndex = globalCart.indexWhere((item) => item['name'] == name);
  if (existingIndex != -1) {
    setState(() {
      globalCart[existingIndex]['quantity']++;
    });
  } else {
    setState(() {
      globalCart.add({
        "name": name,
        "image": Icons.medication,
        "quantity": 1,
        "price": 99,
        "requiresPrescription": false,
      });
    });
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$name added to cart')),
  );
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

          title: Text('Medicines',
              style: TextStyle(color: Colors.black, fontSize: 18.sp, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black, size: 24.r),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartPage()),
                ),
              ),
           // ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sectionTitle("Top Brands / Companies"),
                horizontalCardList(brands, Icons.business, Colors.blueAccent),

                sectionTitle("Popular Combinations"),
                horizontalCardList(combos, Icons.local_pharmacy, Colors.green),

                Container(
                  height: 120.h,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.orangeAccent, Colors.deepOrange],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      '🔥 Special Discount Offer!',
                      style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),

                sectionTitle("Medicines"),
                SizedBox(
                  height: 230.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: medicineCards.length,
                    itemBuilder: (context, index) => Container(
                      width: 160.w,
                      margin: EdgeInsets.symmetric(horizontal: 8.w),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.medication, size: 40.r, color: Colors.teal),
                          SizedBox(height: 12.h),
                          Text(medicineCards[index],
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                          Text('₹99', style: TextStyle(color: Colors.green, fontSize: 12.sp)),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => addToCart(medicineCards[index]),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                              child: Text('Add to Cart', style: TextStyle(fontSize: 12.sp)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                sectionTitle("Best Deals / Offers"),
                horizontalCardList(bestDeals, Icons.local_offer, Colors.redAccent),

                sectionTitle("Recently Viewed Medicines"),
                horizontalCardList(recent, Icons.history, Colors.grey.shade600),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(String title) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Text(title, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
      );

  Widget horizontalCardList(List<String> items, IconData icon, Color iconColor) => SizedBox(
        height: 120.h,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => Container(
            width: 160.w,
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 30.r, color: iconColor),
                SizedBox(height: 10.h),
                Text(items[index],
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp)),
              ],
            ),
          ),
        ),
      );
}
