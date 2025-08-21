import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfilePage extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String doctorId;
  const DoctorProfilePage({super.key, required this.doctor, required this.doctorId});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  DateTime? selectedDate;
  String? selectedTime;

  // Example available slots
  final List<String> timeSlots = [
    "10:00 AM", "11:00 AM", "12:00 PM",
    "2:00 PM", "3:00 PM", "4:00 PM",
    "6:00 PM", "7:00 PM",
  ];

  void _showBookingSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Select Appointment Date",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Calendar Date Picker
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7, // next 7 days
                      itemBuilder: (context, index) {
                        DateTime date =
                            DateTime.now().add(Duration(days: index));
                        bool isSelected = selectedDate != null &&
                            DateFormat('yyyy-MM-dd').format(selectedDate!) ==
                                DateFormat('yyyy-MM-dd').format(date);

                        return GestureDetector(
                          onTap: () {
                            setModalState(() => selectedDate = date);
                          },
                          child: Container(
                            width: 80,
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blueAccent),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  DateFormat("EEE").format(date), // Mon, Tue
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Select Time Slot",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: timeSlots.map((slot) {
                      bool isSelected = selectedTime == slot;
                      return ChoiceChip(
                        label: Text(slot),
                        selected: isSelected,
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        onSelected: (_) {
                          setModalState(() => selectedTime = slot);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: (selectedDate != null && selectedTime != null)
                        ? () async {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please login to book appointment"),
                                ),
                              );
                              return;
                            }

                            // Save appointment to Firestore
                            await FirebaseFirestore.instance
                                .collection("appointments")
                                .add({
                              "userId": user.uid,
                              "userEmail": user.email,
                              "doctorId": widget.doctorId,
                              "doctorName": widget.doctor["fullName"],
                              "doctorSpecialization":
                                  widget.doctor["specialization"],
                              "appointmentDate": DateFormat("yyyy-MM-dd")
                                  .format(selectedDate!),
                              "appointmentTime": selectedTime,
                              "bookedAt": DateTime.now(),
                            });

                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Appointment booked on ${DateFormat("dd MMM, yyyy").format(selectedDate!)} at $selectedTime",
                                ),
                              ),
                            );
                          }
                        : null,
                    child: const Text("Confirm Appointment"),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;

    return Scaffold(
      appBar: AppBar(
        title: Text(doctor["fullName"] ?? "Doctor"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(doctor["profilePicture"] ?? ""),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                doctor["fullName"] ?? "",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: Text(
                doctor["specialization"] ?? "",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            const Text("About Doctor",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              doctor["bio"] ??
                  "Dr. ${"Unknown"} has over 10 years of experience in healthcare, providing trusted and personalized treatment for patients.",
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            const Text("Consultation Fee",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              "₹${doctor["consultationFee"] ?? "500"}",
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 55),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => _showBookingSheet(context),
          child: const Text("Book Appointment", style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class DoctorProfilePage extends StatefulWidget {
//   final String doctorId;
//   const DoctorProfilePage({super.key, required this.doctorId});

//   @override
//   State<DoctorProfilePage> createState() => _DoctorProfilePageState();
// }

// class _DoctorProfilePageState extends State<DoctorProfilePage> {
//   DateTime? selectedDate;
//   String? selectedTime;

//   List<String> availableSlots = [
//     "09:00 AM",
//     "10:00 AM",
//     "11:00 AM",
//     "12:00 PM",
//     "02:00 PM",
//     "03:00 PM",
//     "04:00 PM",
//   ];

//   List<String> bookedSlots = [];

//   @override
//   void initState() {
//     super.initState();
//     _fetchBookedSlots();
//   }

//   Future<void> _fetchBookedSlots() async {
//     final snapshot = await FirebaseFirestore.instance
//         .collection("appointments")
//         .where("doctorId", isEqualTo: widget.doctorId)
//         .get();

//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     setState(() {
//       bookedSlots = snapshot.docs
//           .map((doc) {
//             final data = doc.data();
//             final appointmentDate = (data["date"] as Timestamp).toDate();
//             final slotDate = DateTime(
//               appointmentDate.year,
//               appointmentDate.month,
//               appointmentDate.day,
//             );
//             if (slotDate == today) {
//               return data["time"] as String?;
//             }
//             return null;
//           })
//           .whereType<String>()
//           .toList();
//     });
//   }

//   Future<void> _bookAppointment(String doctorName) async {
//     if (selectedDate == null || selectedTime == null) return;

//     await FirebaseFirestore.instance.collection("appointments").add({
//       "doctorId": widget.doctorId,
//       "doctorName": doctorName,
//       "date": selectedDate,
//       "time": selectedTime,
//       "userId": "USER_123", // Replace with FirebaseAuth userId
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text("Appointment booked successfully!")),
//     );

//     _fetchBookedSlots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Doctor Profile")),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance
//             .collection("doctors")
//             .doc(widget.doctorId)
//             .get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           final data = snapshot.data!.data() as Map<String, dynamic>?;

//           if (data == null) {
//             return const Center(child: Text("Doctor data not found"));
//           }

//           final profilePicture = (data["profilePicture"] as String?) ?? "";
//           final fullName = (data["fullName"] as String?) ?? "Unknown Doctor";
//           final specialization =
//               (data["specialization"] as String?) ?? "Specialization not available";
//           final experience =
//               (data["experience"]?.toString()) ?? "Experience not available";
//           final location =
//               (data["location"] as String?) ?? "Location not available";

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 CircleAvatar(
//                   radius: 60,
//                   backgroundImage: profilePicture.isNotEmpty
//                       ? NetworkImage(profilePicture)
//                       : const AssetImage("assets/images/default_avatar.png")
//                           as ImageProvider,
//                 ),
//                 const SizedBox(height: 12),
//                 Text(fullName,
//                     style: const TextStyle(
//                         fontSize: 20, fontWeight: FontWeight.bold)),
//                 Text(specialization,
//                     style: TextStyle(color: Colors.grey[700])),
//                 const SizedBox(height: 8),
//                 Text("Experience: $experience years"),
//                 Text("Location: $location"),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _showBookingBottomSheet(fullName);
//                   },
//                   child: const Text("Book Appointment"),
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   void _showBookingBottomSheet(String doctorName) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) {
//         return StatefulBuilder(builder: (context, setModalState) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text("Select Date & Time",
//                     style:
//                         TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final pickedDate = await showDatePicker(
//                       context: context,
//                       initialDate: DateTime.now(),
//                       firstDate: DateTime.now(),
//                       lastDate: DateTime.now().add(const Duration(days: 30)),
//                     );
//                     if (pickedDate != null) {
//                       setModalState(() {
//                         selectedDate = pickedDate;
//                         _fetchBookedSlots();
//                       });
//                     }
//                   },
//                   child: Text(selectedDate == null
//                       ? "Select Date"
//                       : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
//                 ),
//                 const SizedBox(height: 10),
//                 Wrap(
//                   spacing: 8,
//                   children: availableSlots.map((slot) {
//                     final isBooked = bookedSlots.contains(slot);
//                     final isSelected = selectedTime == slot;

//                     return ChoiceChip(
//                       label: Text(slot),
//                       selected: isSelected,
//                       onSelected: isBooked
//                           ? null
//                           : (val) {
//                               setModalState(() {
//                                 selectedTime = slot;
//                               });
//                             },
//                       selectedColor: Colors.blue,
//                       disabledColor: Colors.grey[300],
//                     );
//                   }).toList(),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     _bookAppointment(doctorName);
//                     Navigator.pop(context);
//                   },
//                   child: const Text("Confirm Appointment"),
//                 )
//               ],
//             ),
//           );
//         });
//       },
//     );
//   }
// }

