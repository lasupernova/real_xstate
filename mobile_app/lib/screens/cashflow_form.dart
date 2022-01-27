import 'package:flutter/material.dart';

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
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      appBar: AppBar(
        title: Text("Testing CF Form"),
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
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text 2';
                }
                return null;
              },
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: "Interest"),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
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
