import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> selectDate(context) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
          2000), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101));

  return DateFormat('yyyy-MM-dd').format(pickedDate!);
}
