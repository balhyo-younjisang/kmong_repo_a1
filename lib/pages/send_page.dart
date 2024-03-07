import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kmong_repo_a1/apis/user.dart';
import 'package:kmong_repo_a1/widgets/button.dart';
import 'package:sms_mms/sms_mms.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);
  final ImagePicker picker = ImagePicker();
  final messageController = TextEditingController();
  XFile? video;
  List<String> selectStudent = [];

  Future getVideo(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickVideo(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        video = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    selectStudent = ModalRoute.of(context)!.settings.arguments as List<String>;

    void sendSMS(
        {String? message, XFile? video, required List<String> number}) async {
      String text = messageController.text;
      String? videoPath = video?.path;

      await SmsMms.send(recipients: number, message: text, filePath: videoPath);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  getVideo(
                      ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
                },
                child: const Text("동영상 가져오기"),
              ),
              const SizedBox(
                width: 20,
              ),
              video == null
                  ? Container(
                      width: 150,
                      height: 100,
                      color: Colors.grey,
                    )
                  : SizedBox(
                      width: 150,
                      height: 100,
                      child: Image.file(File(video!.path))),
            ],
          ),
          SizedBox(
            width: 300,
            height: 300,
            child: TextField(
              decoration: const InputDecoration(
                label: Text("메시지를 입력해주세요"),
              ),
              controller: messageController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text("${selectStudent.length} 명"),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: 400,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                    text: "발송 시작",
                    fontColor: Colors.white,
                    handler: () async {
                      await editUserData(selectStudent.length);
                      sendSMS(
                          number: selectStudent,
                          video: video,
                          message: messageController.text);
                    },
                    backgroundColor: const Color.fromARGB(255, 105, 105, 105))
              ],
            ),
          )
        ],
      ),
    );
  }
}
