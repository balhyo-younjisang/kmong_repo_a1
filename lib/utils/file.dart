import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';

Future<void> openExcelFile() async {
  var db = await openDatabase("student.db", version: 1);
  FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom, allowedExtensions: ['xlsx'], allowMultiple: false);

  if (result != null) {
    var filePath = result.paths[0];
    var bytes = File(filePath!).readAsBytesSync();
    dynamic excel = Excel.decodeBytes(bytes);

    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows) {
        dynamic name = row[0].value;
        dynamic phoneNumber = row[1].value;

        if (phoneNumber.toString().length == 10) {
          phoneNumber = '0$phoneNumber';
        }

        await db.rawInsert(
            "INSERT INTO student(name, phone_number, group_id) VALUES('$name', '$phoneNumber', 0)");
      }
    }
  }
}
