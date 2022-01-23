import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/cashflowResultDetails._screen.dart';

class PropertyOverviewTile extends StatelessWidget {
  final String streetAddress;
  final String city;
  final String state;
  final String country;
  final DateTime buyDate;
  final double totalIncome;
  final double behindPaymentNum;
  final bool behindPayment;
  final bool brokeEven;

  PropertyOverviewTile(
      {required this.streetAddress,
      required this.city,
      required this.state,
      required this.country,
      required this.buyDate,
      required this.totalIncome,
      required this.behindPaymentNum,
      required this.behindPayment,
      required this.brokeEven});

  // Icon worth_icon = worth ? const Icon(Icons.check)  : const Icon(Icons.check);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: () => print(
            "Navigator.of(context).pushNamed(PropertyDetailsScreen.routeName),arguments: [30, 3.25, 100000, 25])"),
        leading: CircleAvatar(
          radius: 15,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          child: Padding(
            padding: const EdgeInsets.all(3),
            child: FittedBox(
              child: !behindPayment
                  ? const Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.dangerous,
                      color: Colors.red,
                    ),
            ),
          ),
        ),
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            streetAddress,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.subtitle2!.fontSize),
          ),
          Text(
            "$city, $country",
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyText1!.fontSize),
          ),
          SizedBox(
            height: 4,
          )
        ]),
        subtitle: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("purchased: ${DateFormat.yMMMd().format(buyDate)}"),
              SizedBox(
                width: 10,
              ),
              Text("Total Income: \$$totalIncome")
            ],
          ),
        ));
  }
}
