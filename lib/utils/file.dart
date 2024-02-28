import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

void openExcelFile() async {
  FilePickerResult? result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);

  if (result != null) {
    File file = File(result.files.single.path.toString());
    debugPrint(file.path);
  }
}
