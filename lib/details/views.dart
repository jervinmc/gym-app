import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class Details extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  State<Details> createState() => _DetailsState(args);
}

class _DetailsState extends State<Details> {
  List args;
  _DetailsState(this.args);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text(args[0]),
      backgroundColor: Color(0xff416ce1),),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
            children: [
              Container(
                     height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            image: NetworkImage(
                               args[1]),
                            fit: BoxFit.cover),
                      ),
                      child:Text('') ),

                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child:Text(args[0],style: TextStyle(fontWeight: FontWeight.bold,fontSize:30),)
                      ),
                       Container(
                        padding: EdgeInsets.only(top: 10),
                        child:Column(
                          children: [
                            Text(args[2],style: TextStyle(fontSize:20)),
                          ],
                        )
                      ),

             
            ],
        ),
      )
    );
  }
  
}