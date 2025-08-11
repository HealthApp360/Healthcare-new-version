import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/main_page.dart';
import 'package:healthcare_app/pages/cart/cart_page.dart' hide MainPage;

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final Map<String, List<String>> categoryData = {
    "Skin Care & Dermatology": ["Acne Treatment", "Eczema/Psoriasis", "Fungal Infections", "Skin Allergies"],
    "Hair Care & Scalp Treatment": ["Hair Loss", "Dandruff", "Lice Treatment"],
    "Pain Relief": ["General Pain", "Joint & Muscle Pain", "Neuropathic Pain"],
    "First Aid & Emergency": ["Antiseptics", "Burn Treatment", "Wound Healing"],
    "Cold, Cough & Allergy": ["Cough Suppressants", "Expectorants", "Antihistamines", "Decongestants"],
    "Gastrointestinal (GI)": ["Acidity & Ulcers", "Constipation", "Diarrhea", "Nausea/Vomiting"],
    "Infectious Disease": ["Antibiotics", "Antivirals", "Antifungals", "Antiparasitics"],
    "Eye Care": ["Eye Infections", "Dry Eyes", "Allergic Conjunctivitis"],
    "Ear, Nose & Throat": ["Ear Drops", "Nasal Sprays", "Throat Lozenges"],
    "Chronic Diseases": ["Diabetes", "Hypertension", "Cholesterol"],
    "Mental Health": ["Anxiety/Depression", "Sleep Disorders", "Seizures"],
    "Women’s Health": ["Contraceptives", "Hormonal Therapy", "UTI/Infections"],
    "Men’s Health": ["Erectile Dysfunction", "Prostate Issues"],
    "Pediatrics": ["Fever & Cold", "Vaccinations", "Worm Infestations"],
    "Supplements": ["Multivitamins", "Calcium & Vitamin D", "Iron Supplements"],
    "Gastric": ["Indigestion", "Bloating", "Gas Relief"]
  };

  final List<Map<String, dynamic>> cartItems = [];

  void addToCart(String name) {
    setState(() {
      final existing = cartItems.indexWhere((item) => item['name'] == name);
      if (existing != -1) {
        cartItems[existing]['quantity']++;
      } else {
        cartItems.add({
          "name": name,
          "image": Icons.local_hospital,
          "quantity": 1,
          "price": 99,
          "requiresPrescription": false,
        });
      }
    });
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

          title: Text('Categories', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart, size: 24.r),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(),
                  ),
                );
              },
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for medicine...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        prefixIcon: Icon(Icons.search, size: 20.r),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryData.keys.length,
                  itemBuilder: (context, index) {
                    String category = categoryData.keys.elementAt(index);
                    List<String> subcategories = categoryData[category]!;

                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(category,
                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            height: 140.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: subcategories.length,
                              itemBuilder: (context, subIndex) {
                                return Container(
                                  width: 150.w,
                                  margin: EdgeInsets.symmetric(horizontal: 8.w),
                                  padding: EdgeInsets.all(10.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.local_hospital, color: Colors.teal, size: 26.r),
                                      SizedBox(height: 6.h),
                                      Text(
                                        subcategories[subIndex],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(height: 6.h),
                                      ElevatedButton(
                                        onPressed: () => addToCart(subcategories[subIndex]),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal,
                                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                        ),
                                        child: Text("Add to Cart", style: TextStyle(fontSize: 11.sp)),
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
