import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class RegisterInstitution extends StatefulWidget {
  @override
  _RegisterInstitutionState createState() => _RegisterInstitutionState();
}

class _RegisterInstitutionState extends State<RegisterInstitution> {
  bool isReveal = true;
  String? gender;
  
   String user_type = 'Finder';
  String bloodtype = 'A+';
  final items = ['A+','A-','O+','O-','B+','B-','AB+','AB-','Unknown'];
  final _userList = ['Finder','Donor'];
  late io.File selectedImage;
  String url = '';
  void runFilePiker() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);
    print("not okay");

    if (pickedFile != null) {
      selectedImage = io.File(pickedFile.path);
      url = pickedFile.path;
      print("okay");
      setState(() {
        print(url);
      });
    }
  }

  static String BASE_URL = '' + Global.url + '/users/';
  bool _load = false;
  void notify(DialogType type, title, desc) {
    AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.BOTTOMSLIDE,
      title: title,
      desc: desc,
      btnOkOnPress: () {
        if (DialogType.ERROR == type) {
        } else {}
      },
    )..show();
  }

  void SignUp() async {
    if (_email.text == null ||
        _password.text == null ||
        _email.text == '' ||
        _password.text == '') {
      notify(
          DialogType.ERROR, 'Field is required.', 'Please fill up the form.');

      return;
    }
    if (_password.text.length < 9) {
      notify(DialogType.ERROR, 'Password must be at least 8 characters.', '');
      return;
    }
    if (_repassword.text != _password.text) {
      notify(DialogType.ERROR, 'Password does not match', '');
      return;
    }
    setState(() {
      _load = true;
    });
    var params = {
      "fullname": _fullname.text,
      "user_type": 'Institution',
      "gender": gender,
      "birthdate": _birthdate.text,
      "blood_type": bloodtype,
      "marital_status": _marital_status.text,
      "mobile_number": _mobile_number.text,
      "permanent_address": _permanent_address.text,
      "email": _email.text,
      "password": _password.text,
    };
    // final request = http.MultipartRequest("POST", Uri.parse(BASE_URL));
    // final headers = {"Content-type": "multipart/form-data"};
    // request.fields['firstname'] = _firstname.text;
    // request.fields['lastname'] = _lastname.text;
    // request.fields['email'] = _email.text;
    // request.fields['password'] = _password.text;
    // request.fields['barangay'] = _barangay.text;
    // request.fields['city'] = _city.text;
    // request.fields['province'] = _province.text;
    // request.fields['number'] = _number.text;
    // request.fields['status'] = "Deactivated";
    // request.fields['account_type'] = "Client";
    // request.fields['age'] = _age.text;

    // request.files.add(http.MultipartFile('image',
    //     selectedImage.readAsBytes().asStream(), selectedImage.lengthSync(),
    //     filename: selectedImage.path.split("/").last));
    // request.headers.addAll(headers);
    // final response = await request.send();
    // http.Response res = await http.Response.fromStream(response);
    // setState(() {
    //   _load = true;
    // });
    final response = await http.post(Uri.parse(BASE_URL),headers: {"Content-Type": "application/json"},body:json.encode(params));
    if (response.statusCode == 201) {
      setState(() {
        _load = false;
      });
      notify(DialogType.SUCCES, 'Successfully Created',
          'You may now enjoy your account.');
      _email.text = "";
      _password.text = "";
      Get.toNamed('/login');
    } else {
      notify(DialogType.ERROR, 'Account is already exists.',
          "Please use other account.");
      setState(() {
        _load = false;
      });
    }
  }

  TextEditingController _email = new TextEditingController();
  TextEditingController _fullname = new TextEditingController();
  TextEditingController _birthdate = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _marital_status = new TextEditingController();
  TextEditingController _mobile_number = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _province = new TextEditingController();
  TextEditingController _number = new TextEditingController();
  TextEditingController _repassword = new TextEditingController();
 TextEditingController _permanent_address = new TextEditingController();
 TextEditingController _address = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Signup'),
          backgroundColor: Color(0xffef5777),
        ),
        body: Stack(
          children: [
            ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white70, width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      margin: EdgeInsets.all(20.0),
                      child: Container(
                        width: 400,
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: <Widget>[
                            Text('Hospital Details',
                                style: TextStyle(fontSize: 20.0)),
                                Padding(padding: EdgeInsets.only(bottom: 10)),
                           
                          
                            Row(
                              children: [
                                Column(children: [Text('Hostpital Name')]),
                                Text('*', style: TextStyle(color: Colors.red))
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: _fullname,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff222f3e), width: 5.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Hospital Name",
                                    fillColor: Colors.white70),
                              ),
                            ),
                         
                             Padding(padding: EdgeInsets.only(bottom: 10)),
                             Row(
                              children: [
                                Column(children: [Text('Mobile Number')]),
                                Text('*', style: TextStyle(color: Colors.red))
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: _mobile_number,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff222f3e), width: 5.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Mobile Number",
                                    fillColor: Colors.white70),
                              ),
                            ),
                             Padding(padding: EdgeInsets.only(bottom: 10)),
                             Row(
                              children: [
                                Column(children: [Text('Hospital Location')]),
                                Text('*', style: TextStyle(color: Colors.red))
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: _permanent_address,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff222f3e), width: 5.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Hospital Location",
                                    fillColor: Colors.white70),
                              ),
                            ),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                             Row(
                              children: [
                                Column(children: [Text('Email')]),
                                Text('*', style: TextStyle(color: Colors.red))
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                controller: _email,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff222f3e), width: 5.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Email",
                                    fillColor: Colors.white70),
                              ),
                            ),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                             Row(
                              children: [
                                Column(children: [Text('Password')]),
                                Text('*', style: TextStyle(color: Colors.red))
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                obscureText: true,
                                controller: _password,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff222f3e), width: 5.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Password",
                                    fillColor: Colors.white70),
                              ),
                            ),
                              Padding(padding: EdgeInsets.only(bottom: 10)),
                             Row(
                              children: [
                                Column(children: [Text('Confirm Password')]),
                                Text('*', style: TextStyle(color: Colors.red))
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 10),
                              child: TextField(
                                 obscureText: true,
                                controller: _repassword,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.all(8.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 1.5),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff222f3e), width: 5.0),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    hintStyle:
                                        TextStyle(color: Colors.grey[800]),
                                    hintText: "Confirm Password",
                                    fillColor: Colors.white70),
                              ),
                            ),
                             Container(
                          padding: EdgeInsets.only(top: 15),
                          width: 250,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xffef5777)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ))),
                            child: Text('Register'),
                            onPressed: () {
                              // Get.toNamed('/home');
                                SignUp();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          width: 250,
                          child: ElevatedButton(
                              child: Text('Cancel',style: TextStyle(color: Colors.black),),
                            onPressed: () {
                              Get.toNamed('/login');
                            },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                        ),
                              primary: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                              textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                            
                              
                          ),       
                          ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value:item,
    child: Container(padding:EdgeInsets.all(10),child:Text(item,style:TextStyle(fontSize: 15)))
  );
  