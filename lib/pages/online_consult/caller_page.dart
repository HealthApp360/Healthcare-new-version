// import 'package:agora_uikit/agora_uikit.dart';
// import 'package:flutter/material.dart';

// class VideoCallPage extends StatefulWidget {
//   final String channelName; // Unique channel name for each call
//   final String token;       // Agora token (can be Temp Token for testing)
  

//   const VideoCallPage({
//     Key? key,
//     required this.channelName,
//     required this.token,
//   }) : super(key: key);

//   @override
//   State<VideoCallPage> createState() => _VideoCallPageState();
// }

// class _VideoCallPageState extends State<VideoCallPage> {
//   late AgoraClient _client;

//   @override
//   void initState() {
//     super.initState();
//     _client = AgoraClient(
//       agoraConnectionData: AgoraConnectionData(
//         appId: "f230a3de64444e0abba0b411dffeac63",
//         channelName: widget.channelName,
//         tempToken: widget.token, // Replace with token generation on server in production
//       ),
//     );
//     initAgora();
//   }

//   Future<void> initAgora() async {
//     await _client.initialize();
//   }

//   @override
//   void dispose() {
//     _client.sessionController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Video Call"),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: SafeArea(
//         child: Stack(
//           children: [
//             AgoraVideoViewer(
//               client: _client,
//               layoutType: Layout.oneToOne, // Ensures one-to-one layout
//               enableHostControls: true,
//             ),
//             AgoraVideoButtons(
//               client: _client,
//               addScreenSharing: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
