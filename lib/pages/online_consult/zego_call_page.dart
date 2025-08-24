import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZegoCallPage extends StatelessWidget {
  const ZegoCallPage({Key? key, required this.callID ,required this.userid,required this.userName}) : super(key: key);
  final String callID;
  final String userid;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1562336384, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "333b3362739b2c7703286ed8448bad2970e631ffc7745678e8ae3d857090d499", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userid,
      userName: userName,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}