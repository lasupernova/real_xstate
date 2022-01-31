import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './property_item.dart';

class PropertyList with ChangeNotifier {
  List<PropertyItem> _entries = [
    PropertyItem(
        streetAddress: "2825 33rd Str.",
        city: "Binghamptom",
        state: "NY",
        country: "US",
        buyDate: DateTime(2021, 2, 15),
        totalIncome: 10000.0,
        behindPaymentNum: 0,
        behindPayment: false,
        brokeEven: true),
    PropertyItem(
        streetAddress: "112 Adams Ave.",
        city: "Binghamptom",
        state: "NY",
        country: "US",
        buyDate: DateTime(2021, 8, 13),
        totalIncome: 3000.50,
        behindPaymentNum: 190,
        behindPayment: true,
        brokeEven: false),
    PropertyItem(
        streetAddress: "3rd Address",
        city: "different citt",
        state: "NY",
        country: "US",
        buyDate: DateTime(2019, 4, 11),
        totalIncome: 3000.50,
        behindPaymentNum: 10,
        behindPayment: true,
        brokeEven: false),
    PropertyItem(
        streetAddress: "4th Address",
        city: "lala land",
        state: "NY",
        country: "US",
        buyDate: DateTime(2022, 1, 20),
        totalIncome: 100,
        // behindPaymentNum: 0,
        // behindPayment: false,
        brokeEven: false),
    PropertyItem(
        streetAddress: "5th Address",
        city: "Binghamptom",
        state: "NY",
        country: "US",
        buyDate: DateTime(2018, 12, 30),
        totalIncome: 30000.50,
        behindPaymentNum: 0,
        behindPayment: false,
        brokeEven: true),
  ];

  // var _showFavoritesOnly = false;

  List<PropertyItem> get fetchProperties {
    return [..._entries];
  }

  PropertyItem findById(String id) {
    return _entries.firstWhere((property) => property.id == id);
  }

  Future<void> addProperty(newProp) async {
    // print("Add funtions is running!!!");  \\ uncomment for troubleshooting

    print(newProp.streetAddress);

    // send new property to cloud DB and wait for identifier
    final url = Uri.parse("${dotenv.env["FIREBASE_URL"]}propperties.json");
    http.Response resp = await http.post(url,
        body: json.encode({
          "address": newProp.streetAddress,
          "city": newProp.city,
          "state": "",
          "buyDate": newProp.buyDate.toIso8601String(),
        }));
    final info = jsonDecode(resp.body); // decode request response body
    final id = info["name"]; // extract necessary info (here: DB ID)
    // prive new property with unique ID and add to properties list
    newProp.id = id;
    _entries.add(newProp);
    notifyListeners();
  }
}
