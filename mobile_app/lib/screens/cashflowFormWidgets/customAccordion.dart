import 'package:flutter/material.dart';

class CustomAccordion extends StatefulWidget {
  double screenWidth;
  bool accordionOpen;
  List<Widget> accordionChildren;

  CustomAccordion(
      {required this.screenWidth,
      required this.accordionOpen,
      required this.accordionChildren,
      Key? key})
      : super(key: key);

  @override
  State<CustomAccordion> createState() => _CustomAccordionState();
}

class _CustomAccordionState extends State<CustomAccordion> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Spacer(),
            Container(
              // use spacers above and below, as widgets within ListView otherwise default to taking full width -- Fittedbox takes all space from parent  (therefore contianer  width should NOT be full screen width)
              margin: EdgeInsets.all(widget.screenWidth * 0.02),
              decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.green)),
              width: widget.screenWidth * 0.5,
              child: const FittedBox(
                  child: Text(
                "Mortgage Info",
                style: TextStyle(color: Colors.black54),
              )),
            ),
            const Spacer(),
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.accordionOpen = !widget.accordionOpen;
                  });
                },
                icon: widget.accordionOpen
                    ? Icon(Icons.keyboard_arrow_up)
                    : Icon(Icons.keyboard_arrow_down))
          ],
        ),
        Visibility(
          visible: widget.accordionOpen,
          maintainState:
              true, // allows data to be saved, although currently hidden
          child: Column(
            children: widget.accordionChildren,
          ),
        )
      ],
    );
  }
}
