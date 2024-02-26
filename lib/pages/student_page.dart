import 'package:flutter/material.dart';
import 'package:kmong_repo_a1/models/student.dart';
import 'package:kmong_repo_a1/widgets/input.dart';
import 'package:sqflite/sqflite.dart';

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final backgroundColor = const Color.fromARGB(255, 250, 250, 210);
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  List<Student> studentList = [];
  List<String> groupList = [];

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3)).then((_) async {
      var db = await openDatabase("student.db", version: 1);

      final List<Map<String, dynamic>> groups =
          await db.rawQuery("SELECT * FROM student_group");
      final List<Map<String, dynamic>> students =
          await db.rawQuery("SELECT * FROM student");

      if (groups.isEmpty) {
        groupList = ["전체"];
      } else {
        groupList = List.generate(groups.length, (index) {
          return groups[index]['name'];
        });
        groupList.insert(0, "전체");
      }

      if (students.isEmpty) {
        studentList = [];
      } else {
        studentList = List.generate(
          students.length,
          (index) {
            return Student(
                name: students[index]['name'],
                phoneNumber: students[index]['phone_number'],
                id: students[index]['student_id']);
          },
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemCount: studentList.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Text(studentList[index].name),
                    // DropdownButton(value: studentList[index]., items: , onChanged: onChanged)
                  ],
                );
              },
            ),
          ),
          Column()
        ],
      ),
    );
  }
}
