import 'package:flutter/material.dart';
import 'package:fluttersample/widgets/gradient_button.dart';
import 'package:fluttersample/widgets/image_background_container.dart';

import '../MyApp.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ImageBackgroundContainer(
      image: Image.asset("assets/images/003.jpg", fit: BoxFit.cover,),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            "assets/images/af_logo.png", height: 28, fit: BoxFit.fitHeight,),
          actions: [
            Icon(Icons.menu),
          ],
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
                icon: Icon(Icons.home),
                title: Text("Home"),
              ),
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
            ]),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: ListView(
          children: [
            Card(
                child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Text("Advertiser Id: ${MyApp.advertisingId}"))),
          ],
        ),
      ),
    );
  }
}