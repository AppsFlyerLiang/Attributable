import 'package:flutter/material.dart';
import '../app_config.dart';
import '../widgets/gradient_button.dart';

class TrackEvent extends StatefulWidget {
  TrackEvent({Key key}) : super(key: key);

  @override
  _TrackEventState createState() => _TrackEventState();
}

class _TrackEventState extends State<TrackEvent> {
  List<AFEventItem> afEventList = [
    AFEventItem("Sample Event (empty parameter)", "Sample Event", {},),
    AFEventItem("Sample Event (null parameter)", "Sample Event", null),
    AFEventItem("Sample Event (multi content)", "Multi Item Event", {
      "af_content_id": ["123", "988", "399"],
      "af_quantity": [1, 1, 1],
      "af_revenue": 111,},
    ),
    AFEventItem("Level Achieved", "af_level_achieved", {
      "af_level": "10",
      "af_score": "8.0"}
    ),
    AFEventItem("Add Payment Info", "af_add_payment_info", {
      "af_success": "1"}
    ),
    AFEventItem("Add to Cart", "af_add_to_cart", {
      "af_price": "99",
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_currency": "USD",
      "af_quantity": "1"
    },),
    AFEventItem("Add to Wishlist", "af_add_to_wishlist", {
      "af_price": "99",
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_currency": "USD",
      "af_quantity": "1"
    },),
    AFEventItem("Complete Registration", "af_complete_registration", {
      "af_registration_method": "Web"
    },),
    AFEventItem("Tutorial Completion", "af_tutorial_completion", {
      "af_success": "1",
      "af_content_id": "1234",
      "af_content": "Content"
    },),
    AFEventItem("Initiated Checkout", "af_initiated_checkout", {
      "af_price": "99",
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_currency": "USD",
      "af_quantity": "1",
      "Other parameters": "Skip"
    },),
    AFEventItem("Purchase", "af_purchase", {
      "af_revenue": "99",
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_currency": "USD",
      "af_quantity": "1",
      "Other parameters": "Skip"
    },),
    AFEventItem("Purchase(Default Currency)", "af_purchase", {
      "af_revenue": "99",
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_quantity": "1",
      "Other parameters": "Skip"
    },),
    AFEventItem("Purchase(Multiple items)", "af_purchase", {
      "af_content_id": ["123", "988", "399"],
      "af_quantity": [2, 1, 1],
      "af_price": [25, 50, 10],
      "af_currency": "USD",
      "af_revenue": 110
    },),
    AFEventItem("Subscription", "af_subscribe", {
      "af_revenue": "99",
      "af_currency": "USD"
    },),
    AFEventItem("Start Trail", "af_start_trial", {
      "af_price": "100",
      "af_currency": "USD"
    },),
    AFEventItem("Rate", "af_rate", {
      "af_rating_value": "5",
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_currency": "USD",
      "af_quantity": "1"
    },),
    AFEventItem("Search", "af_search", {
      "af_content_type": "Shoes",
      "af_search_string": "men"
    },),
    AFEventItem("Spent Credits", "af_spent_credits", {
      "af_price": 99,
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_content": "Whatever"
    },),
    AFEventItem("Achievement Unlocked", "af_achievement_unlocked", {
      "af_description": "Whatever"
    },),
    AFEventItem("Content View", "af_content_view", {
      "af_price": 99,
      "af_content_type": "Shoes",
      "af_content_id": "1234",
      "af_content": "Whatever"
    },),
    AFEventItem("List View", "af_list_view", {
      "af_content_type": "Shoes",
      "af_content_list": "Whatever"
    },),
    AFEventItem("Ad Click", "af_ad_click", {
      "af_adrev_ad_type": "ad_type",
      "af_currency": "USD"
    },),
    AFEventItem("Ad View", "af_ad_view", {
      "af_adrev_ad_type": "ad_type",
      "af_currency": "USD"
    },),
    AFEventItem("Travel Booking", "af_travel_booking", {
      "af_revenue": "899",
      "af_customer_user_id": "Customer User ID",
      "af_success": true,
      "af_date_a": "2019-07-28",
      "af_date_b": "2019-08-02",
      "af_destination_a": "Origin",
      "af_destination_b": "Destination",
      "af_order_id": "1234567890"
    },),
    AFEventItem("Share", "af_share", {
      "af_description": "Whatever"
    },),
    AFEventItem("Invite", "af_inivite", {
      "af_description": "Whatever"
    },),
    AFEventItem("Login", "af_login", {
      "af_customer_user_id": "Login Customer User ID"
    },),
    AFEventItem(
      "Opened From Push Notification", "af_opened_from_push_notification", {
      "Notification title": "New campaign"
    },),
    AFEventItem("Update", "af_update", {
      "af_content_id": "1234"
    },)
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
    return afEventList.map((e) =>
        GradientButton(
          buttonText: e.text,
          margin: EdgeInsets.all(12),
          onPressed: () {
            _sendEvent(context, e);
          },
        )).toList();
  }

  void _sendEvent(BuildContext context, AFEventItem e) {
    AppConfig.appsflyerSdk.logEvent(e.eventName, e.eventValues).then((value) {
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
                    padding: const EdgeInsets.all(20.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text("Event was sent",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            )
                          ),
                          SizedBox(height: 20,),
                          RichText(
                            textAlign: TextAlign.start,
                            text: TextSpan(
                                style: TextStyle(fontSize: 16),
                                children: [
                                  TextSpan(text: "Event name:\n"),
                                  TextSpan(text: e.eventName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme
                                              .of(context)
                                              .primaryColorLight)),
                                  TextSpan(text: "\nEvent values:\n"),
                                  TextSpan(text: e.eventValues.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Theme
                                              .of(context)
                                              .primaryColorLight)),
                                ]
                            ),
                          ),
                          GradientButton(
                            buttonText: "OK",
                            margin: EdgeInsets.only(top: 30),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}

class AFEventItem {
  final String eventName;
  final Map<String, dynamic> eventValues;
  final String text;
  AFEventItem(this.text, this.eventName, this.eventValues);
}