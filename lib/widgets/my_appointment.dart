// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

// class MyAppointmentsList extends StatelessWidget {
//   final String userId; // Current userId
//   final String role;
//   const MyAppointmentsList({super.key, required this.userId,required this.role});

//   Future<void> _joinMeeting({
//     required String roomName,
//     required String userName,
//   }) async {
//    try{
//  var options = JitsiMeetConferenceOptions(
//       serverURL: "https://meet.jit.si",
//       room: roomName, // Unique room ID
//       configOverrides: {
//         "startWithAudioMuted": true,
//         "startWithVideoMuted": false,
//       },
//       userInfo: JitsiMeetUserInfo(displayName: userName),
//     );

//     await JitsiMeet().join(options);
//    }catch(e){
// print(e.toString());
//    }

//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: 
//       FirebaseFirestore.instance
//           .collection('appointments')
//           .where( role == 'doctor' ? 'doctorId' : 'userId', isEqualTo: userId)
//           .orderBy('bookedAt', descending: false)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//           return const Center(
//             child: Text("No appointments yet."),
//           );
//         }

//         final appointments = snapshot.data!.docs;

//         return ListView.builder(
//           itemCount: appointments.length,
//           itemBuilder: (context, index) {
//             final appointment =
//                 appointments[index].data() as Map<String, dynamic>;

//             final doctorId = appointment["doctorId"];
//             final date = appointment["appointmentDate"];
//             final time = appointment["appointmentTime"];

//             return FutureBuilder<DocumentSnapshot>(
//               future: FirebaseFirestore.instance
//                   .collection("doctors")
//                   .doc(doctorId)
//                   .get(),
//               builder: (context, doctorSnap) {
//                 if (!doctorSnap.hasData) {
//                   return const SizedBox();
//                 }

//                 final doctorData =
//                     doctorSnap.data!.data() as Map<String, dynamic>?;

//                 if (doctorData == null) {
//                   return const SizedBox();
//                 }

//                 final doctorName = doctorData["fullName"] ?? "Doctor";
//                 final userName = appointment["userName"] ?? "User";
//                 return Card(
//                   margin:
//                       const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundImage: doctorData["profilePicture"] != null &&
//                               doctorData["profilePicture"].toString().isNotEmpty
//                           ? NetworkImage(doctorData["profilePicture"])
//                           : const AssetImage("assets/images/default_avatar.png")
//                               as ImageProvider,
//                     ),
//                     title: Text(doctorName),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(doctorData["specialization"] ?? ""),
//                         const SizedBox(height: 4),
//                         Text("📅 $date   ⏰ $time"),
//                       ],
//                     ),
//                     trailing: const Icon(Icons.video_call, color: Colors.blue),
//                     onTap: () async {
//                       // Meeting room can be appointmentId or doctorId+userId
//                       final roomName = "appointment_${appointments[index].id}";
//                       await _joinMeeting(
//                         roomName: roomName,
//                         userName: userName,
//                       );
//                     },
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthcare_app/pages/online_consult/caller_page.dart';
import 'package:healthcare_app/pages/online_consult/zego_call_page.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class MyAppointmentsList extends StatelessWidget {
  final String userId; // Current userId
  final String role; // "doctor" or "user"

  const MyAppointmentsList({
    super.key,
    required this.userId,
    required this.role,
  });

  Future<void> _joinMeeting({
    required String roomName,
    required String userName,
  }) async {
    try {
      var options = JitsiMeetConferenceOptions(
        serverURL: "https://meet.jit.si",
        room: roomName,
        configOverrides: {
          "startWithAudioMuted": true,
          "startWithVideoMuted": false,
        },
        userInfo: JitsiMeetUserInfo(displayName: userName),
      );

      await JitsiMeet().join(options);
    } catch (e) {
      print("Jitsi Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where(role == 'doctor' ? 'doctorId' : 'userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text("No appointments yet."),
          );
        }

        final appointments = snapshot.data!.docs;

        return ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment =
                appointments[index].data() as Map<String, dynamic>;

            final doctorId = appointment["doctorId"];
            final userId = appointment["userId"];
            final date = appointment["appointmentDate"];
            final time = appointment["appointmentTime"];

            // ✅ Decide which collection to fetch based on role
            final otherPersonId = role == 'doctor' ?  userId :  doctorId;
            final otherCollection = role == 'doctor' ? 'users' : 'doctors' ;

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection(otherCollection)
                  .doc(otherPersonId)
                  .get(),
              builder: (context, userSnap) {
                if (!userSnap.hasData) {
                  return const SizedBox();
                }

                final userData =
                    userSnap.data!.data() as Map<String, dynamic>?;

                if (userData == null) {
                  return const SizedBox();
                }

                final name = role == 'doctor' ?  userData["displayName"] ?? "Unknown" : userData["fullName"] ?? "Unknown" ;
                final profilePic = role == 'doctor' ? userData["photoURL"] ?? "" :userData["profilePicture"] ?? "" ;
                
                final specialization = userData["specialization"] ?? "";

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: profilePic.isNotEmpty
                          ? NetworkImage(profilePic)
                          : const AssetImage("assets/images/default_avatar.png")
                              as ImageProvider,
                    ),
                    title: Text(name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (specialization.isNotEmpty)
                          Text(specialization),
                        const SizedBox(height: 4),
                        Text("📅 $date   ⏰ $time",style: TextStyle(fontSize: 12),),
                      ],
                    ),
                    trailing: 
                    IconButton(onPressed: () async {
                      await ZegoUIKitPrebuiltCallInvitationService().send(
                invitees: [
                  ZegoCallUser(
                    otherPersonId,
                    name
                  ),
                ],
                isVideoCall: true,
                resourceID: 'medico_call', // must match Zego Console Push Resource ID
                // Optional extras:
                // callID: 'your_custom_call_id',
                // notificationTitle: 'Incoming call',
                // notificationMessage: '$otherPersonName is calling you',
                // customData: jsonEncode({...}),
                // timeoutSeconds: 60,
              );
                    }, icon: Icon(Icons.call)),
                    // Container(
                    //   height: 50,
                    //   width: 50,
                    //   child: ZegoSendCallInvitationButton(
                    //     isVideoCall: true,
                    //     resourceID: "medico_call", // Same as in Zego console
                    //     invitees: [
                    //       ZegoUIKitUser(
                    //         id: otherPersonId, // The user you want to call
                    //         name: name,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    //const Icon(Icons.video_call, color: Colors.blue),
                    onTap: () async {

//                       Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => ZegoCallPage(
//       callID: "appointment_${appointments[index].id}",
//       userName: name,
//       userid: otherPersonId,
//     ),
//   ),
// );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}


