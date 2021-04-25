import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/method/method.dart';
import 'package:flutter_app_location_todo/model/user_model.dart';
import 'package:flutter_app_location_todo/provider/firebase_provider.dart';
import 'package:flutter_app_location_todo/styles/timwork_styles.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final formKey = GlobalKey<FormState>();
  User user;
  String name = '';
  String email = '';
  String phonenumber = '';
  String company = '';
  String rank = '';

  @override
  void initState() {
    super.initState();
    user = context.read<FirebaseProvider>().getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  renderTextFormField(
                      label: '이름',
                      onSaved: (val) {
                        setState(() {
                          this.name = val;
                        });
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '이름을 입력해주세요.';
                        } else {}
                        return null;
                      }),
                  renderTextFormField(
                      label: '이메일',
                      onSaved: (val) {
                        setState(() {
                          this.email = val;
                        });
                      },
                      validator: (val) {
                        if (!val.toString().isEmail) {
                          return '이메일 양식을 지켜주세요';
                        }
                        return null;
                      }),
                  renderTextFormField(
                      label: '연락처',
                      onSaved: (val) {
                        setState(() {
                          this.phonenumber =val;
                        });
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '필수 필드입니다.';
                        }
                        return null;
                      }),
                  renderTextFormField(
                      label: '회사',
                      onSaved: (val) {
                        setState(() {
                          this.company = val;
                        });
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '필수 필드입니다.';
                        }
                        return null;
                      }),
                  renderTextFormField(
                      label: '직급',
                      onSaved: (val) {
                        setState(() {
                          this.rank = val;
                        });
                      },
                      validator: (val) {
                        if (val.length < 1) {
                          return '필수 필드입니다.';
                        }
                        return null;
                      }),
                  renderSubmitButton(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  renderSubmitButton() {
    return ElevatedButton(
        onPressed: () {
          if (this.formKey.currentState.validate()) {
            this.formKey.currentState.save();
            TWUser SignUpUser = TWUser(
              uid: user.uid,
              name: name,
              company: company,
              rank: rank,
              email: email,
              phonenumber: phonenumber,
              level: 1,
            );
            writeUser(user: SignUpUser);
            Get.snackbar(
              '저장성공',
              '폼이 저장되었습니다!',
              backgroundColor: white,
              snackPosition: SnackPosition.BOTTOM,
            );
            Future.delayed(Duration(seconds: 1)).then((value) => Get.back());
          }
        },
        child: Text('저장하기'));
  }
}

renderTextFormField({
  @required String label,
  @required FormFieldSetter onSaved,
  @required FormFieldValidator validator,
}) {
  assert(label != null);
  assert(onSaved != null);
  assert(validator != null);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: formLabelTextStyle,
      ),
      TextFormField(
        onSaved: onSaved,
        validator: validator,
      ),
      Container(
        height: 16,
      ),
    ],
  );
}
