import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/cashflow_list.dart';
import 'package:provider/provider.dart';

import '../screens/cashflowResultDetails._screen.dart';
import '../providers/cashflow_list.dart';

class CashflowResultTile extends StatelessWidget {
  final String name;
  final DateTime ROI;
  final String cashflow;
  final bool worth;

  CashflowResultTile(
      {required this.name,
      required this.ROI,
      required this.cashflow,
      required this.worth});

  // Icon worth_icon = worth ? const Icon(Icons.check)  : const Icon(Icons.check);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // TODO: fix dismissed dismissible error!!!
      key: Key(name),
      background: Container(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [Icon(Icons.delete)],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<CashflowList>(context, listen: false)
              .removeCashflow(name);
        } else {
          print("Nothing happening");
        }
      },
      child: ListTile(
        onTap: () => Navigator.of(context)
            .pushNamed(CfResultDetailsScreen.routeName, arguments: name),
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
      ),
    );
  }
}
