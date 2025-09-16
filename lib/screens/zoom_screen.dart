import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZoomWebView extends StatefulWidget {
  final String meetingId;
  final String passcode;
  final String userName;
  const ZoomWebView({super.key,
  required this.meetingId,
  required this.passcode, 
  required this.userName});

  @override
  State<ZoomWebView> createState() => _ZoomWebViewState();
}

class _ZoomWebViewState extends State<ZoomWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse("http://10.0.2.2:4000"),
      );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Zoom WebView")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
