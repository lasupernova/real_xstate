import 'package:flutter/material.dart';

class RentFieldDynamic extends StatefulWidget {
  final int index;
  Map entryInfo;
  RentFieldDynamic(this.index, this.entryInfo, {Key? key}) : super(key: key);

  @override
  State<RentFieldDynamic> createState() => _RentFieldDynamicState();
}

class _RentFieldDynamicState extends State<RentFieldDynamic> {
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
      decoration: InputDecoration(labelText: "Rent ${widget.index + 1}"),
      keyboardType: TextInputType.number,
      onSaved: (value) {
        widget.entryInfo["rent${widget.index}"] = double.parse(value!);
      },
    );
  }
}
