import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/method/method.dart';
import 'package:flutter_app_location_todo/model/site_model.dart';
import 'package:flutter_app_location_todo/provider/firebase_provider.dart';
import 'package:flutter_app_location_todo/ui/confirmpage.dart';
import 'package:flutter_app_location_todo/ui/gridbutton_page.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _user = context.read<FirebaseProvider>().getUser();
    readSiteMethod(col: 'workSpace', list: _siteList).then((value){
      setState(() {
        _siteList = value;
      });
    });
    // print(_siteList);
    // void readSiteMethod() async {
    //   FirebaseFirestore _db = FirebaseFirestore.instance;
    //   QuerySnapshot read = await _db.collection('workSpace').get();
    //   _siteList = read.docs.map((e) => Site.fromSnapshot(e)).toList();
    // }
    // readSiteMethod();
  }

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
              accountName: Text('${_user.displayName}'),
              accountEmail: Text(_user.email),
            ),
            ListTile(
              title: Text('계정설정'),
            ),
            ListTile(
              title: Text('주요시공확인서'),
              onTap: (){
                Get.to(ConfirmPage());
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
      body: _siteList == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: _siteList
                  .map(
                    (e) => ListTile(
                      title: Text(e.name),
                      subtitle: Text('${_format.format(e.start)}-${_format.format(e.end)}'),
                      onTap: () {
                        Get.offAll(GridButton());
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
