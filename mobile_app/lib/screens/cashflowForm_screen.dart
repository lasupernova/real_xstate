import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart' as prov;
import 'package:accordion/accordion.dart';

import '../models/mortgageCalcs.dart' as mg;
import './mortgageCalculated_Screen.dart';
import '../providers/cashflow_list.dart';
import '../models/cashflowResult.dart';
import './cashflowFormWidgets/dynamicTextFormInput.dart';
import './cashflowFormWidgets/customAccordion.dart';
import '../screens/cashflowResultDetails._screen.dart';

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
  static List<String> costsList = [""];
  String dbID = "";

  // visibility indicators
  bool closingCostsOpen = true;
  bool mortgageOpen = false;
  bool incomeOpen = false;
  bool recurringCostOpen = false;
  bool rentAssocExpOpen = false;

  // visibilityrefresh funcs  -- used to update visibility indicators from insde external widget (CustomAccordion)
  // TODO: find more efficient solution -- one function per indicator is not optimal
  void refreshClosingCostOpen(bool childValue) {
    setState(() {
      closingCostsOpen = childValue;
    });
  }

  void refreshMortgageOpen(bool childValue) {
    setState(() {
      mortgageOpen = childValue;
    });
  }

  void refreshIncomeOpen(bool childValue) {
    setState(() {
      incomeOpen = childValue;
    });
  }

  void refreshCostOpen(bool childValue) {
    setState(() {
      recurringCostOpen = childValue;
    });
  }

  void refreshRentAssocExpOpen(bool childValue) {
    setState(() {
      rentAssocExpOpen = childValue;
    });
  }

  // text input controllers -- only necessary for TextFormFields, NOT necessary for GenerateFieldDynamic (as these have a intrinsinc controller within their custom classes already)

  TextEditingController legalControll = TextEditingController();
  TextEditingController homeInspControll = TextEditingController();
  TextEditingController propMgmtSignUpControll = TextEditingController();
  TextEditingController bankControll = TextEditingController();
  TextEditingController termControll = TextEditingController();
  TextEditingController interestControll = TextEditingController();
  TextEditingController offerControll = TextEditingController();
  TextEditingController downpaymentControll = TextEditingController();
  TextEditingController propMgmtPercControll = TextEditingController();
  TextEditingController vacancyLossPercControll = TextEditingController();
  TextEditingController capitalEpxPercControll = TextEditingController();

  void _saveForm() {
    // saving the current state allows Form() to go over every entry for all TextFormFIelds and do anything with them; but executing the function specified under onSaved for every TextFormField
    entryInfo['rents'] = [];
    entryInfo['costs'] = [];
    _formKey.currentState!.save();
    print(entryInfo);
    CashflowItem newCF = CashflowItem(
      // 'listen:false', as no rebuild of current widget is wanted
      offer: entryInfo["offer"],
      downpayment: entryInfo["downpayment"],
      interest: entryInfo["interest"],
      term: entryInfo["term"],
      rents: entryInfo["rents"],
      calcDate: DateTime.now(),
      costs: entryInfo["costs"],
      legal: entryInfo["legal"],
      homeInsp: entryInfo["homeInsp"],
      propMgmtSignUp: entryInfo["propMgmtSignUp"],
      bankFees: entryInfo["bankFees"],
      propMgmtPerc: entryInfo["propMgmtPerc"] / 100,
      vacancyLossPerc: entryInfo["vacancyLossPerc"] / 100,
      capitalExpPerc: entryInfo["capitalExpPerc"] / 100,
    );
    newCF
        .getCashflow(); // calculate relevant cashflow properties based on form inputs
    prov.Provider.of<CashflowList>(context, listen: false)
        .addCF(newCF)
        .then((value) {
      Navigator.of(context)
          .pushNamed(CfResultDetailsScreen.routeName, arguments: value);
    }); // use returned value = String (after Future is resolved) to navigate cashflow result screen of newly created CF
  }

  Widget _addRemoveButton(bool add, int index, List currList) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          currList.insert(0, currList[index]);
        } else {
          currList.removeAt(index);
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

  // List<Widget> _getFriends() {
  //   List<Widget> friendsTextFieldsList = [];
  //   for (int i = 0; i < rentsList.length; i++) {
  //     friendsTextFieldsList.add(Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 16.0),
  //       child: Row(
  //         children: [
  //           Expanded(child: RentFieldDynamic(i, entryInfo['rents'])),
  //           SizedBox(
  //             width: 16,
  //           ),
  //           // we need add button at last friends row only
  //           _addRemoveButton(i == rentsList.length - 1, i),
  //         ],
  //       ),
  //     ));
  //   }
  //   return friendsTextFieldsList;
  // }

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
        child: SingleChildScrollView(
          // use SingleChildScrollView + Column instead of ListView, to avoid input from disappear on scrolling (-> Reason: ListView has recycling nature and only renders the visible children )
          child: Column(
            children: <Widget>[
              CustomAccordion(
                  screenWidth: _screenWidth,
                  accordionOpen: closingCostsOpen,
                  accordionChildren: [
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            // toggle accordion section open if no value was entered (for easier findability)
                            closingCostsOpen = true;
                          });
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration:
                          const InputDecoration(labelText: "Legal Fees"),
                      keyboardType: TextInputType.number,
                      controller:
                          legalControll, // added controller to avoid input deletion on toggling
                      onSaved: (value) {
                        entryInfo["legal"] = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            closingCostsOpen = true;
                          });
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: "Home Inspection Fees"),
                      keyboardType: TextInputType.number,
                      controller:
                          homeInspControll, // added controller to avoid input deletion on toggling
                      onSaved: (value) {
                        entryInfo["homeInsp"] = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            closingCostsOpen = true;
                          });
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: "Property Mgmt Signup"),
                      keyboardType: TextInputType.number,
                      controller:
                          propMgmtSignUpControll, // added controller to avoid input deletion on toggling
                      onSaved: (value) {
                        entryInfo["propMgmtSignUp"] = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            closingCostsOpen = true;
                          });
                          return 'Please enter a value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(labelText: "Bank Fees"),
                      keyboardType: TextInputType.number,
                      controller:
                          bankControll, // added controller to avoid input deletion on toggling
                      onSaved: (value) {
                        entryInfo["bankFees"] = double.parse(value!);
                      },
                    ),
                  ],
                  accordionText: "Closing Costs",
                  notifyParent: refreshClosingCostOpen),
              CustomAccordion(
                screenWidth: _screenWidth,
                accordionOpen: mortgageOpen,
                accordionChildren: [
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        setState(() {
                          mortgageOpen = true;
                        });
                        return 'Please enter a value';
                      }
                      if (double.parse(value) < 0 || double.parse(value) > 50) {
                        // check if number is in desired range (parse will work as non-numerical entry was checked above)
                        setState(() {
                          mortgageOpen = true;
                        });
                        return 'Please enter a number of years between 0 and 50';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: "Term"),
                    keyboardType: TextInputType.number,
                    controller:
                        termControll, // added controller to avoid input deletion on toggling
                    onSaved: (value) {
                      entryInfo["term"] = int.parse(value!);
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        // check sth was entered
                        setState(() {
                          mortgageOpen = true;
                        });
                        return 'Please enter a value';
                      }
                      if (double.tryParse(value) == null) {
                        // check that entry is a number
                        setState(() {
                          mortgageOpen = true;
                        });
                        return 'Please enter a valid number';
                      }
                      if (double.parse(value) < 0 ||
                          double.parse(value) > 100) {
                        setState(() {
                          mortgageOpen = true;
                        });
                        // check if number is in desired range (parse will work as non-numerical entry was checked above)
                        return 'Please enter a number between 0 and 100';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Interest"),
                    keyboardType: TextInputType.number,
                    controller: interestControll,
                    onSaved: (value) {
                      entryInfo["interest"] = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.parse(value) < 0) {
                        setState(() {
                          mortgageOpen = true;
                        });
                        return 'Please enter a value greater than 0';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(labelText: "Offer"),
                    keyboardType: TextInputType.number,
                    controller: offerControll,
                    onSaved: (value) {
                      entryInfo["offer"] = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          double.parse(value) < 0) {
                        setState(() {
                          mortgageOpen = true;
                        });
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
                    controller: downpaymentControll,
                    onSaved: (value) {
                      entryInfo["downpayment"] = double.parse(value!);
                    },
                  ),
                ],
                accordionText: "Mortgage Info",
                notifyParent: refreshMortgageOpen,
              ),
              CustomAccordion(
                screenWidth: _screenWidth,
                accordionOpen: incomeOpen,
                accordionChildren: [
                  SingleChildScrollView(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: rentsList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: GenerateFieldDynamic(
                              index: index,
                              entryInfo: entryInfo,
                              mapKey: "rents",
                              label: "Rent",
                              accordionOpenCallback: () => setState(() {
                                incomeOpen = true;
                              }),
                            ),
                            trailing: index + 1 == rentsList.length
                                ? _addRemoveButton(true, index, rentsList)
                                : _addRemoveButton(false, index, rentsList),
                          );
                        }),
                  )
                ],
                accordionText: "Income",
                notifyParent: refreshIncomeOpen,
              ),
              CustomAccordion(
                screenWidth: _screenWidth,
                accordionOpen: recurringCostOpen,
                accordionChildren: [
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: costsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: GenerateFieldDynamic(
                            index: index,
                            entryInfo: entryInfo,
                            mapKey: "costs",
                            label: "Cost",
                            accordionOpenCallback: () => setState(() {
                              recurringCostOpen = true;
                            }),
                          ),
                          trailing: index + 1 == costsList.length
                              ? _addRemoveButton(true, index, costsList)
                              : _addRemoveButton(false, index, costsList),
                        );
                      }),
                ],
                accordionText: "Recurring Costs",
                notifyParent: refreshCostOpen,
              ),
              CustomAccordion(
                  screenWidth: _screenWidth,
                  accordionOpen: rentAssocExpOpen,
                  accordionChildren: [
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            rentAssocExpOpen = true;
                          });
                          return 'Please enter a value';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 100) {
                          setState(() {
                            rentAssocExpOpen = true;
                          });
                          return 'Percentage value needs to be between 0 and 100';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: "Property Mgmt",
                          helperText: "% from total rental income"),
                      keyboardType: TextInputType.number,
                      controller:
                          propMgmtPercControll, // added controller to avoid input deletion on toggling
                      onSaved: (value) {
                        entryInfo["propMgmtPerc"] = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            rentAssocExpOpen = true;
                          });
                          return 'Please enter a value';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 100) {
                          setState(() {
                            rentAssocExpOpen = true;
                          });
                          return 'Percentage value needs to be between 0 and 100';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: "Vacancy Loss",
                          helperText: "% from total rental income"),
                      keyboardType: TextInputType.number,
                      controller:
                          vacancyLossPercControll, // added controller to avoid input deletion on toggling
                      onSaved: (value) {
                        entryInfo["vacancyLossPerc"] = double.parse(value!);
                      },
                    ),
                    TextFormField(
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          setState(() {
                            rentAssocExpOpen = true;
                          });
                          return 'Please enter a value';
                        }
                        if (double.parse(value) < 0 ||
                            double.parse(value) > 100) {
                          setState(() {
                            rentAssocExpOpen = true;
                          });
                          return 'Percentage value needs to be between 0 and 100';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          labelText: "Capital Expenditure",
                          helperText: "% from total rental income"),
                      keyboardType: TextInputType.number,
                      controller:
                          capitalEpxPercControll, // added controller to avoid input deletion on toggling
                      onSaved: (value) {
                        entryInfo["capitalExpPerc"] = double.parse(value!);
                      },
                    ),
                  ],
                  accordionText: "Rent Assocciated Expenses",
                  notifyParent: refreshRentAssocExpOpen),
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
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushNamed(
                    //     CfResultDetailsScreen.routeName,
                    //     arguments: dbID);
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
