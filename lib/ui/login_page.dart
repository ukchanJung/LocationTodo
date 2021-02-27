import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/ui/account_page.dart';
import 'package:flutter_app_location_todo/ui/gridbutton_page.dart';
import 'package:flutter_app_location_todo/ui/signin_page.dart';
import 'package:flutter_app_location_todo/ui/signup_page.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

const users = const {
  'ukchan@kakao.com': 'Jwc5933!',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  Duration get loginTime => Duration(milliseconds: 2250);
  List<LoginData> loginData;
  List idCheck;
  LoginData selectID;
  void initState(){
    super.initState();
    void fetchLogin ()async{

    FirebaseFirestore _db = FirebaseFirestore.instance;
    QuerySnapshot idData =  await _db.collection('user').get();
    loginData = idData.docs.map((e) => LoginData(name:e.id, password: e.data()[e.id])).toList();
    idCheck = loginData.map((e) => e.name).toList();
    }
    fetchLogin();

  }

  Future<String> _authUser(LoginData data) {
    print('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!idCheck.contains(data.name)) {
        return 'ID 가 존재하지 않습니다.';
      }
      if ( loginData.singleWhere((e) => e.name==data.name).password!=data.password ) {
        return '비밀 번호를 확인해주세요.';
      }
      if ( loginData.singleWhere((e) => e.name==data.name).password==data.password ) {
      selectID = loginData.singleWhere((e) => e.name==data.name);
        return null;
      }
      return null;
    });
  }

  Future<String> _signUp(LoginData data) {
        FirebaseFirestore _db = FirebaseFirestore.instance;

    print('회원가입 Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (idCheck.contains(data.name)) {
        return '이미 사용하고 있는 계정입니다.';
      }
      if(!idCheck.contains(data.name)){
        _db.collection('user').doc(data.name).set({data.name:data.password,'writeTime':DateTime.now()});
        return null;
        // QuerySnapshot read = await _db.collection('origingrid').get();
      }
      return null;
    });
  }

  Future<String> _recoverPassword(String name) {
    print('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'Username not exists';
      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'TIMWORK',
      logo: 'asset/timworklogo.png',
      onLogin: _authUser,
      onSignup: _signUp,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => AccountPage2(selectID),
        ));
      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        pageColorLight: Colors.white,
        pageColorDark: Colors.white54,
        titleStyle: TextStyle(fontWeight: FontWeight.w400,color: Colors.black)
      ),
    );
  }
}
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('로그인 페이지'),
      ),
      body: Column(
        children: [
          ElevatedButton(onPressed: (){
            Get.to(SignInPage());
          }, child: Text('로그인페이지')),
          ElevatedButton(onPressed: (){
            Get.to(SignUpPage());
          }, child: Text('Sign Up')),
        ],
      ),
    );
  }
}
