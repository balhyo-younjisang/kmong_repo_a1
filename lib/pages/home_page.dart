import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:kmong_repo_a1/apis/user.dart';
import 'package:kmong_repo_a1/models/student.dart';
import 'package:kmong_repo_a1/widgets/button.dart';
import 'package:kmong_repo_a1/widgets/custom_appbar.dart';
import 'package:kmong_repo_a1/widgets/input.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic userData = {'data': "총 발송량 : 0, 일일 최대 발송량: 0"};
  List<Student> studentList = [];
  List<String> groupList = [];
  List<bool> selectedStudentList = [];
  var _selectedGroup = "전체";
  var selectedGroupId = 0;
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      var db =
          await openDatabase("student.db", version: 1, onCreate: _onCreate);

      userData = await getUserData();

      if (context.mounted && userData['data'] == null) {
        const storage = FlutterSecureStorage();
        await storage.delete(
          key: "token",
        );

        if (context.mounted) Navigator.pushNamed(context, "/");
      }

      final List<Map<String, dynamic>> groups =
          await db.rawQuery("SELECT * FROM student_group");
      final List<Map<String, dynamic>> students =
          await db.rawQuery("SELECT * FROM student");

      setState(() {
        if (groups.isEmpty) {
          groupList = [];
        } else {
          groupList = List.generate(groups.length, (index) {
            return groups[index]['name'];
          });
        }

        if (students.isEmpty) {
          studentList = [];
        } else {
          selectedStudentList = List<bool>.filled(students.length, false);
          studentList = List.generate(
            students.length,
            (index) {
              return Student(
                  name: students[index]['name'],
                  phoneNumber: students[index]['phone_number'],
                  id: students[index]['student_id'],
                  groupId: students[index]['group_id']);
            },
          );
        }
      });
    });
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   Future.delayed(const Duration(seconds: 0)).then((_) async {
  //     var db =
  //         await openDatabase("student.db", version: 1, onCreate: _onCreate);

  //     userData = await getUserData();

  //     if (context.mounted && userData['data'] == null) {
  //       const storage = FlutterSecureStorage();
  //       await storage.delete(
  //         key: "token",
  //       );

  //       if (context.mounted) Navigator.pushNamed(context, "/");
  //     }

  //     final List<Map<String, dynamic>> groups =
  //         await db.rawQuery("SELECT * FROM student_group");
  //     final List<Map<String, dynamic>> students = await db
  //         .rawQuery("SELECT * FROM student WHERE group_id=$selectedGroupId");

  //     setState(() {
  //       if (groups.isEmpty) {
  //         groupList = [];
  //       } else {
  //         groupList = List.generate(groups.length, (index) {
  //           return groups[index]['name'];
  //         });
  //       }

  //       if (students.isEmpty) {
  //         studentList = [];
  //       } else {
  //         selectedStudentList = List<bool>.filled(students.length, false);
  //         studentList = List.generate(
  //           students.length,
  //           (index) {
  //             return Student(
  //                 name: students[index]['name'],
  //                 phoneNumber: students[index]['phone_number'],
  //                 id: students[index]['student_id'],
  //                 groupId: students[index]['group_id']);
  //           },
  //         );
  //       }
  //     });
  //   });
  // }

  _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE student_group(group_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)");
    await db.execute("INSERT INTO student_group(name) VALUES('전체')");
    await db.execute(
        "CREATE TABLE student(student_id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, phone_number TEXT NOT NULL, group_id INTEGER NOT NULL, FOREIGN KEY(student_id) REFERENCES student_group(student_id))");
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: AuthAppBar(),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: 26,
                child: Text(
                  userData['data']
                      .toString()
                      .replaceAll("{", '')
                      .replaceAll("}", ''),
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("학생 그룹"),
                  const SizedBox(
                    width: 20,
                  ),
                  DropdownButton(
                      value: _selectedGroup,
                      items: groupList
                          .map<DropdownMenuItem<String>>((String group) {
                        return DropdownMenuItem<String>(
                            value: group, child: Text(group));
                      }).toList(),
                      onChanged: (selectGroup) async {
                        selectedGroupId = groupList.indexOf(selectGroup!);
                        var db = await openDatabase("student.db", version: 1);

                        List<Map<String, dynamic>> students;
                        if (selectedGroupId == 0) {
                          students = await db.rawQuery("SELECT * FROM student");
                        } else {
                          students = await db.rawQuery(
                              "SELECT * FROM student WHERE group_id=$selectedGroupId");
                        }

                        setState(() {
                          _selectedGroup = selectGroup;

                          selectedStudentList =
                              List<bool>.filled(students.length, false);
                          studentList = List.generate(
                            students.length,
                            (index) {
                              return Student(
                                  name: students[index]['name'],
                                  phoneNumber: students[index]['phone_number'],
                                  id: students[index]['student_id'],
                                  groupId: students[index]['group_id']);
                            },
                          );
                        });
                      }),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: 360,
                    child: ListView.builder(
                      itemCount: studentList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: CheckboxListTile(
                            title: Text(studentList[index].name),
                            value: selectedStudentList[index],
                            onChanged: (val) {
                              setState(() {
                                selectedStudentList[index] = val!;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonWidget(
                        text: "학생 관리",
                        handler: () {
                          var selectCount = 0;
                          var idx = 0;

                          for (int i = 0; i < selectedStudentList.length; i++) {
                            if (selectedStudentList[i] == true) {
                              selectCount++;
                              idx = i;
                            }
                          }
                          if (selectCount != 1) {
                            Get.snackbar("오류", "한 명의 학생만 선택해주세요");
                          } else {
                            Navigator.pushNamed(context, "/student",
                                arguments: studentList[idx]);
                          }
                        },
                        backgroundColor: Colors.yellow),
                    const SizedBox(
                      width: 30,
                    ),
                    ButtonWidget(
                        text: "발송 시작",
                        fontColor: Colors.white,
                        handler: () {
                          Navigator.pushNamed(context, "/send");
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 105, 105, 105)),
                    const SizedBox(
                      width: 30,
                    ),
                    ButtonWidget(
                        text: "학생 추가",
                        fontColor: Colors.white,
                        handler: () {
                          Get.defaultDialog(
                              title: "학생 추가",
                              content: Column(
                                children: [
                                  InputWidget(
                                      text: "이름을 입력해주세요",
                                      isSecure: false,
                                      controller: nameController),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  InputWidget(
                                      text: "전화번호를 입력해주세요",
                                      isSecure: false,
                                      controller: phoneNumberController)
                                ],
                              ),
                              actions: [
                                TextButton(
                                    onPressed: Get.back,
                                    child: const Text("취소")),
                                TextButton(
                                    onPressed: () async {
                                      String name = nameController.text;
                                      String phoneNumber = phoneNumberController
                                          .text
                                          .replaceAll("-", "");

                                      var db = await openDatabase("student.db",
                                          version: 1);
                                      await db.rawInsert(
                                          "INSERT INTO student(name, phone_number, group_id) VALUES('$name', '$phoneNumber', 0)");
                                      var groupId =
                                          groupList.indexOf(_selectedGroup);
                                      List<Map<String, dynamic>> students =
                                          await db.rawQuery(
                                              "SELECT * FROM student WHERE group_id='$groupId'");

                                      debugPrint(students.toString());
                                      setState(() {
                                        selectedStudentList = List<bool>.filled(
                                            students.length, false);
                                        studentList = List.generate(
                                          students.length,
                                          (index) {
                                            return Student(
                                                name: students[index]['name'],
                                                phoneNumber: students[index]
                                                    ['phone_number'],
                                                id: students[index]
                                                    ['student_id'],
                                                groupId: students[index]
                                                    ['group_id']);
                                          },
                                        );
                                      });
                                    },
                                    child: const Text("추가"))
                              ]);
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 105, 105, 105)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
