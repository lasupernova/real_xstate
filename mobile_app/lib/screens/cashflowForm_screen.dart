import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/mortgageCalcs.dart' as mg;
import './mortgageCalculated_Screen.dart';

// Define a custom Form widget.
class CashflowForm extends StatefulWidget {
  static const routeName = "/cashflow-form";
  const CashflowForm({Key? key}) : super(key: key);

  @override
  CashflowFormState createState() {
    return CashflowFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class CashflowFormState extends State<CashflowForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<
      FormState>(); // GLobalKeys are rarely used,only when interaction with widget from inside code is necessary --> here: Form needs to be submitted/validated etc, function within code needs access to widget Form()
  final _imageUrlController =
      TextEditingController(); // usuallyh not needed when using Form(), BUT: here image textinput should be used prior to any action that Form() takes, as image should be displyed in Container() above
  Map entryInfo = {};

  void _saveForm() {
    _formKey.currentState!
        .save(); // saving the current state allows Form() to go over every entry for all TextFormFIelds and do anything with them; but executing the function specified under onSaved for every TextFormField
  }

  Future<void> sendToDB() async {
    final url = Uri.parse(
        "${dotenv.env["FIREBASE_URL"]}testCF.json"); // .json addition is unique to Firebase databases for their tables
    final resp = await http.post(url,
        body: json.encode({
          "Term": double.parse(entryInfo["Term"]),
          "Interest": double.parse(entryInfo["Interest"]),
          "Offer": double.parse(entryInfo["Offer"]),
          "Downpayment": double.parse(entryInfo["Downpayment"]),
        }));
    print(resp.statusCode);
    print(jsonDecode(resp.body));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text("Mortgage Calculator"),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save_outlined))
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a value';
                }
                if (double.parse(value) < 0 || double.parse(value) > 50) {
                  // check if number is in desired range (parse will work as non-numerical entry was checked above)
                  return 'Please enter a number of years between 0 and 50';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Term"),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                entryInfo["Term"] = int.parse(value!);
              },
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  // check sth was entered
                  return 'Please enter a value';
                }
                if (double.tryParse(value) == null) {
                  // check that entry is a number
                  return 'Please enter a valid number';
                }
                if (double.parse(value) < 0 || double.parse(value) > 100) {
                  // check if number is in desired range (parse will work as non-numerical entry was checked above)
                  return 'Please enter a number between 0 and 100';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Interest"),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                entryInfo["Interest"] = double.parse(value!);
              },
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty || double.parse(value) < 0) {
                  return 'Please enter a value greater than 0';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Offer"),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                entryInfo["Offer"] = double.parse(value!);
              },
            ),
            TextFormField(
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
              decoration: InputDecoration(labelText: "Downpayment"),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                entryInfo["Downpayment"] = double.parse(value!);
              },
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // .."currentState!.validate()" triggers all defined TextFormField validators -- and returns "true", if no error was thrown!
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  _saveForm();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing Data'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  double mortgage = mg.calculateMortgage(
                    entryInfo["Offer"],
                    entryInfo["Downpayment"],
                    entryInfo["Interest"] / 100 * 12,
                    entryInfo["Term"],
                  );
                  print(entryInfo);
                  print("Mortgage calculated: $mortgage");
                  entryInfo["Mortgage"] = mortgage;
                  Navigator.of(context).pushNamed(
                      MortgageResult.routeName, // ERROR FROM HERE@!!!!
                      arguments: entryInfo);
                }
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
