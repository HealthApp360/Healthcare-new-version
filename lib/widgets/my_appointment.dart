import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';

class MyAppointmentsList extends StatelessWidget {
  final String userId; // Current userId

  const MyAppointmentsList({super.key, required this.userId});

  Future<void> _joinMeeting({
    required String roomName,
    required String userName,
  }) async {
    var options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: roomName, // Unique room ID
      configOverrides: {
        "startWithAudioMuted": true,
        "startWithVideoMuted": false,
      },
      userInfo: JitsiMeetUserInfo(displayName: userName),
    );

    await JitsiMeet().join(options);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .orderBy('bookedAt', descending: false)
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
            final date = appointment["appointmentDate"];
            final time = appointment["appointmentTime"];

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection("users")
                  .doc(doctorId)
                  .get(),
              builder: (context, doctorSnap) {
                if (!doctorSnap.hasData) {
                  return const SizedBox();
                }

                final doctorData =
                    doctorSnap.data!.data() as Map<String, dynamic>?;

                if (doctorData == null) {
                  return const SizedBox();
                }

                final doctorName = doctorData["fullName"] ?? "Doctor";
                final userName = appointment["userEmail"] ?? "User";
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: doctorData["profilePicture"] != null &&
                              doctorData["profilePicture"].toString().isNotEmpty
                          ? NetworkImage(doctorData["profilePicture"])
                          : const AssetImage("assets/images/default_avatar.png")
                              as ImageProvider,
                    ),
                    title: Text(doctorName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(doctorData["specialization"] ?? ""),
                        const SizedBox(height: 4),
                        Text("📅 $date   ⏰ $time"),
                      ],
                    ),
                    trailing: const Icon(Icons.video_call, color: Colors.blue),
                    onTap: () async {
                      // Meeting room can be appointmentId or doctorId+userId
                      final roomName = "appointment_${appointments[index].id}";
                      await _joinMeeting(
                        roomName: roomName,
                        userName: userName,
                      );
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
