import 'package:flutter/material.dart';
import 'zoom_webview.dart';

class JoinMeetingScreen extends StatefulWidget {
  const JoinMeetingScreen({super.key});

  @override
  State<JoinMeetingScreen> createState() => _JoinMeetingScreenState();
}

class _JoinMeetingScreenState extends State<JoinMeetingScreen> {
  final _meetingIdController = TextEditingController();
  final _passcodeController = TextEditingController();
  final _userNameController = TextEditingController(text: "Flutter User");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Zoom Meeting")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _meetingIdController,
              decoration: const InputDecoration(labelText: "Meeting ID"),
            ),const SizedBox(height: 20),
            TextField(
              controller: _passcodeController,
              decoration: const InputDecoration(labelText: "Passcode"),
            ),const SizedBox(height: 20),
            TextField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: "Your Name"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final meetingId = _meetingIdController.text.trim();
                final passcode = _passcodeController.text.trim();
                final userName = _userNameController.text.trim();

                if (meetingId.isNotEmpty && userName.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ZoomWebView(
                        meetingId: meetingId,
                        passcode: passcode,
                        userName: userName,
                      ),
                    ),
                  );
                }
              },
              child: const Text("Join"),
            ),
          ],
        ),
      ),
    );
  }
}
