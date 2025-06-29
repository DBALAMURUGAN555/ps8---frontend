import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart'
    show
        WebViewController,
        PlatformWebViewControllerCreationParams,
        WebViewWidget,
        JavaScriptMode;
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class WebARView extends StatefulWidget {
  @override
  _WebARViewState createState() => _WebARViewState();
}

class _WebARViewState extends State<WebARView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Choose the appropriate platform implementation
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    // Enable JavaScript and other settings
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..enableZoom(false)
      ..loadRequest(Uri.parse('https://your-webar-app-url.com'));

    if (controller.platform is AndroidWebViewController) {
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebAR Viewer')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
