import 'package:flutter/material.dart';

class PropertyItem extends StatelessWidget {
  // const PropertyItem({Key? key}) : super(key: key);
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final DateTime buyDate;
  final double totalIncome;
  final double behindPaymentNum;
  final bool behindPayment;
  final bool brokeEven;

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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
          "Property on $streetAddress in $city ($state, $country) was bought on $buyDate"),
    );
  }
}
