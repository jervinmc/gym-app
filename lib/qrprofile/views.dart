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
import 'package:qr_flutter/qr_flutter.dart';

class QRProfile extends StatefulWidget {
  @override
  _QRProfileState createState() => _QRProfileState();
}

class _QRProfileState extends State<QRProfile> {
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
    getData();
  }
  var a = 0;
  void getData()async{
    final prefs = await SharedPreferences.getInstance();
   a = prefs.getInt("_id")!;
   setState(() {
     
   });
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
          title: Text('QRProfile'),
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
                        QrImage(
                          data: "${a}",
                          version: QrVersions.auto,
                          size: 200.0,
                        ),

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
