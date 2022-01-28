import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app/providers/property_item.dart';

import '../screens/cashflowResultDetails._screen.dart';

class PropertyOverviewTile extends StatelessWidget {
  final PropertyItem passedProperty;

  PropertyOverviewTile({required this.passedProperty});

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
              child: !passedProperty.behindPayment
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
            passedProperty.streetAddress,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.subtitle2!.fontSize),
          ),
          Text(
            "${passedProperty.city}, ${passedProperty.country}",
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
              Text(
                  "purchased: ${DateFormat.yMMMd().format(passedProperty.buyDate)}"),
              SizedBox(
                width: 10,
              ),
              Text("Total Income: \$${passedProperty.totalIncome}")
            ],
          ),
        ));
  }
}
