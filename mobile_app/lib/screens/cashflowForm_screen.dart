import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart' as prov;

import '../models/mortgageCalcs.dart' as mg;
import './mortgageCalculated_Screen.dart';
import '../providers/cashflow_list.dart';
import '../models/cashflowResult.dart';
import './cashflowFormWidgets/rentsWidget.dart';

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
  static List<String> rentsList = [""];

  void _saveForm() {
    _formKey.currentState!.save();
    double mortgage = mg.calculateMortgage(
      entryInfo["offer"],
      entryInfo["downpayment"],
      entryInfo["interest"],
      entryInfo["term"],
    );
    entryInfo["mortgage"] = mortgage;
    prov.Provider.of<CashflowList>(context, listen: false).addCF(CashflowItem(
      // 'listen:false', as no rebuild of current widget is wanted
      mortgage: entryInfo["mortgage"],
      offer: entryInfo["offer"],
      downpayment: entryInfo["downpayment"],
      interest: entryInfo["interest"],
      term: entryInfo["term"],
      calcDate: DateTime.now(),
    ));
    // saving the current state allows Form() to go over every entry for all TextFormFIelds and do anything with them; but executing the function specified under onSaved for every TextFormField
  }

  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          rentsList.insert(0, rentsList[index]);
        } else {
          rentsList.removeAt(index);
        }
        ;
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getFriends() {
    List<Widget> friendsTextFieldsList = [];
    for (int i = 0; i < rentsList.length; i++) {
      friendsTextFieldsList.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: RentFieldDynamic(i, entryInfo)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row only
            _addRemoveButton(i == rentsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFieldsList;
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
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
            Row(
              children: [
                const Spacer(),
                Container(
                  // use spacers above and below, as widgets within ListView otherwise default to taking full width -- Fittedbox takes all space from parent  (therefore contianer  width should NOT be full screen width)
                  margin: EdgeInsets.all(_screenWidth * 0.02),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.green)),
                  width: _screenWidth * 0.5,
                  child: const FittedBox(
                      child: Text(
                    "Mortgage Info",
                    style: TextStyle(color: Colors.black54),
                  )),
                ),
                const Spacer(),
              ],
            ),
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
                entryInfo["term"] = int.parse(value!);
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
                entryInfo["interest"] = double.parse(value!);
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
                entryInfo["offer"] = double.parse(value!);
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
                entryInfo["downpayment"] = double.parse(value!);
              },
            ),
            Row(
              children: [
                const Spacer(),
                Container(
                  // use spacers above and below, as widgets within ListView otherwise default to taking full width -- Fittedbox takes all space from parent  (therefore contianer  width should NOT be full screen width)
                  margin: EdgeInsets.all(_screenWidth * 0.02),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.green)),
                  width: _screenWidth * 0.5,
                  child: const FittedBox(
                      child: Text(
                    "Income",
                    style: TextStyle(color: Colors.black54),
                  )),
                ),
                const Spacer(),
              ],
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: rentsList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: RentFieldDynamic(index, entryInfo),
                    trailing: index + 1 == rentsList.length
                        ? _addRemoveButton(true, index)
                        : _addRemoveButton(false, index),
                  );
                }),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // .."currentState!.validate()" triggers all defined TextFormField validators -- and returns "true", if no error was thrown!
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  _saveForm();
                  _formKey.currentState!.reset();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Processing Data'),
                      duration: Duration(seconds: 1),
                    ),
                  );
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
