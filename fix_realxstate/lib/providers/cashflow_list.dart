import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/cashflowResult.dart';

class CashflowList with ChangeNotifier {
  List<CashflowItem> entries = [];

  // var _showFavoritesOnly = false;

  late final String? authToken;

  late final String? userID;

  CashflowList(this.authToken, this.userID,
      this.entries); // Cashflow Calcs will be shown in list based on token provided

  Future<void> getCFs() async {
    // TODO: implement _firstLoad check - in order to not load this every time that page is relaoaded (e.g. due to saving file)
    entries =
        []; // reset property list ,as properties will otherwise appear multiple times on screen (multiplied at every re-load)
    final response = await http.get(Uri.parse(
        "${dotenv.env["FIREBASE_URL"]}$userID/cashflow.json?auth=$authToken"));

    if (response.statusCode == 200) {
      final data = jsonDecode(
          response.body); // convert to Map in order to be able to use .foreach

      if (data != null) {
        data.forEach((id, propdata) {
          // DB id is the key, data is the value
          CashflowItem currentCF = CashflowItem(
              id: id,
              offer: propdata['offer'],
              downpayment: propdata['downpayment'],
              interest: propdata['interest'],
              term: propdata['term'],
              rents: propdata['rents'],
              costs: propdata['costs'],
              calcDate: DateTime.parse(propdata['calcDate']),
              propMgmtPerc: propdata['propMgmtPerc'],
              vacancyLossPerc: propdata['vacancyLossPerc'],
              capitalExpPerc: propdata['capitalExpPerc'],
              legal: propdata['legal'],
              homeInsp: propdata['homeInsp'],
              propMgmtSignUp: propdata['propMgmtSignUp'],
              bankFees: propdata['bankFees'],
              favorite: propdata.containsKey("favorite")
                  ? propdata['favorite']
                  : false);
          currentCF
              .getCashflow(); // calculate properties that have not been saved in DB
          entries.add(currentCF);
        });
      }
    }
    notifyListeners();
    return;
  }
  // else {
  //   // If the server did not return a 200 OK response,
  //   // then throw an exception.
  //   throw Exception('Failed to load album');
  // }

  List<CashflowItem> get fetchCFs {
    // for app-internal purposes
    return [...entries];
  }

  CashflowItem findById(String id) {
    return entries.firstWhere((cashflow) => cashflow.id == id);
    // return entries.where((element) => false) Where((cashflow) => cashflow.id == id);
  }

  Future<String> addCF(newProp) async {
    //TODO: add authentication (?auth=...;) for ADDING cashflow too here (+ also for PropertyList)
    // UDES IN: screens/cashflowForm_screen.dart
    // print("Add funtions is running!!!");  \\ uncomment for troubleshooting

    // send new property to cloud DB and wait for identifier
    final url = Uri.parse(
        "${dotenv.env["FIREBASE_URL"]}$userID/cashflow.json?auth=$authToken");
    http.Response resp = await http.post(url,
        body: json.encode({
          "offer": newProp.offer,
          "downpayment": newProp.downpayment,
          "interest": newProp.interest,
          "term": newProp.term,
          "calcDate": newProp.calcDate.toIso8601String(),
          "rents": newProp.rents,
          "costs": newProp.costs,
          "propMgmtPerc": newProp.propMgmtPerc,
          "vacancyLossPerc": newProp.vacancyLossPerc,
          "capitalExpPerc": newProp.capitalExpPerc,
          "legal": newProp.legal,
          "homeInsp": newProp.homeInsp,
          "propMgmtSignUp": newProp.propMgmtSignUp,
          "bankFees": newProp.bankFees,
          "favorite": false
        }));
    final info = jsonDecode(resp.body); // decode request response body
    final id = info["name"]; // extract necessary info (here: DB ID)
    // prive new property with unique ID and add to properties list
    newProp.id = id;
    entries.add(newProp);
    notifyListeners();
    return id; // returning ID to direclty access new CF Results from cashflowForm_screen
  }

  Future<void> removeCashflow(id) async {
    final url = Uri.parse(
        "${dotenv.env["FIREBASE_URL"]}$userID/cashflow/$id.json?auth=$authToken");
    http.Response resp = await http.delete(url);

    if (resp.statusCode == 200) {
      entries.removeWhere((cashflow) => cashflow.id == id);
      notifyListeners(); // NECESSARY! otherwise "dismissed Dismissible Error" will be thrown
    }
    return;
  }

  Future<void> toggleFaveStatus(id) async {
    final url = Uri.parse(
        "${dotenv.env["FIREBASE_URL"]}$userID/cashflow/$id.json?auth=$authToken");
    CashflowItem currEntry = entries.firstWhere(
        (cashflow) => cashflow.id == id); // select entry with passed id
    print("BEFORE: ${currEntry.favorite}");
    currEntry.favorite =
        currEntry.favorite ? false : true; // toggle favorite status
    print("AFTER: ${currEntry.favorite}");
    http.Response resp = await http.patch(url,
        body: json.encode({
          "favorite": currEntry.favorite
        })); // pass new favorite status to DB

    if (resp.statusCode == 200) {
      notifyListeners(); // NECESSARY! otherwise "dismissed Dismissible Error" will be thrown
    }
    return;
  }
}
