import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

DateTime get _now => DateTime.now();

class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  static String BASE_URL = '' + Global.url + '/book/';
  static String CHECK_SLOT = '' + Global.url + '/check-book/';
  var slot = 0;
  String _selectedDate = '';

  appointment() async {
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {"appointment_date": _selectedDate, "user_id": _id};
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
  }

  void checkDate(val) async {
    var params = {"date": val};
    final response = await http.post(Uri.parse(CHECK_SLOT),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));

        String jsonsDataString = response.body.toString();
        final _data = jsonDecode(jsonsDataString);
        print(_data);
        int a = int.parse(_data.toString());
        slot = 50 -  a;

        setState(() {
          
        });
        

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Appointment'),
      ),
      body: Column(children: [
        Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [],
            )),
        DateTimePicker(
          type: DateTimePickerType.dateTimeSeparate,
          dateMask: 'd MMM, yyyy',
          initialValue: DateTime.now().toString(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          icon: Icon(Icons.event),
          dateLabelText: 'Date',
          timeLabelText: "Hour",
          onChanged: (val) {
            checkDate(val);
            print(val);
            _selectedDate = val;  
          },
          validator: (val) {
            print(val);
            return null;
          },
          onSaved: (val) => print(val),
        ),
        Container(
          padding: EdgeInsets.all(15),
          width: 350,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Color(0xff222f3e)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
            child: Text('Set appointment'),
            onPressed: () {
              // paypalCheckout();
              appointment();

              AwesomeDialog(
                context: context,
                dialogType: DialogType.SUCCES,
                animType: AnimType.BOTTOMSLIDE,
                title: "Successfull Added !",
                desc: "",
                btnOkOnPress: () {
                  Get.toNamed('/home');
                },
              )..show();
            },
          ),
        ),
        Text("Slots: ${slot}"),
        Text("Membership fee: Php 300.00")
      ]),
    );
  }
}
