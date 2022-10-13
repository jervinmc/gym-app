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
  static String BASE_URL = '' + Global.url + '/login/';
  bool _load = false;
  bool isReveal = true;
  void pageValidation() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getBool("isLoggedIn"));

    if (prefs.getBool("isLoggedIn")!) {
      Navigator.pop(context);
      Get.toNamed('/home');
    }
    return;
  }

  @override
  void initState() {
    super.initState();
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

  void Login() async {
    final prefs = await SharedPreferences.getInstance();
    var params = {"email": _email.text, "password": _password.text};
    setState(() {
      _load = true;
    });
    final response = await http.post(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    String jsonsDataString = response.body.toString();
    if (response.statusCode == 404) {
      notify(DialogType.ERROR, 'Wrong Credentials', "Please try again.");
      setState(() {
        _load = false;
      });
      return;
    }
    final _data = jsonDecode(jsonsDataString);
    if (_data != 'no_data') {
      if (_data[0]['status'] != 'Activated') {
        notify(DialogType.ERROR, 'Not yet activate',
            "Please check your email to verify this account.");
        setState(() {
          _load = false;
        });
        return;
      }
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: "Reminders:",
        desc: "All transact will automatically disable in 5pm",
        btnOkOnPress: () async {
          print(_data);
          prefs.setString("_channel", _data[0]['channel']);
          prefs.setInt("_id", _data[0]['id']);
          prefs.setString("_email", _data[0]['email']);
          prefs.setString("_firstname", _data[0]['firstname']);
          prefs.setString("_lastname", _data[0]['lastname']);
          prefs.setString("_number", _data[0]['number']);
          prefs.setString("_age", _data[0]['age']);
          prefs.setString("_barangay", _data[0]['barangay']);
          prefs.setString("_province", _data[0]['province']);
          prefs.setString("_city", _data[0]['city']);
          prefs.setString("_image", _data[0]['image']);
          prefs.setBool("isLoggedIn", true);
          setState(() {
            _load = false;
          });

          Navigator.pop(context);

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Home();
          }));
        },
      )..show();
    } else {
      notify(DialogType.ERROR, 'Wrong Credentials', "Please try again.");
      setState(() {
        _load = false;
      });
    }
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
                        CircleAvatar(
                          radius: 30.0,
                          backgroundImage: NetworkImage(
                              "https://images.unsplash.com/photo-1544502062-f82887f03d1c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8bWFuJTIwc2lsaG91ZXR0ZXxlbnwwfHwwfHw%3D&w=1000&q=80"),
                          backgroundColor: Colors.transparent,
                        ),
                        Text('Russel Mercada'),
                        Text('rampermervago@gmail.com'),
                          Padding(padding: EdgeInsets.only(top:30)),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children:[
                     
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text('Fullname'),
                              Text('Juan Delacruz'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Date of Birth'),
                              Text('30/06/1951'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Race'),
                              Text('shd'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Nationality'),
                              Text('Filipino'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Mobile Number'),
                              Text('0929304234232'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Occupation'),
                              Text('Worker'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Address'),
                              Text('kskkallae'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('District'),
                              Text('None'),
                              Padding(padding: EdgeInsets.only(top:10)),
                            ],
                          ),
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Text('Gender'),
                              Text('Male'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Blood Type'),
                              Text('09293423423'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Marital Status'),
                              Text('Single'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('IC Color'),
                              Text('Yellow'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Passport'),
                              Text('08297381'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Office Number'),
                              Text('092932423242'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               Text('Total Donations'),
                              Text('0'),
                              Padding(padding: EdgeInsets.only(top:10)),
                               
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
