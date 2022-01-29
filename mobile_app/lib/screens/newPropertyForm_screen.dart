import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/property_list.dart';
import '../providers/property_item.dart';
import '../widgets/pickDate.dart';

class NewPropertyForm extends StatefulWidget {
  static const routeName = "/add-property";
  NewPropertyForm({Key? key}) : super(key: key);

  @override
  State<NewPropertyForm> createState() => _NewPropertyFormState();
}

class _NewPropertyFormState extends State<NewPropertyForm> {
  //
  // define global key - for latter Form operations
  final _formKey = GlobalKey<FormState>();
  // create map to store form values for further usage
  Map entryInfo = {};
  // controller for DatePicker date storage
  TextEditingController _dateinput = TextEditingController();

  @override
  void initState() {
    _dateinput.text = DateFormat('yyyy-MM-dd')
        .format(DateTime.now()); //set the initial value of text field
    super.initState();
  }

  // methods
  void _resetPropForm() {
    FocusScope.of(context).unfocus();
    _formKey.currentState!.reset();
    setState(() {
      _dateinput.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    });
  }

  void _saveForm() {
    _formKey.currentState!.save();
    // print(entryInfo);  // uncomment for debugging
    Provider.of<PropertyList>(context, listen: false).addProperty(PropertyItem(
        // 'listen:false', as no rebuild of current widget is wanted
        streetAddress: entryInfo["streetaddress"],
        city: entryInfo["city"],
        state: "TEST",
        country: entryInfo["country"],
        buyDate: entryInfo["buydate"]));
    _resetPropForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new property"),
        actions: [
          IconButton(onPressed: () => _resetPropForm(), icon: Icon(Icons.clear))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an address';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Address",
                hintText: "Insert the property's street address...",
              ),
              keyboardType: TextInputType.streetAddress,
              onSaved: (value) {
                entryInfo["streetaddress"] = value;
              },
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a city';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "City",
                hintText: "Insert the property's city...",
              ),
              keyboardType: TextInputType.streetAddress,
              onSaved: (value) {
                entryInfo["city"] = value;
              },
            ),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a country';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: "Country",
                hintText: "Insert the property's country...",
              ),
              keyboardType: TextInputType.streetAddress,
              onSaved: (value) {
                entryInfo["country"] = value;
              },
            ),
            TextFormField(
              controller: _dateinput, //editing controller of this TextField
              decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Enter Buy Date" //label text of field
                  ),
              readOnly:
                  true, //set it true, so that user will not able to edit text
              onTap: () {
                selectDate(context, _dateinput.text).then((value) {
                  // .then() necessary, as selectDate returns a Future<DateTime>
                  setState(() {
                    _dateinput.text = value!;
                  });
                  print(_formKey.currentState.toString());
                });
              },
              onSaved: (value) {
                entryInfo["buydate"] = DateTime.parse(_dateinput.text);
              },
            ),
            ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveForm();
                  }
                  ;
                },
                child: Text("Register Property"))
          ],
        ),
      ),
    );
  }
}
