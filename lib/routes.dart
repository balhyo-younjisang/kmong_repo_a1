import 'package:flutter/material.dart';
import 'package:kmong_repo_a1/pages/admin_page.dart';
import 'package:kmong_repo_a1/pages/home_page.dart';
import 'package:kmong_repo_a1/pages/join_page.dart';
import 'package:kmong_repo_a1/pages/login_page.dart';
import 'package:kmong_repo_a1/pages/send_page.dart';
import 'package:kmong_repo_a1/pages/student_page.dart';

final routes = {
  "/": (BuildContext context) => const LoginPage(),
  "/join": (BuildContext context) => JoinPage(),
  "/home": (BuildContext context) => const HomePage(),
  "/student": (BuildContext context) => const StudentPage(),
  "/send": (BuildContext context) => const SendPage(),
  "/admin": (BuildContext context) => const AdminPage(),
};
