/*import 'package:flutter/material.dart';
import 'package:record/record.dart'; // ✅ Added missing semicolon

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RecorderTest(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RecorderTest extends StatefulWidget {
  const RecorderTest({super.key});

  @override
  State<RecorderTest> createState() => _RecorderTestState();
}

class _RecorderTestState extends State<RecorderTest> {
  final Record _recorder = AudioRecorder() as Record;
  bool isRecording = false;

  Future<void> toggleRecording() async {
    if (isRecording) {
      await _recorder.stop();
    } else {
      final hasPermission = await _recorder.hasPermission();
      if (hasPermission) {
        await _recorder.start();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Microphone permission denied')),
          );
        }
        return;
      }
    }

    if (mounted) {
      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  @override
  void dispose() {
    _recorder.dispose(); // Clean up the recorder when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Record Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: toggleRecording,
          child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
        ),
      ),
    );
  }
}*/
