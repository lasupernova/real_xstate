import 'package:flutter/material.dart';

class GenerateFieldDynamic extends StatefulWidget {
  final int index;
  Map entryInfo;
  String mapKey;
  String label;
  GenerateFieldDynamic(
      {required this.index,
      required this.entryInfo,
      required this.mapKey,
      required this.label,
      Key? key})
      : super(key: key);

  @override
  State<GenerateFieldDynamic> createState() => _GenerateFieldDynamicState();
}

class _GenerateFieldDynamicState extends State<GenerateFieldDynamic> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   _nameController.text = _MyFormState.rentsList[widget.index] ?? '';
    // });
    return TextFormField(
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty || double.parse(value) < 0) {
          return 'Please enter a value greater than 0';
        }
        // if (double.parse(value) > 0) {  // TODO: check that downpayment needs to be SMALLER than offer
        //   return 'Please enter a value greater than 0';
        // }
        return null;
      },
      textInputAction: TextInputAction.next,
      decoration:
          InputDecoration(labelText: "${widget.label} ${widget.index + 1}"),
      keyboardType: TextInputType.number,
      onSaved: (value) {
        widget.entryInfo[widget.mapKey].add(double.parse(value!));
      },
    );
  }
}
