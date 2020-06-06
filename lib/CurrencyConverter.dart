import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  final fromController = TextEditingController();
  List<String> currencies;
  //var currencies = List<String>();
  String fromCurrency = 'USD';
  String toCurrency = 'GBP';
  String result;
  String a;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<String> loadData() async {
    String uri = "http://api.openrates.io/latest";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);
    Map curMaps = responseBody['rates'];
    currencies = curMaps.keys.toList();
    setState(() {});
    //  print(fromController.text.toString());
    return "Success";
  }

  Future<int> doConversion() async {
    String uri = "http://api.openrates.io/latest?base=$fromCurrency";
    var response = await http
        .get(Uri.encodeFull(uri), headers: {"Accept": "application/json"});
    var responseBody = json.decode(response.body);

    setState(() {
      (fromController.text != '')
          ? result = (((double.parse(fromController.text) *
                          responseBody['rates'][toCurrency] *
                          100)
                      .round()) /
                  100)
              .toString()
          : Toast.show("Enter Input", context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    });
    return (1);
  }

  onChangedFrom(String value) {
    setState(() {
      fromCurrency = value;
    });
  }

  onChangedTo(String value) {
    setState(() {
      toCurrency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: Text('Currency Converter'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: currencies == null
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Colors.blueGrey,
            ))
          : Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                margin: EdgeInsets.all(10),
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      ListTile(
                        title: TextField(
                          controller: fromController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            labelText: 'Input',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        trailing: buildDropDown(fromCurrency),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 75),
                        child: IconButton(
                          icon: Icon(Icons.arrow_downward),
                          onPressed: doConversion,
                        ),
                      ),
                      ListTile(
                        title: Chip(
                          label: result != null
                              ? Text(result,
                                  style: TextStyle(color: Colors.white))
                              : Text(
                                  '......',
                                  style: TextStyle(color: Colors.white),
                                ),
                          backgroundColor: Colors.blueGrey[500],
                        ),
                        trailing: buildDropDown(toCurrency),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildDropDown(String currencyCategory) {
    return DropdownButton(
      dropdownColor: Colors.grey[100],
      value: currencyCategory,
      elevation: 10,
      items: currencies
          .map((String value) => DropdownMenuItem(
                value: value,
                child: Row(
                  children: <Widget>[Text(value)],
                ),
              ))
          .toList(),
      onChanged: (String value) {
        if (currencyCategory == fromCurrency) {
          onChangedFrom(value);
        } else {
          onChangedTo(value);
        }
      },
    );
  }
}
