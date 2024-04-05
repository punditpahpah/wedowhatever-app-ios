import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Web extends StatefulWidget {
  Web({required this.link, required this.title, Key? key}) : super(key: key);
  String link, title;
  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> {
  String status = "";
  Future<bool> _willPopCallback() async {
    Navigator.pop(context, status);
    return true;
  }

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    ProgressDialog dialog = new ProgressDialog(context);

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: WebView(
          initialUrl: widget.link,
          userAgent: 'chrome',
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onPageStarted: (String url) {
            dialog.style(message: 'Please wait....');
            dialog.show();
          },
          onPageFinished: (String url) {
            dialog.hide();
          },
        ),
      ),
    );
  }
}
