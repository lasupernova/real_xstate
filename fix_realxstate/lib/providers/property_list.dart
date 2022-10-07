import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import './property_item.dart';

class PropertyList with ChangeNotifier {
  List<PropertyItem> entries = [];

  // var _showFavoritesOnly = false;

  late final String? authToken;

  PropertyList(this.authToken,
      this.entries); // Properties will be shown in list based on token provided

  Future<void> getProps() async {
    // TODO: implement _firstLoad check - in order to not load this every time that page is relaoaded (e.g. due to saving file)
    entries =
        []; // reset property list ,as properties will otherwise appear multiple times on screen (multiplied at every re-load)
    final response = await http.get(Uri.parse(
        "${dotenv.env["FIREBASE_URL"]}properties.json?auth=$authToken"));

    if (response.statusCode == 200) {
      final data = jsonDecode(
          response.body); // convert to Map in order to be able to use .foreach

      if (data != null) {
        data.forEach((id, propdata) {
          PropertyItem currentProp = PropertyItem(
            streetAddress: propdata['address'],
            city: propdata['city'],
            state: propdata['state'],
            country: propdata['country'],
            buyDate: DateTime.parse(propdata['buyDate']),
            totalIncome: propdata.containsKey('totalIncome')
                ? propdata['totalIncome']
                : 0, // ternary operator for specs which are not mandatory upon adding new property
            behindPaymentNum: propdata.containsKey('behindPaymentNum')
                ? propdata['behindPaymentNum']
                : 0,
            behindPayment: propdata.containsKey('behindPayment')
                ? propdata['behindPayment']
                : false,
            brokeEven: propdata.containsKey('brokeEven')
                ? propdata['brokeEven']
                : false,
          );
          entries.add(currentProp);
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

  List<PropertyItem> get fetchProperties {
    // for app-internal purposes
    return [...entries];
  }

  PropertyItem findById(String id) {
    return entries.firstWhere((property) => property.id == id);
  }

  Future<void> addProperty(newProp) async {
    // print("Add funtions is running!!!");  \\ uncomment for troubleshooting

    // send new property to cloud DB and wait for identifier
    final url = Uri.parse("${dotenv.env["FIREBASE_URL"]}properties.json");
    http.Response resp = await http.post(url,
        body: json.encode({
          "address": newProp.streetAddress,
          "city": newProp.city,
          "state": "",
          "country": newProp.country,
          "buyDate": newProp.buyDate.toIso8601String(),
        }));
    final info = jsonDecode(resp.body); // decode request response body
    final id = info["name"]; // extract necessary info (here: DB ID)
    // prive new property with unique ID and add to properties list
    newProp.id = id;
    entries.add(newProp);
    notifyListeners();
  }
}
