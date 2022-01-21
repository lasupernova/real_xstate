import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../screens/cashflowResultDetails._screen.dart';

class CashflowResultTile extends StatelessWidget {
  final String name;
  final DateTime ROI;
  final double cashflow;
  final bool worth;

  CashflowResultTile(
      {required this.name,
      required this.ROI,
      required this.cashflow,
      required this.worth});

  // Icon worth_icon = worth ? const Icon(Icons.check)  : const Icon(Icons.check);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Navigator.of(context).pushNamed(
          CfResultDetailsScreen.routeName,
          arguments: [30, 3.25, 100000, 25]),
      leading: CircleAvatar(
        radius: 15,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: FittedBox(
            child: worth
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
      title: Text(name),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(DateFormat.yMMMd().format(ROI)),
          SizedBox(
            width: 20,
          ),
          Text("\$$cashflow / month")
        ],
      ),
    );
  }
}
