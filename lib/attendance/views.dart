import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/global.dart';

class TimeDisplayComponent extends StatefulWidget {
  @override
  _TimeDisplayComponentState createState() => _TimeDisplayComponentState();
}

class _TimeDisplayComponentState extends State<TimeDisplayComponent> {
  String currentTime = '';
  static String BASE_URL = '' + Global.url + '/attendance/';
  void updateCurrentTime() async {
    setState(() {
      currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
    });
    
    final prefs = await SharedPreferences.getInstance();
    var _fullname = prefs.getString('_fullname');
    var _id = prefs.getInt("_id");
    var params = {"fullname": _fullname};
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Attendance'),),
      body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Current Time:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Text(
          currentTime,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: updateCurrentTime,
          child: Text('Update Time'),
        ),
      ],
    ),
    );
  }
}