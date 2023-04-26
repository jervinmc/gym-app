import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_calendar/calendar.dart';

DateTime get _now => DateTime.now();
class Appointment extends StatefulWidget {
  const Appointment({Key? key}) : super(key: key);

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  static String BASE_URL = '' + Global.url + '/book/';
  String _selectedDate = '';

  appointment() async {
    var params = {"appointment_date": _selectedDate, "user_id": 1};
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
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
          onChanged: (val) => _selectedDate = val,
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
      ]),
    );
  }
}
