import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/global.dart';

class TransactionPage extends StatefulWidget {
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  // static String BASE_URL = '' + Global.url + '/transaction-user';
  List transactions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    

    var params = {
      "user_id": _id,
    };
    final response123 = await http.post(
        Uri.parse(Global.url + '/' + 'transaction-user/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
        transactions = json.decode(response123.body);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(transactions[index]['product']['product_name']),
          );
        },
      ),
    );
  }
}