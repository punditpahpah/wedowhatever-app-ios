import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SocialLogins extends StatefulWidget {
  String to, color;
  SocialLogins({required this.to, required this.color, Key? key})
      : super(key: key);

  @override
  _SocialLoginsState createState() => _SocialLoginsState();
}

class _SocialLoginsState extends State<SocialLogins> {
  String status = "";
  bool visible = false;
  Future<bool> _willPopCallback() async {
    Navigator.pop(context, status);
    return true;
  }

  String _url = "";
  
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    ProgressDialog dialog = new ProgressDialog(context);

    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.to + " login"),
          backgroundColor: Color(int.parse(widget.color)),
        ),
        body: Visibility(
          visible: visible,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: WebView(
            initialUrl: 'https://wedowhatever.com/auth/login',
            userAgent: 'random',
            
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>[
              _createTopBarJsChannel(),
            ].toSet(),
            onPageStarted: (String url) {
              dialog.style(message: 'Please wait....');
              dialog.show();
              setState(() {
                visible = false;
              });
              if (url == "https://wedowhatever.com/cp/network_feed") {
                _controller.future.then((webViewController) {
                  webViewController
                      .loadUrl("https://wedowhatever.com/cp/dashboard");
                });
              }
            },
            onPageFinished: (String url) {
              dialog.hide();
              _url = url;
              // Fluttertoast.showToast(
              //     msg: url,
              //     toastLength: Toast.LENGTH_SHORT,
              //     gravity: ToastGravity.CENTER,
              //     timeInSecForIosWeb: 1,
              //     backgroundColor: Colors.red,
              //     textColor: Colors.white,
              //     fontSize: 16.0);
              if (url.contains("accounts.google.com") ||
                  url.contains("api.twitter.com") ||
                  url.contains("facebook.com") ||
                  url.contains("linkedin.com")) {
                setState(() {
                  visible = !visible;
                });
              }

              if (url == "https://wedowhatever.com/auth/login") {
                _click();
              }

              if (url == "https://wedowhatever.com/cp/dashboard") {
                _controller.future.then((webViewController) {
                  webViewController.clearCache();
                  final cookieManager = CookieManager();
                  cookieManager.clearCookies();
                });
                _showPageTitle();
              }
            },
          ),
        ),
      ),
    );
  }

  void _showPageTitle() {
    _controller.future.then((webViewController) {
      webViewController.evaluateJavascript(
          'TopBarJsChannel.postMessage(document.getElementsByClassName("user-heading")[0].querySelectorAll("p")[0].innerHTML);');
    });
  }

  void _click() {
    _controller.future.then((webViewController) {
      if (widget.to == "Google") {
        webViewController.evaluateJavascript(
            'TopBarJsChannel.postMessage(document.getElementsByClassName("btn-lg")[2].click());');
      } else if (widget.to == "Twitter") {
        webViewController.evaluateJavascript(
            'TopBarJsChannel.postMessage(document.getElementsByClassName("btn-lg")[3].click());');
      } else if (widget.to == "Facebook") {
        webViewController.evaluateJavascript(
            'TopBarJsChannel.postMessage(document.getElementsByClassName("btn-lg")[4].click());');
      } else if (widget.to == "Linkedin") {
        webViewController.evaluateJavascript(
            'TopBarJsChannel.postMessage(document.getElementsByClassName("btn-lg")[5].click());');
      }
    });
  }

  JavascriptChannel _createTopBarJsChannel() {
    return JavascriptChannel(
      name: 'TopBarJsChannel',
      onMessageReceived: (JavascriptMessage message) {
        String newTitle = message.message;

        // if (newTitle.contains('-')) {
        //   newTitle = newTitle.substring(0, newTitle.indexOf('-')).trim();
        // }
        if (_url == "https://wedowhatever.com/cp/dashboard") {
          Navigator.pop(context, newTitle);
        }
      },
    );
  }
}
