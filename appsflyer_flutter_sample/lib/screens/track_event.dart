import 'package:flutter/material.dart';
import '../app_config.dart';
import '../widgets/gradient_button.dart';

class TrackEvent extends StatefulWidget {
  TrackEvent({Key key}) : super(key: key);

  @override
  _TrackEventState createState() => _TrackEventState();
}

class _TrackEventState extends State<TrackEvent> {
  List<AFEvent> afEventList = [
    AFEvent("Purchase", "af_purchase", {"af_revenue": "100", "af_currenncy": "JPY", "af_content_id": "Test Content ID", "af_content_type": "Test Content Type"},),
    AFEvent("Add to cart", "af_add_to_cart", {"af_price": "100", "af_currenncy": "JPY", "af_content_id": "Test Content ID", "af_content_type": "Test Content Type"},),
    AFEvent("Event(null value)", "event_null_value", null,),
    AFEvent("Event(Empty map)", "event_empty_map", {},),
    AFEvent("Event(Multiple items)", "event_empty_map", {"af_revenue": "111", "af_content_id": ["item_1", "item_2", "item_3"], "af_content_type": ["item_type_1", "item_type_2", "item_type_3"]},),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text("Basic Events", textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 22, color: Theme
                .of(context)
                .primaryColor),),
        ),
        Column(
          children: _buildBasicEventButtons(context),
        ),
      ],
    );
  }

  List<Widget> _buildBasicEventButtons(BuildContext context) {
    return afEventList.map((e) => GradientButton(
      buttonText: e.displayName,
      margin: EdgeInsets.all(12),
      onPressed: (){
        _sendEvent(context, e);
      },
    )).toList();
  }

  void _sendEvent(BuildContext context, AFEvent e) {
    AppConfig.appsflyerSdk.trackEvent(e.eventName, e.eventValues).then((value){
      showGeneralDialog(
          context: context,
          barrierLabel: "Event sent!",
          barrierDismissible: true,
          transitionDuration: Duration(milliseconds: 300),
          pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
            return Container(
              color: Colors.black87,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                  child: Card(
                    color: Color(0xFF666666),
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: "Event name: "),
                        TextSpan(text: e.eventName, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorLight)),
                        TextSpan(text: "\nEvent values:\n"),
                        TextSpan(text: e.eventValues.toString(), style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColorLight)),
                      ]
                    ),
                  ),
                ),
              )),
            );
      });
    });
  }
}

class AFEvent {
  final String eventName;
  final Map<String, dynamic> eventValues;
  final String displayName;
  AFEvent(this.displayName, this.eventName, this.eventValues);
}