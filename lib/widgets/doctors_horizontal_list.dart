import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare_app/pages/consult_doctor/doctor_profile_page.dart';

class DoctorsHorizontalList extends StatelessWidget {
  const DoctorsHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').limit(20).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading doctors"));
          }

          final docs = snapshot.data?.docs ?? [];
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doctor = docs[index].data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DoctorProfilePage(doctor: doctor,doctorId: docs[index].id),
                    ),
                  );
                },
                child: Container(
                  width: 160,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: 
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                              CircleAvatar(
                          radius: 30,
                          backgroundImage: 
                          NetworkImage(doctor["profilePicture"] ?? "",),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(10),
                          child: Container(
                           color: Colors.blueAccent,
                           padding: EdgeInsets.all(5),
                            child: Text("Avaliable",style: TextStyle(fontSize: 12,color: Colors.white),)),
                        )
                      ],
                    ),
                        const SizedBox(height: 8),
                       Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                           Text(
                          doctor["fullName"] ?? "Unknown",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          doctor["specialization"] ?? "",
                          style: TextStyle(color: Colors.grey[600], fontSize: 14),
                        ),
                        ],
                       ),
                       SizedBox(height: 30,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset("assets/star.png",width: 18,height: 18,),
                    
                                  SizedBox(width: 5,),
                                   Text(
                          "${doctor["rating"] ?? ""}",
                          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                        ),
                                ],
                              ),
                               Text(
                          "₹${doctor["consultationFee"] ?? ""}",
                          style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.w400,fontSize: 20),
                        ),
                        ],
                       )
                      ],
                    ),
                  )
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     CircleAvatar(
                  //       radius: 40,
                  //       backgroundImage: NetworkImage(doctor["profilePicture"] ?? ""),
                  //     ),
                  //     const SizedBox(height: 8),
                  //     Text(
                  //       doctor["fullName"] ?? "Unknown",
                  //       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  //       textAlign: TextAlign.center,
                  //       maxLines: 1,
                  //       overflow: TextOverflow.ellipsis,
                  //     ),
                  //     Text(
                  //       doctor["specialization"] ?? "",
                  //       style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //     const SizedBox(height: 6),
                  //     Text(
                  //       "₹${doctor["consultationFee"] ?? ""}",
                  //       style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  //     ),
                  //   ],
                  // ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
