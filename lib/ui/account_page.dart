import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/ui/gridbutton_page.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
class AccountPage extends StatefulWidget {
  LoginData _loginData;

  AccountPage(this._loginData);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<BottomNavigationBarItem> bNB = [
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.select),label:'현장선택'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.message_alert),label:'메세지'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.check),label:'체크리스트'),
  ];
  int selectNumber =0;
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
              accountName: Text(widget._loginData.name),
              accountEmail: Text(widget._loginData.name),
            ),
            ListTile(title: Text('계정설정'),)
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
      body: Column(
        children: [
          ListTile(title: Text('빌리브 하남 현장'),onTap: (){
            Get.off(GridButton());
          },)
        ],
      ),
    );
  }
}
class AccountPage2 extends StatelessWidget {
  LoginData _loginData;

  AccountPage2(this._loginData);

  List<BottomNavigationBarItem> bNB = [
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.select),label:'현장선택'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.message_alert),label:'메세지'),
    BottomNavigationBarItem(icon: Icon(CommunityMaterialIcons.check),label:'체크리스트'),
  ];
  int selectNumber =0;

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
            ExpansionTile(title: Text('계정설정'),children: [
              ListTile(title: Text('1'),),
              ListTile(title: Text('2'),),
            ],)
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
          ListTile(title: Text('빌리브 하남 현장'),onTap: (){
            Get.off(GridButton());
          },),
          ExpansionTile(title: Text('계정설정'),children: [
            ListTile(title: Text('1'),onTap: (){
              Get.defaultDialog();
            },),
            ListTile(title: Text('2'),),
          ],)

        ],
      ),
    );
  }
}

