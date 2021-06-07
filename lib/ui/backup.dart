import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/model/drawing_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BackupPage extends StatefulWidget {
  @override
  _BackupPageState createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  List<Drawing> drawings;
  String today = 'Backup' + DateFormat('yyyyMMdd').format(DateTime.now());
  TextEditingController _editingController;
  double loading = 0;

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController(text: today);
    Future<QuerySnapshot> watch = FirebaseFirestore.instance.collection('drawing').get();
    watch.then((v) {
      drawings = v.docs.map((e) => Drawing.fromSnapshot(e)).toList();
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _editingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('서버데이터 백업'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          drawings.forEach((e) {
            FirebaseFirestore.instance
                .collection('workSpace')
                .doc('신세계하남')
                .collection('drawings')
                .doc(e.drawingNum)
                .set(e.toJson());
          });
        },
      ),
      body: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _editingController,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  int length = drawings.length;
                  int s = 0;
                  drawings.forEach((e) {
                    FirebaseFirestore.instance.collection(_editingController.text).doc(e.drawingNum).set(e.toJson());
                    s++;
                    loading = s / length;
                    print(loading);
                  });
                  Get.defaultDialog(title: '$length 개 백업 완료');
                });
              },
              child: Text('업로드'),
            ),
          ],
        ),
      ),
    );
  }
}
