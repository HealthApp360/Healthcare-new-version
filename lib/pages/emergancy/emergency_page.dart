import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:healthcare_app/main_page.dart';

class EmergencyPage extends StatefulWidget {
  const EmergencyPage({super.key});

  @override
  State<EmergencyPage> createState() => _EmergencyPageState();
}

class _EmergencyPageState extends State<EmergencyPage> {
  double _dragOffset = 0.0;
  final double _maxDrag = 100.0;
  bool _slideComplete = false;

  final String abhaId = '89913081WED';
  final String jeeTag = '18W03E1998D';

  String _maskId(String id) {
    return id.replaceRange(4, id.length - 4, '*' * (id.length - 8));
  }

  void _showQrDialog(String data) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(20),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: MediaQuery.of(context).size.width * 0.75,
          child: Center(
            child: QrImageView(
              data: data,
              version: QrVersions.auto,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
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

          centerTitle: true,
          title: Text('Emergency', style: TextStyle(fontSize: 16.sp, color: Colors.black)),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 156, 230, 255),
                Color.fromARGB(255, 255, 255, 255),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 100.h,
                        width: 100.h,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.person, size: 60.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 16.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("John Doe", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8.h),
                          Text("Age: 28", style: TextStyle(fontSize: 14.sp)),
                          Text("Gender: Male", style: TextStyle(fontSize: 14.sp)),
                          Text("Weight: 70 kgs", style: TextStyle(fontSize: 14.sp)),
                          Text("Height: 5’ 9”", style: TextStyle(fontSize: 14.sp)),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text("Blood Type: O+", style: TextStyle(color: Colors.white, fontSize: 12.sp)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Divider(thickness: 1.h),
                Text("PRE-EXISTING CONDITIONS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp, color: Colors.red)),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text("Asthma, Anxiety disorder", style: TextStyle(fontSize: 13.sp)),
                ),
                Divider(thickness: 1.h),
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("EMERGENCY CONTACT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp)),
                      SizedBox(height: 4.h),
                      Text("Henry (Friend)", style: TextStyle(fontSize: 13.sp)),
                      Row(
                        children: [
                          Text("Phone no: 888-588-8888", style: TextStyle(color: Colors.blue, fontSize: 13.sp)),
                          SizedBox(width: 4.w),
                          Icon(Icons.phone, color: Colors.green, size: 18.sp),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10.h),
                GestureDetector(
                  onTap: () => _showQrDialog(jeeTag),
                  child: Icon(Icons.qr_code, size: 100.sp),
                ),
                SizedBox(height: 10.h),
                Text("ABHA ID: ${_maskId(abhaId)}", style: TextStyle(fontSize: 14.sp)),
                Text("JEETAG: ${_maskId(jeeTag)}", style: TextStyle(fontSize: 14.sp)),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      setState(() {
                        _dragOffset += details.delta.dx;
                        if (_dragOffset >= _maxDrag) {
                          _dragOffset = _maxDrag;
                          _slideComplete = true;
                        }
                      });
                    },
                    onHorizontalDragEnd: (_) {
                      setState(() {
                        if (_slideComplete) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Slide complete! Emergency triggered")),
                          );
                        }
                        _dragOffset = 0.0;
                        _slideComplete = false;
                      });
                    },
                    child: Stack(
                      children: [
                        Container(
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "SLIDE TO CALL AMBULANCE",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                          ),
                        ),
                        Positioned(
                          left: _dragOffset,
                          child: Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.emergency, color: Colors.white, size: 28.sp),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                Text("Use this only when there is an emergency", style: TextStyle(fontSize: 12.sp, color: Colors.black54)),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
