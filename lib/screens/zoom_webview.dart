import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ZoomWebView extends StatefulWidget {
  final String meetingId;
  final String passcode;
  final String userName;
  final String? meetingUrl;

  const ZoomWebView({
    super.key,
    required this.meetingId,
    required this.passcode,
    required this.userName,
    this.meetingUrl,
  });

  @override
  State<ZoomWebView> createState() => _ZoomWebViewState();
}

class _ZoomWebViewState extends State<ZoomWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
     final zoomWebUrl = widget.meetingUrl ??
        "https://us05web.zoom.us/wc/join/${widget.meetingId}?pwd=${widget.passcode}&uname=${Uri.encodeComponent(widget.userName)}";
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(zoomWebUrl));
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      appBar: AppBar(title: const Text("Zoom Meeting")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
