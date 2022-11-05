import 'package:flutter/material.dart';

class CircleAvatarInfo extends StatelessWidget {
  // const CircleAvatarInfo({Key? key}) : super(key: key);
  String text1;
  String text2;

  CircleAvatarInfo({required this.text1, required this.text2});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: FittedBox(
        fit: BoxFit.cover,
        child: Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.primary,
          child: Column(
            children: [
              Text(
                text1,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 14),
              ),
              Text(
                text2,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 11),
              ),
            ],
          ),
        ),
      ),
      maxRadius: MediaQuery.of(context).size.width * 0.09,
    );
  }
}
