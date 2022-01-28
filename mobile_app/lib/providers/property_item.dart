import 'package:flutter/material.dart';

class PropertyItem {
  // const PropertyItem({Key? key}) : super(key: key);
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final DateTime buyDate;
  double totalIncome;
  double behindPaymentNum;
  bool behindPayment;
  bool brokeEven;

  PropertyItem(
      {required this.streetAddress,
      required this.city,
      required this.state,
      required this.country,
      required this.buyDate,
      this.totalIncome = 0,
      this.behindPaymentNum = 0,
      this.behindPayment = false,
      this.brokeEven = false});
}
