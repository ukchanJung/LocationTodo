import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QualityImageField extends StatefulWidget {
  @override
  _QualityImageFieldState createState() => _QualityImageFieldState();
}

class _QualityImageFieldState extends State<QualityImageField> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('공 사 명 : 시흥 장현 ㅇㅇ 아파트 건설공사'),
          Expanded(
            child: ListView(
            ),
          )
        ],
      ),
    );
  }
}
