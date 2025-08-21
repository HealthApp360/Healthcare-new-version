import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../screens/passcode_screen.dart';

class DigitalIDCard extends StatelessWidget {
  final String name;
  final String jeeId;
  final String abhaNumber;
  final String imageUrl;
  final Function(String)? onTabChanged;

  const DigitalIDCard({
    super.key,
    required this.name,
    required this.jeeId,
    required this.abhaNumber,
    required this.imageUrl,
    this.onTabChanged,
  });

  String _maskAbha(String abha) {
    return abha.replaceRange(4, abha.length - 4, '*' * (abha.length - 8));
  }
void _showQrDialog(BuildContext context, String jeeId) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      contentPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Builder(
        builder: (context) {
          final width = MediaQuery.of(context).size.width * 0.75;

          return SizedBox(
            width: width,
            height: width,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: PrettyQrView.data(
                data: jeeId, // your ID string
                decoration: PrettyQrDecoration(
                  shape: const PrettyQrSmoothSymbol(), // rounded style
                  // image: const PrettyQrDecorationImage(
                  //   image: AssetImage('assets/logo.png'), // optional logo
                  // ),
                  background: Colors.white,
                  quietZone: PrettyQrQuietZone.standart, // padding around QR
                ),
              ),
            ),
          );
        },
      ),
    ),
  );
}
//  void _showQrDialog(BuildContext context, String jeeId) {
//   showDialog(
//     context: context,
//     barrierDismissible: true,
//     builder: (context) => AlertDialog(
//       backgroundColor: Colors.white,
//       contentPadding: EdgeInsets.all(24),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       content: Builder(
//         builder: (context) {
//           final width = MediaQuery.of(context).size.width * 0.75;
//           return SizedBox(
//             width: width,
//             height: width,
//             child: Container(
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child:
//               QrImageView(
//                 data: jeeId,
//                 version: QrVersions.auto,
//                 backgroundColor: Colors.white,
//               ),
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }



 @override
Widget build(BuildContext context) {
  final user = FirebaseAuth.instance.currentUser;
 final userDocRef = FirebaseFirestore.instance.collection('users').doc(user!.uid);
 var jeeid = "";

  return GestureDetector(
    onTap: () async {
      final authenticated = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const PasscodeScreen()),
      );
      if (authenticated == true) {
        onTabChanged?.call('digitalid');
      }
    },
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 188, 250, 247),
            Color.fromARGB(255, 118, 205, 237),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.3),
            blurRadius: 5.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "JEETAG",
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 0, 0, 0),
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                backgroundColor: Colors.grey.shade300,
                child: imageUrl.isEmpty
                    ? Icon(Icons.person, size: 24.r, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.displayName ?? 'User',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                      FutureBuilder<DocumentSnapshot>(
                future: userDocRef.get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    //return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.hasData && snapshot.data!.exists) {
                    final userData = snapshot.data!.data() as Map<String, dynamic>;
                    final customId = userData['customId'];
                    jeeid = customId;
                    // return Text(
                    //   customId ?? 'ID not found',
                    //   style: const TextStyle(fontSize: 20, color: Colors.blueAccent),
                    // );
                    return Text(
                      "JEE ID: ${_maskAbha(customId)}",
                      style: TextStyle(fontSize: 11.sp, color: const Color.fromARGB(255, 0, 0, 0)),
                    );
                  }
                  return  Text('JEE ID:',style: TextStyle(fontSize: 11.sp, color: const Color.fromARGB(255, 0, 0, 0)));
                },
              ),
                    
                    Text(
                      "ABHA: ${_maskAbha(abhaNumber)}",
                      style: TextStyle(fontSize: 11.sp, color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _showQrDialog(context, jeeid),
                icon: Icon(Icons.qr_code, color: const Color.fromARGB(255, 0, 0, 0), size: 50.r),
                tooltip: "Show QR",
              ),
              
            ],
          ),
        ],
      ),
    ),
  );
}
}