import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kmong_repo_a1/models/student.dart';
import 'package:kmong_repo_a1/widgets/button.dart';
import 'package:kmong_repo_a1/widgets/input.dart';
import 'package:sqflite/sqflite.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);
  final groupController = TextEditingController();
  late Student selectedStudent;
  late String selectedGroupName = "전체";
  late String selectedRemoveGroupName = "전체";
  List<String> groupList = ["전체"];

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 0)).then((_) async {
      var db = await openDatabase("student.db", version: 1);

      final List<Map<String, dynamic>> groups =
          await db.rawQuery("SELECT * FROM student_group");

      setState(() {
        if (groups.isEmpty || groups.length == 1) {
          groupList = ["전체"];
        } else {
          groupList = List.generate(groups.length, (index) {
            return groups[index]['name'];
          });
          groupList.insert(0, "전체");
        }

        selectedGroupName = groupList[selectedStudent.groupId];
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    selectedStudent = ModalRoute.of(context)!.settings.arguments as Student;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(selectedStudent.name),
              const SizedBox(
                width: 20,
              ),
              Text(selectedStudent.phoneNumber),
              const SizedBox(
                width: 20,
              ),
              DropdownButton(
                value: selectedGroupName.isNotEmpty ? selectedGroupName : "전체",
                items: groupList.map<DropdownMenuItem<String>>((String group) {
                  return DropdownMenuItem<String>(
                      value: group, child: Text(group));
                }).toList(),
                onChanged: (selectGroup) {
                  setState(() {
                    selectedGroupName = selectGroup!;
                  });
                },
              ),
            ],
          ),
          SizedBox(
            width: 400,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonWidget(
                    text: "상태저장",
                    handler: () async {
                      var studentId = selectedStudent.id;
                      var selectedGroupId =
                          groupList.indexOf(selectedGroupName);

                      var db = await openDatabase("student.db", version: 1);
                      await db.rawUpdate(
                          "UPDATE student SET group_id = $selectedGroupId WHERE student_id = $studentId");
                      List<Map<String, dynamic>> student = await db.rawQuery(
                          "SELECT * FROM student WHERE student_id = $studentId");

                      setState(() {
                        selectedStudent = Student(
                            name: student[0]['name'],
                            phoneNumber: student[0]['phone_number'],
                            id: student[0]['student_id'],
                            groupId: student[0]['group_id']);
                      });

                      if (context.mounted) {
                        Navigator.pushNamed(context, "/home");
                        Get.snackbar("상태 저장 완료", "데이터가 성공적으로 수정되었습니다");
                      }
                    },
                    backgroundColor: Colors.yellow),
                const SizedBox(
                  width: 30,
                ),
                ButtonWidget(
                    text: "학생삭제",
                    handler: () async {
                      var studentId = selectedStudent.id;
                      var db = await openDatabase("student.db", version: 1);
                      await db.rawDelete(
                          "DELETE FROM student WHERE student_id=$studentId");

                      if (context.mounted) {
                        Navigator.pushNamed(context, "/home");
                        Get.snackbar("데이터 삭제 완료", "데이터가 성공적으로 삭제되었습니다");
                      }
                    },
                    backgroundColor: Colors.yellow),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                  text: "그룹 추가",
                  fontColor: Colors.white,
                  handler: () {
                    Get.defaultDialog(
                        title: "그룹 추가",
                        content: Column(
                          children: [
                            InputWidget(
                                text: "이름을 입력해주세요",
                                isSecure: false,
                                controller: groupController),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                              onPressed: Get.back, child: const Text("취소")),
                          TextButton(
                              onPressed: () async {
                                String name = groupController.text;

                                var db = await openDatabase("student.db",
                                    version: 1);
                                await db.rawInsert(
                                    "INSERT INTO student_group(name) VALUES('$name')");
                                List<Map<String, dynamic>> groups = await db
                                    .rawQuery("SELECT * FROM student_group");

                                setState(() {
                                  if (groups.isEmpty || groups.length == 1) {
                                    groupList = ["전체"];
                                  } else {
                                    groupList =
                                        List.generate(groups.length, (index) {
                                      return groups[index]['name'];
                                    });
                                  }
                                });

                                Get.back();
                                Get.snackbar("그룹 추가 완료", "그룹이 성공적으로 추가되었습니다");
                              },
                              child: const Text("추가"))
                        ]);
                  },
                  backgroundColor: const Color.fromARGB(255, 105, 105, 105)),
              const SizedBox(
                width: 30,
              ),
              ButtonWidget(
                  text: "그룹 삭제",
                  fontColor: Colors.white,
                  handler: () {
                    Get.defaultDialog(
                        title: "그룹 삭제",
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Column(
                            children: [
                              DropdownButton(
                                value: selectedRemoveGroupName.isNotEmpty
                                    ? selectedRemoveGroupName
                                    : "전체",
                                items: groupList.map<DropdownMenuItem<String>>(
                                    (String group) {
                                  return DropdownMenuItem<String>(
                                      value: group, child: Text(group));
                                }).toList(),
                                onChanged: (selectGroup) {
                                  setState(() {
                                    selectedRemoveGroupName = selectGroup!;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          );
                        }),
                        actions: [
                          TextButton(
                              onPressed: Get.back, child: const Text("취소")),
                          TextButton(
                              onPressed: () async {
                                var db = await openDatabase("student.db",
                                    version: 1);
                                var groupId =
                                    groupList.indexOf(selectedRemoveGroupName);

                                if (groupId == 0) {
                                  Get.snackbar(
                                      "전체 그룹 삭제 불가", "전체 그룹은 삭제할 수 없습니다");
                                  return;
                                }

                                await db.rawDelete(
                                    "DELETE FROM student_group WHERE group_id=?",
                                    [groupId]);

                                if (!context.mounted) {
                                  return;
                                }
                                Navigator.pushNamed(context, "/home");
                                Get.snackbar("데이터 삭제 완료", "데이터가 성공적으로 삭제되었습니다");
                              },
                              child: const Text("삭제"))
                        ]);
                  },
                  backgroundColor: const Color.fromARGB(255, 105, 105, 105)),
            ],
          )
        ],
      ),
    );
  }
}
