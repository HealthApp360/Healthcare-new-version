import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:healthcare_app/cart_storage.dart';
import 'package:healthcare_app/main_page.dart';
//import 'package:healthcare_app/cart/cart_storage.dart';



class CartPage extends StatefulWidget {
  //final List<Map<String, dynamic>> initialCartItems;

  const CartPage({super.key, });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems =globalCart;
  }

  String deliveryOption = 'Standard';
  String promoCode = '';

  double get subtotal =>
      cartItems.fold(0.0, (sum, item) => sum + (item['quantity'] * item['price']));

  double get discount => promoCode == 'SAVE10' ? 10.0 : 0.0;
  double get deliveryFee => deliveryOption == 'Express' ? 20.0 : 0.0;
  double get total => subtotal - discount + deliveryFee;

  void increaseQty(int index) =>
      setState(() => cartItems[index]['quantity']++);

  void decreaseQty(int index) {
    if (cartItems[index]['quantity'] > 1) {
      setState(() => cartItems[index]['quantity']--);
    }
  }

  void removeItem(int index) =>
      setState(() => cartItems.removeAt(index));

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
          title: const Text('My Cart'),
          centerTitle: true,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 12.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(item['image'], size: 32.r, color: const Color.fromARGB(255, 74, 204, 236)),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item['name'], style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15.sp)),
                                if (item['requiresPrescription'])
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.h),
                                    child: Text("Prescription Required", style: TextStyle(color: Colors.red, fontSize: 11.sp)),
                                  ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
                                      onPressed: () => decreaseQty(index),
                                    ),
                                    Text('${item['quantity']}', style: TextStyle(fontSize: 16.sp)),
                                    IconButton(
                                      icon: Icon(Icons.add_circle_outline, color: Colors.grey),
                                      onPressed: () => increaseQty(index),
                                    ),
                                    const Spacer(),
                                    Text("₹ ${item['quantity'] * item['price']}", style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => removeItem(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Promo Code',
                        suffixIcon: Icon(Icons.discount, color: const Color.fromARGB(255, 74, 204, 236)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                      ),
                      onChanged: (val) => setState(() => promoCode = val.trim()),
                    ),

                    SizedBox(height: 12.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Delivery Option:"),
                        DropdownButton<String>(
                          value: deliveryOption,
                          items: ['Standard', 'Express']
                              .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => setState(() => deliveryOption = val!),
                        ),
                      ],
                    ),

                    Divider(),

                    _priceRow('Subtotal', subtotal),
                    _priceRow('Discount', -discount),
                    _priceRow('Delivery Fee', deliveryFee),
                    _priceRow('Total', total, isTotal: true),
                  ],
                ),
              ),
              SizedBox(height: 12.h),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: const Text("Continue Shopping"),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 74, 204, 236),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                      ),
                      child: const Text("Checkout"),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text('₹ ${amount.toStringAsFixed(2)}', style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
