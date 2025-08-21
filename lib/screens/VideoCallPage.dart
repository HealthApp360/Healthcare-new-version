import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class VideoCallPage extends StatefulWidget {
  const VideoCallPage({super.key});

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  // final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  // MediaStream? _localStream;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  Timer? _recordingTimer;
  bool _isRecording = false; // Internal flag to prevent multiple recording starts

  String _recognizedText = "Speak to see subtitles...";
  bool _permissionsGranted = false; // Track overall camera/mic permissions
  bool _isInitializingMedia = false; // Prevent multiple media initialization attempts

  @override
  void initState() {
    super.initState();
  //  _localRenderer.initialize(); // Initialize renderer early
    _requestAndInitializeMedia(); // Start permission request and media setup
  }

  // Function to handle both permission requests and media initialization
  Future<void> _requestAndInitializeMedia() async {
    if (_isInitializingMedia) return; // Prevent re-entry
    _isInitializingMedia = true;

    if (!mounted) {
      _isInitializingMedia = false;
      return;
    }

    // Request Camera and Microphone permissions
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();

    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      setState(() {
        _permissionsGranted = true;
      });
      print("Camera and Microphone permissions granted.");
      //await _initializeMediaStream(); // Proceed to get media stream
      await _initMicrophoneRecording(); // Initialize recorder
    } else {
      setState(() {
        _permissionsGranted = false;
        _recognizedText = "Camera or Microphone permission denied.";
      });
      print("Camera or Microphone permissions denied.");
      if (cameraStatus.isPermanentlyDenied || microphoneStatus.isPermanentlyDenied) {
        // Inform user and open settings if permissions are permanently denied
        _showPermissionDeniedDialog();
      }
    }
    _isInitializingMedia = false;
  }

  // Original _initializeRenderer logic, now renamed and called after permissions
  // Future<void> _initializeMediaStream() async {
  //   if (!_permissionsGranted) {
  //     print("Cannot initialize media stream: Permissions not granted.");
  //     return;
  //   }
  //   try {
  //     final mediaStream = await navigator.mediaDevices.getUserMedia({
  //       'audio': true,
  //       'video': {
  //         'facingMode': 'user',
  //         'width': 640,
  //         'height': 480,
  //         'frameRate': 30,
  //       }
  //     });
  //     setState(() {
  //       _localStream = mediaStream;
  //       _localRenderer.srcObject = mediaStream;
  //     });
  //     print("Media stream initialized successfully.");
  //   } catch (e) {
  //     print("Media access error during getUserMedia: $e");
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Media access error: ${e.toString()}')),
  //       );
  //     }
  //     // If media access fails even after permissions, it might be a device issue
  //     setState(() {
  //       _recognizedText = "Failed to access camera/microphone. Check device settings.";
  //     });
  //   }
  // }

  Future<void> _initMicrophoneRecording() async {
    if (!_permissionsGranted) {
      print("Cannot initialize microphone recording: Permissions not granted.");
      return;
    }
    try {
      if (_recorder.isStopped) { 
        await _recorder.openRecorder();
        _recorder.setSubscriptionDuration(const Duration(milliseconds: 100));
        _startAutoRecordingLoop();
        print("Microphone recorder initialized and recording loop started.");
      } else {
        print("INFO: Recorder is already opened or recording. Skipping openRecorder().");
        _startAutoRecordingLoop();
      }
    } catch (e) {
      print("Failed to open recorder: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to initialize recording: ${e.toString()}')),
        );
      }
      setState(() => _recognizedText = "Recording initialization failed.");
    }
  }

  void _startAutoRecordingLoop() {
    _recordingTimer?.cancel();
    _recordingTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _recordChunk();
    });
  }

  Future<String> _getTempFilePath() async {
    final dir = await getTemporaryDirectory();
    return '${dir.path}/chunk_${DateTime.now().millisecondsSinceEpoch}.aac';
  }

  Future<void> _recordChunk() async {
    if (_isRecording || _recorder.isRecording) {
      print("INFO: Recording already in progress or recorder busy. Skipping chunk.");
      return;
    }

    final path = await _getTempFilePath();
    try {
      _isRecording = true;
      print("INFO: Starting recorder to file: $path");
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
        sampleRate: 16000,
        numChannels: 1,
      );
      await Future.delayed(const Duration(seconds: 2));
      final recordedPath = await _recorder.stopRecorder();
      _isRecording = false;

      if (recordedPath != null) {
        final recordedFile = File(recordedPath);
        if (await recordedFile.exists()) {
          final fileSize = await recordedFile.length();
          print("INFO: Recorded file size: $fileSize bytes at $recordedPath");
          if (fileSize > 100) {
            await _sendAudioChunkToBackend(recordedPath);
          } else {
            print("WARNING: Recorded audio chunk is too small ($fileSize bytes). Skipping upload.");
            setState(() => _recognizedText = "No audio detected or recording too short.");
          }
        } else {
          print("ERROR: Recorded file does not exist at $recordedPath");
          setState(() => _recognizedText = "Recording failed: file not found.");
        }
      } else {
        print("ERROR: recordedPath is null after stopping recorder.");
        setState(() => _recognizedText = "Recording failed: no path returned.");
      }
    } catch (e) {
      print("Recording error: $e");
      _isRecording = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording chunk failed: ${e.toString()}')),
        );
      }
      setState(() => _recognizedText = "Recording failed: ${e.toString().split(':')[0]}.");
    } finally {
      if (await File(path).exists()) {
        try {
          await File(path).delete();
          print("INFO: Deleted temporary file: $path");
        } catch (e) {
          print("WARNING: Failed to delete temporary file {path}: {e}");
        }
      }
    }
  }

  Future<void> _sendAudioChunkToBackend(String path) async {
    try {
      final uri = Uri.parse('http://192.168.0.171:8000/transcribe');
      final request = http.MultipartRequest('POST', uri)
        ..files.add(await http.MultipartFile.fromPath('file', path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final respString = await response.stream.bytesToString();
        final decoded = json.decode(respString);

        // ADDED PRINT STATEMENT HERE
        print("Flutter: Received from backend: ${decoded["text"]}");

        setState(() {
          _recognizedText = decoded["text"];
        });
        print("Transcription successful: $_recognizedText");
      } else {
        final errorBody = await response.stream.bytesToString();
        print("Backend error: ${response.statusCode}, Body: $errorBody");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Transcription failed: Status ${response.statusCode}')),
          );
        }
        setState(() => _recognizedText = "Transcription failed: Server error ${response.statusCode}.");
      }
    } catch (e) {
      print("Upload error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading audio: ${e.toString()}')),
        );
      }
      setState(() => _recognizedText = "Transcription backend error: ${e.toString().split(':')[0]}.");
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permissions Required"),
          content: const Text(
              "Camera and microphone access are essential for video calls and translation. Please enable them in your phone's app settings."),
          actions: <Widget>[
            TextButton(
              child: const Text("Open Settings"),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings();
              },
            ),
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
                _endCall();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _endCall() async {
    _recordingTimer?.cancel();

    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
    if (!_recorder.isStopped) {
        await _recorder.closeRecorder();
    }

    // _localStream?.getTracks().forEach((track) => track.stop());
    // if (_localRenderer.srcObject != null) {
    //   _localRenderer.srcObject = null;
    // }
    // await _localRenderer.dispose();

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _endCall();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Video preview
            // Expanded(
            //   flex: 3,
            //   // child: _permissionsGranted
            //   //     // ? RTCVideoView(
            //   //     //     _localRenderer,
            //   //     //     objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
            //   //     //     mirror: true,
            //   //     //   )
            //   //     : Center(
            //   //         child: Column(
            //   //           mainAxisAlignment: MainAxisAlignment.center,
            //   //           children: [
            //   //             const CircularProgressIndicator(),
            //   //             const SizedBox(height: 16),
            //   //             Text(
            //   //               _recognizedText,
            //   //               style: const TextStyle(color: Colors.white, fontSize: 18),
            //   //               textAlign: TextAlign.center,
            //   //             ),
            //   //             const SizedBox(height: 16),
            //   //             ElevatedButton(
            //   //               onPressed: _requestAndInitializeMedia,
            //   //               child: const Text("Retry Permissions"),
            //   //             ),
            //   //           ],
            //   //         ),
            //   //       ),
            // ),

            // Subtitle display
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Text(
                    _recognizedText,
                    style: const TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
            ),

            // End Call Button
            Expanded(
              flex: 1,
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: _endCall,
                  icon: const Icon(Icons.call_end),
                  label: const Text("End Call"),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
