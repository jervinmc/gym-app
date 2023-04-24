import 'package:bloodapp/config/global.dart';
import 'package:bloodapp/home/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static String BASE_URL = '' + Global.url + '/get-user/';
  bool _load = false;
  bool isReveal = true;
  var fullname = '';
  var mobile_number = '';
  var gender = '';
  var birthdate = '';
  var email = '';
  void pageValidation() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("isLoggedIn"));

    if (prefs.getBool("isLoggedIn")!) {
      Navigator.pop(context);
      Get.toNamed('/home');
    }
    return;
  }
  Future<String> getData() async {
      final prefs = await SharedPreferences.getInstance();

    setState(() {
      _load = true;
    });
    fullname = prefs.getString('_fullname')!;
    mobile_number = prefs.getString('_mobile_number')!;
    gender = prefs.getString('_gender')!;
    birthdate = prefs.getString('_birthdate')!;
    email = prefs.getString('_email')!;
    return "";
  }

  @override
  void initState() {
    super.initState();
    getData();
    // print('okay');

    // pageValidation();
  }

  void notify(DialogType type, title, desc) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      btnOkOnPress: () {},
    )..show();
  }

  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Color(0xff416ce1),
        ),
        body: ListView(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
               
                width: 400,
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  margin: EdgeInsets.all(20.0),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: <Widget>[
                        // CircleAvatar(
                        //   radius: 30.0,
                        //   backgroundImage: NetworkImage(
                        //       "https://images.unsplash.com/photo-1544502062-f82887f03d1c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc2lsaG91ZXR0ZXxlbnwwfHwwfHw%3D&w=1000&q=80"),
                        //   backgroundColor: Colors.transparent,
                        // ),
                        Text('${fullname}'),
                        Text('${email}'),
                          Padding(padding: EdgeInsets.only(top:30)),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children:[
                     
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text('Fullname'),
                              Text('${fullname}'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Date of Birth'),
                              Text('${birthdate}'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Mobile Number'),
                              Text('${mobile_number}'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Gender'),
                              Text('${gender}'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                             

                               
                            ],
                          )
                        ]
                      )

                      ],
                    ),
                  ),
                ),
              )
            ],
          )
        ]));
  }
}
