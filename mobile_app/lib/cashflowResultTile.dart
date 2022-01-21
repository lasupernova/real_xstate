import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      leading: CircleAvatar(
        radius: 15,
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
        children: [
          Text(DateFormat.yMMMd().format(ROI)),
          Text("\$$cashflow / month")
        ],
      ),
    );
  }
}
