import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pusher_websocket_flutter/pusher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Category'),
            Row(children: [
              InkWell(
                onTap: () {
                  Get.toNamed('/profile');
                },
                child: Icon((Icons.account_circle_outlined)),
              ),
              // Icon((Icons.notifications))
            ])
          ]),
          backgroundColor: Color(0xff416ce1),
        ),
        body: ListView(
          children: [
            Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.toNamed('/online-exercise',
                                  arguments: ['fat-loss']);
                            },
                            child: Container(
                                height: 85,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.darken),
                                      image: NetworkImage(
                                          'https://img.freepik.com/free-photo/strong-man-training-gym_1303-23478.jpg?w=1480&t=st=1667744172~exp=1667744772~hmac=3023901a3f8513185a8af3f93da7f1b1d6433b07e0fd58590d314b56a63be1fe'),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Fat Loss',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                            ))
                                      ]),
                                ))),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                            onTap: () {
                              Get.toNamed('/online-exercise',
                                  arguments: ['gain-weight']);
                            },
                            child: Container(
                                height: 85,
                                width: 350,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  image: DecorationImage(
                                      colorFilter: new ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.darken),
                                      image: NetworkImage(
                                          'https://img.freepik.com/free-photo/strong-man-training-gym_1303-23478.jpg?w=1480&t=st=1667744172~exp=1667744772~hmac=3023901a3f8513185a8af3f93da7f1b1d6433b07e0fd58590d314b56a63be1fe'),
                                      fit: BoxFit.cover),
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text('Gain Weight',
                                            style: TextStyle(
                                              fontSize: 30,
                                              color: Colors.white,
                                            ))
                                      ]),
                                ))),
                      ],
                    ),
                  ],
                ))
          ],
        ));
  }
}
