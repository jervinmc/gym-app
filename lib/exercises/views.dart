import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';


class Exercise extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  State<Exercise> createState() => _ExerciseState(args);
}

class _ExerciseState extends State<Exercise> {
  List args;
  _ExerciseState(this.args);
  bool _load = false;
  static String BASE_URL = '' + Global.url + '/exercise/';
  List data=[];
  Future<String> getData() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    final response = await http.get(
        Uri.parse(BASE_URL + ''),
        headers: {"Content-Type": "application/json"});
    data = json.decode(response.body);
    var a = [];
    for(int x=0;x<data.length;x++){
      if(data[x]['category']==args[0]){
        a.add(data[x]);
      }
    }
    data = a;
    _load = false;
    setState(() {});
    return "";
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text(args[0]),
      backgroundColor: Color(0xff416ce1),),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext ctx, index){
        return Container(
          padding:EdgeInsets.all(10),
          child:Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.toNamed('/details',arguments:[data[index]['name'],data[index]['image'],data[index]['description']]);
                    },
                    child:Container(
                     height: 85,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.darken),
                            image: NetworkImage(
                                data[index]['image']),
                            fit: BoxFit.cover),
                      ),
                      child:
                          Container(
                            padding:EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text(data[index]['name'],style: TextStyle(fontSize:30,color: Colors.white,))
                              ]
                            ),
                          )),
                  )
                ],
              )
        );
        }
      )
    );

  }
}