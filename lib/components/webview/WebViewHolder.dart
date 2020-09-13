import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:schooly/pages/AppSkelaton.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewHolder extends StatefulWidget {
  final String url;
  final String text;

  WebViewHolder(this.url, this.text);

  @override
  _WebViewHolderState createState() => _WebViewHolderState();
}

class _WebViewHolderState extends State<WebViewHolder> {
  final _key = UniqueKey();
  bool _isLoading = false;
  InAppWebViewController _webViewController;

  @override
  Widget build(BuildContext context) {
    return MainAppSkelaton(
        Stack(
          alignment: Alignment.center,
          children: [
            InAppWebView(
                initialUrl: widget.url,
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    mediaPlaybackRequiresUserGesture: false,
                    debuggingEnabled: true,
                  ),
                ),
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                androidOnPermissionRequest: (InAppWebViewController controller,
                    String origin, List<String> resources) async {
                  return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT);
                }),
            /*
            WebView(
              key: _key,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              onPageStarted: (value) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (value) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            */
            _isLoading
                ? CircularProgressIndicator()
                : Center(child: Container())
          ],
        ),
        widget.text);
  }
}
