import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_location_todo/data/memo_model.dart';
import 'package:flutter_app_location_todo/model/drawingpath_provider.dart';
import 'package:flutter_app_location_todo/provider/firebase_provider.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MemoPage extends StatefulWidget {
  List<Memo> memoList;

  MemoPage({this.memoList});

  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  bool search = false;
  String st = '';
  File _image;
  User _user;
  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  String _profileImageURL = "";

  @override
  void initState() {
    super.initState();
    _user = context.read<FirebaseProvider>().getUser();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
    _textEditingController2.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
                onPressed: () {
                  context.read<MemoDialog>().onOff();
                },
                child: Text(
                  '취소',
                  textScaleFactor: 1.2,
                )),
            Expanded(
                child: Text(
              '새로운 메모',
              textScaleFactor: 1.4,
              textAlign: TextAlign.center,
            )),
            TextButton(
                onPressed: () {
                  _uploadImageToStorage(_image);
                },
                child: Text(
                  '추가',
                  textScaleFactor: 1.2,
                )),
          ],
        ),
        ExpansionTile(
          title: TextField(
              controller: _textEditingController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '제목',
              )),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
              child: TextField(
                  controller: _textEditingController2,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: 4,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    labelText: '메모',
                  )),
            ),
          ],
        ),
        Expanded(
          child: Scrollbar(
            child: ListView(
              padding: EdgeInsets.all(4),
              children: [
                ExpansionTile(
                  title: Text('사진첨부'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Text('카메라')),
                      SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Text('갤러리')),
                    ],
                  ),
                  children: [
                    showImage(),
                    Container(
                      height: 400,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.count(
                          crossAxisCount: 3,
                          children: List.generate(
                              6,
                              (index) => Padding(
                                    padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
                                    child: Card(
                                        child: Container(
                                      child: Center(
                                        child: Image.network(_profileImageURL),
                                      ),
                                    )),
                                  )),
                        ),
                      ),
                    )
                  ],
                ),
                Divider(),
                ListTile(
                  title: Text('클릭해서 분야를 선택해주세요'),
                  trailing: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: () {}, child: Text('품질')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: () {}, child: Text('검측')),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: () {}, child: Text('안전')),
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
                ExpansionTile(
                  title: Text('세부사항'),
                  children: [
                    ListTile(
                      title: Text('날짜'),
                    ),
                    ListTile(
                      title: Text('위치'),
                    ),
                    ListTile(
                      title: Text('참조'),
                    ),
                    ListTile(
                      title: Text('우선순위'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // Expanded
      ],
    );
  }

  Widget showImage() {
    if (_image == null)
      return Container();
    else
      return Image.file(File(_image.path));
  }

  Future getImage(ImageSource imageSource) async {
    PickedFile image = await ImagePicker.platform.pickImage(source: imageSource);
    setState(() {
      _image = File(image.path);
    });
  }

  void _uploadImageToStorage(File _image) async {
    if (_image != null) {
      Reference storageReference = _firebaseStorage.ref("test/${_user.uid}_${_textEditingController.text}");
      // 파일 업로드
      UploadTask storageUploadTask = storageReference.putFile(_image);
      // 파일 업로드 완료까지 대기
      storageUploadTask.whenComplete(() async {
        // 업로드한 사진의 URL 획득
        String downloadURL = await storageReference.getDownloadURL();
        // 업로드된 사진의 URL을 페이지에 반영
        setState(() {
          _profileImageURL = downloadURL;
          FirebaseFirestore _db = FirebaseFirestore.instance;
          CollectionReference memo = _db.collection('memo');
          Memo _memo = Memo(
            title: _textEditingController.text,
            subTitle: _textEditingController2.text,
            imagePath: _profileImageURL,
            writeTime: DateTime.now(),
            origin: context.read<Current>().getOrigin(),
            check: false,
          );
          widget.memoList.add(_memo);
          memo.add(_memo.toJson());
          context.read<MemoDialog>().onOff();
        });
      });
    } else {
      FirebaseFirestore _db = FirebaseFirestore.instance;
      CollectionReference memo = _db.collection('memo');
      Memo _memo = Memo(
        title: _textEditingController.text,
        subTitle: _textEditingController2.text,
        imagePath: _profileImageURL,
        writeTime: DateTime.now(),
        origin: context.read<Current>().getOrigin(),
        check: false,
      );
      widget.memoList.add(_memo);
      memo.add(_memo.toJson());
      context.read<MemoDialog>().onOff();
    }
  }
}
