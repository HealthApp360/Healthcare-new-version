import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class FetchingDataScreen extends StatelessWidget {
  const FetchingDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: 
       Column(
        mainAxisSize: MainAxisSize.min,
         children: [
           Lottie.asset("assets/fetching.json"),
           SizedBox(height: 20,),
           Text('Fetching Data....',style: TextStyle(color: Colors.grey),)
         ],
       )
        // Column(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     CircularProgressIndicator(),
        //     SizedBox(height: 16),
        //     Text(
        //       "Fetching data...",
        //       style: TextStyle(fontSize: 18),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}