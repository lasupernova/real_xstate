import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  void sendToDB() {
    final url = Uri.parse(
        "${dotenv.env["FIREBASE_URL"]}testProp.json"); // .json addition is unique to Firebase databases for their tables
    http.post(url,
        body: json.encode({
          "Term": entryInfo["Term"],
          "Interest": entryInfo["Interest"],
          "Description": entryInfo["Description"],
        }));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing CF Form"),
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
                  return 'Please enter some text 1';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Term"),
              keyboardType: TextInputType.number,
              onSaved: (value) {
                entryInfo["Term"] = value;
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
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Description"),
              keyboardType: TextInputType.multiline,
              maxLines: 3,
              onSaved: (value) {
                entryInfo["Description"] = value;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                  margin: EdgeInsets.only(top: 8, right: 10),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Container(
                    child: _imageUrlController.text.isEmpty
                        ? Text("Enter URL")
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              errorBuilder: (ctx, url, error) =>
                                  Icon(Icons.error),
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: "Image URL"),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    controller: _imageUrlController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a value!";
                      }
                      if (!value.startsWith("http") &&
                          !value.startsWith("https")) {
                        return "You need to enter a valid URL!";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      entryInfo["IMAGE url"] = value;
                    },
                    onTap: () => _imageUrlController.selection = TextSelection(
                        baseOffset: 0,
                        extentOffset: _imageUrlController.value.text
                            .length), // select all available text on tap / focus
                  ),
                )
              ],
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
                  sendToDB();
                  print(entryInfo);
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
