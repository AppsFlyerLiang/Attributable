import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttersample/screens/deep_link.dart';
import 'package:fluttersample/screens/track_event.dart';
import 'package:fluttersample/utils/page_route_builders.dart';
import 'package:fluttersample/widgets/image_background_container.dart';
import 'package:provider/provider.dart';
import '../app_config.dart';
import 'conversion.dart';
import 'other_feature.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    var appData = Provider.of<AppData>(context);
    _checkUpdate(context, appData);
    final List<Widget> _tabContents = [
      Conversion(),
      TrackEvent(),
      OtherFeature()
    ];
    return ImageBackgroundContainer(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "assets/images/af_logo.png", height: 28, fit: BoxFit.fitHeight,),
        ),
        bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            unselectedItemColor: Colors.white24,
            selectedItemColor: Colors.white,
            backgroundColor: Colors.black38,
            currentIndex: _currentTabIndex,
            onTap: (idx) {
              print("Tapped $idx");
              setState(() {
                _currentTabIndex = idx;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_download),
                title: Text("Conversion"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.send),
                title: Text("Send Event"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.perm_device_information),
                title: Text("Deep Link"),
              ),
            ]
        ),
        body: _tabContents[_currentTabIndex],
      ),
    );
  }

  void _checkUpdate(BuildContext context, AppData appData) {
    print("[_checkUpdate] ${appData.hashCode} ${AppConfig.appData.hashCode} ${appData.hasNewDeepLinking} ${AppConfig.appData.hasNewDeepLinking}");
    if(appData.hasNewDeepLinking) {
      print("[Home] Deep Link");
      Future.delayed(Duration(seconds: 0)).then((value) {
        Navigator.push(context, PlainRouteBuilder(DeepLink()));
      });
    }
  }

}