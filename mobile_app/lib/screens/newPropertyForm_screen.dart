import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';

import '../providers/property_list.dart';
import '../providers/property_item.dart';

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

  // methods
  void _saveForm() {
    _formKey.currentState!.save();
    print(entryInfo);
    Provider.of<PropertyList>(context, listen: false).addProperty(PropertyItem(
        // 'listen:false', as no rebuild of current widget is wanted
        streetAddress: entryInfo["streetaddress"],
        city: entryInfo["city"],
        state: "TEST",
        country: entryInfo["country"],
        buyDate: DateTime(2021, 8, 13)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a new property"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.clear))],
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
              textInputAction: TextInputAction.next,
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a date';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: "Buying Date",
                hintText: "When did you buy this property...",
              ),
              keyboardType: TextInputType.datetime,
              onSaved: (value) {
                entryInfo["buydate"] = value;
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
