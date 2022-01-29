import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<String?> selectDate(context, currDate) async {
  DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(currDate),
      firstDate: DateTime(
          2000), //DateTime.now() - not to allow to choose before today.
      lastDate: DateTime(2101));

  if (pickedDate != null) {
    return DateFormat('yyyy-MM-dd').format(pickedDate);
  } else {
    return DateFormat('yyyy-MM-dd').format(currDate);
  }
}
