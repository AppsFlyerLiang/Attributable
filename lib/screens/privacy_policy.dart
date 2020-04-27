import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersample/widgets/gradient_button.dart';
import 'package:fluttersample/widgets/image_background_container.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key key, this.onAgree}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();

  final Function(bool) onAgree;
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  WebViewController _controller;
  bool _canGoBack = false;
  Future<bool> _onBack() async {
    String currentUrl =  await _controller.currentUrl();
    setState(() {
      _canGoBack = !currentUrl.startsWith("data:text");
    });
    if (_canGoBack) {
      _controller.goBack();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _onBack(),
      child: ImageBackgroundContainer(
        image: Image.asset("assets/images/003.jpg", fit: BoxFit.cover,),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Image.asset(
              "assets/images/af_logo.png", height: 28, fit: BoxFit.fitHeight,
            ),
            leading: _canGoBack ? IconButton(icon: Icon(Icons.arrow_back,),
              onPressed: () {
                _onBack();
              },
            ) : Container(),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 82),
                child: WebView(
                  initialUrl: 'about:blank',
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                    _loadHtmlFromAssets();
                  },
                  navigationDelegate: (NavigationRequest navigation) {
                    print("WebView navigationDelegate ${navigation.url}");
                    setState(() {
                      _canGoBack = true;
                    });
                    return NavigationDecision.navigate;
                    },
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                        child: GradientButton(
                          buttonText: "Disagree",
                          margin: EdgeInsets.all(16),
                          onPressed: () {
                            widget.onAgree(false);
                          },
                        ),
                      ),
                      Expanded(
                        child: GradientButton(
                          buttonText: "Agree",
                          margin: EdgeInsets.all(16),
                          onPressed: () {
                            widget.onAgree(true);
                          }
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/html/privacy_policy.html');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
  }
}
