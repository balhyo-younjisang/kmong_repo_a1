import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kmong_repo_a1/apis/admin.dart';
import 'package:kmong_repo_a1/models/user.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);
  List<User> userList = [];
  List<TextEditingController> controllers = [];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 0)).then((_) async {
      dynamic res = await getTeachersData();
      debugPrint(res.toString());

      if (context.mounted && res['code'] == 401) {
        Navigator.pushNamed(context, "/home");
      }

      List<dynamic> usersData = res['data'];
      setState(() {
        controllers =
            List.generate(usersData.length, (i) => TextEditingController());

        userList = List.generate(usersData.length, (index) {
          return User(
              phoneNumber: usersData[index]['PHONE_NUMBER'],
              maxSend: usersData[index]['max_send'],
              entireSend: usersData[index]['entire_send']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return Card(
                    child: Row(
                  children: [
                    Text(userList[index].phoneNumber),
                    const SizedBox(
                      width: 60,
                    ),
                    Text(userList[index].entireSend.toString()),
                    const SizedBox(
                      width: 60,
                    ),
                    SizedBox(
                      width: 60,
                      child: TextField(
                        controller: controllers[index],
                        decoration: InputDecoration(
                            hintText: userList[index].maxSend.toString()),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        var value = controllers[index].text;
                        var phoneNumber = userList[index].phoneNumber;

                        dynamic res =
                            await patchUserMaxSend(phoneNumber, value);

                        if (res['code'] == 200) {
                          dynamic res = await getTeachersData();
                          List<dynamic> usersData = res['data'];

                          if (context.mounted && res['code'] == 401) {
                            Get.snackbar("오류 발생", res['message']);
                            return;
                          }

                          setState(() {
                            controllers = List.generate(usersData.length,
                                (i) => TextEditingController());

                            userList = List.generate(usersData.length, (index) {
                              return User(
                                  phoneNumber: usersData[index]['PHONE_NUMBER'],
                                  maxSend: usersData[index]['max_send'],
                                  entireSend: usersData[index]['entire_send']);
                            });
                          });
                        }
                      },
                      child: const Text("수정"),
                    )
                  ],
                ));
              },
            ),
          )
        ],
      ),
    );
  }
}
