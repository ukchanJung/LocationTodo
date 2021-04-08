import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/main.dart';
import 'package:flutter_app_location_todo/method/method.dart';
import 'package:flutter_app_location_todo/model/site_model.dart';
import 'package:flutter_app_location_todo/provider/firebase_provider.dart';
import 'package:flutter_app_location_todo/ui/confirmpage.dart';
import 'package:flutter_app_location_todo/ui/gridbutton_page.dart';
import 'package:flutter_app_location_todo/ui/qualitycheck_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<BottomNavigationBarItem> bNB = [
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.select), label: '현장선택'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.message_alert), label: '메세지'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.check), label: '체크리스트'),
  ];
  int selectNumber = 0;
  User _user;
  List<Site> _siteList;
  DateFormat _format = DateFormat('yyyy.MM.dd');

  String _token;
  @override
  void initState() {
    super.initState();
    _user = context.read<FirebaseProvider>().getUser();
    readSiteMethod(col: 'workSpace', list: _siteList).then((value){
      setState(() {
        _siteList = value;
      });
    });
    FirebaseMessaging.instance.getAPNSToken().then((value) => print('@@@apnToken $value'));
    FirebaseMessaging.instance.getToken(
      vapidKey: 'BIBjA2A7TXQ8RSFvZbfFIX8PyFm_FkCMJrFjC_ED8kqahPB-eVyx1SQbIGtb7TBA3Snka01gXztuo0tyfLCmue8'
    ).then((value) => print('@@@token $value'));

    // FirebaseMessaging.instance
    //     .getInitialMessage()
    //     .then((RemoteMessage message) {
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                // TODO add a proper drawable resource to android, for now using
                //      one that already exists in example app.
                icon: 'launch_background',
              ),
            ));
      }
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
    });
  }
  Future<void> sendPushMessage() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    ).then((_){
      FirebaseMessaging.instance.getAPNSToken().then((value) => print('@@@apnToken $value'));
      FirebaseMessaging.instance.getToken(
        vapidKey: 'BIBjA2A7TXQ8RSFvZbfFIX8PyFm_FkCMJrFjC_ED8kqahPB-eVyx1SQbIGtb7TBA3Snka01gXztuo0tyfLCmue8'
      ).then((value) => print('@@@token $value'));
    });


    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }



  // Future<void> onActionSelected(String value) async {
  //   switch (value) {
  //     case 'subscribe':
  //       {
  //         print(
  //             'FlutterFire Messaging Example: Subscribing to topic "fcm_test".');
  //         await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
  //         print(
  //             'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.');
  //       }
  //       break;
  //     case 'unsubscribe':
  //       {
  //         print(
  //             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".');
  //         await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
  //         print(
  //             'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.');
  //       }
  //       break;
  //     case 'get_apns_token':
  //       {
  //         if (defaultTargetPlatform == TargetPlatform.iOS ||
  //             defaultTargetPlatform == TargetPlatform.macOS) {
  //           print('FlutterFire Messaging Example: Getting APNs token...');
  //           String token = await FirebaseMessaging.instance.getAPNSToken();
  //           print('FlutterFire Messaging Example: Got APNs token: $token');
  //         } else {
  //           print(
  //               'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.');
  //         }
  //       }
  //       break;
  //     default:
  //       break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인페이지'),
        // actions: <Widget>[
        //   PopupMenuButton(
        //     onSelected: onActionSelected,
        //     itemBuilder: (BuildContext context) {
        //       return [
        //         const PopupMenuItem(
        //           value: 'subscribe',
        //           child: Text('Subscribe to topic'),
        //         ),
        //         const PopupMenuItem(
        //           value: 'unsubscribe',
        //           child: Text('Unsubscribe to topic'),
        //         ),
        //         const PopupMenuItem(
        //           value: 'get_apns_token',
        //           child: Text('Get APNs token (Apple only)'),
        //         ),
        //       ];
        //     },
        //   ),
        // ],
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: sendPushMessage,
          backgroundColor: Colors.white,
          child: const Icon(Icons.send),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text('${_user.displayName}'),
              accountEmail: Text(_user.email),
            ),
            ListTile(
              title: Text('계정설정'),
            ),
            ListTile(
              title: Text('주요시공확인서 작성'),
              onTap: (){
                Get.to(ConfirmPage());
              },
            ),
            ListTile(
              title: Text('시공확인서 확인'),
              onTap: (){
                Get.to(QualityCheckPage());
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bNB,
        currentIndex: selectNumber,
        onTap: (index) {
          setState(() {
            selectNumber = index;
          });
        },
      ),
      // body: SingleChildScrollView(
      //   child: Column(children: [
      //     MetaCard('FCM Token', TokenMonitor((token) {
      //       _token = token;
      //       return token == null
      //           ? const CircularProgressIndicator()
      //           : Text(token, style: const TextStyle(fontSize: 12));
      //     })),
      //     MetaCard('Message Stream', MessageList()),
      //   ]),
      // ),
      body: _siteList == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: _siteList
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                      subtitle: Text('${_format.format(e.start)}-${_format.format(e.end)}'),
                      onTap: () {
                        Get.to(GridButton());
                      },
                    ),
                  )
                  .toList(),
            ),
    );
  }
}

class AccountPage2 extends StatelessWidget {
  LoginData _loginData;

  AccountPage2(this._loginData);

  List<BottomNavigationBarItem> bNB = [
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.select), label: '현장선택'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.message_alert), label: '메세지'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.check), label: '체크리스트'),
  ];
  int selectNumber = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('개인페이지'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_loginData.name),
              accountEmail: Text(_loginData.name),
            ),
            ExpansionTile(
              title: Text('계정설정'),
              children: [
                ListTile(
                  title: Text('1'),
                ),
                ListTile(
                  title: Text('2'),
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: bNB,
        currentIndex: selectNumber,
        onTap: (index) {
          selectNumber = index;
        },
      ),
      body: Column(
        children: [
          ListTile(
            title: Text('빌리브 하남 현장'),
            onTap: () {
              Get.off(GridButton());
            },
          ),
          ExpansionTile(
            title: Text('계정설정'),
            children: [
              ListTile(
                title: Text('1'),
                onTap: () {
                  Get.defaultDialog();
                },
              ),
              ListTile(
                title: Text('2'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
class MetaCard extends StatelessWidget {
  final String _title;
  final Widget _children;

  // ignore: public_member_api_docs
  MetaCard(this._title, this._children);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(left: 8, right: 8, top: 8),
        child: Card(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child:
                      Text(_title, style: const TextStyle(fontSize: 18))),
                  _children,
                ]))));
  }
}