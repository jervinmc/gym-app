import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class OnlineExercise extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  State<OnlineExercise> createState() => _OnlineExerciseState(args);
}

class _OnlineExerciseState extends State<OnlineExercise> {
  List args;
  _OnlineExerciseState(this.args);
  bool _load = false;
  List data = [];
  final List<Map<String, dynamic>> items = [
    {
      'title':'1. Lunges',
      'description': 'To perform lunges, start by standing with your feet hip-width apart and take a step forward with your right foot. Lower your left knee to the ground, keeping your right knee at a 90-degree angle and your right thigh parallel to the ground. Push through your right heel to return to the starting position, and repeat with your left foot. Keep your knees aligned with your ankles, your core engaged, and your back straight throughout the exercise. Perform 10 to 12 repetitions on each side, and consult with your healthcare provider before starting any new exercise program.',
      'image': 'assets/easy/lunges.gif',
    },
    {
      'title':'2. Pushup',
      'description': 'To perform a pushup, start in a plank position with your hands shoulder-width apart, fingers facing forward, and your feet together. Lower your body toward the ground by bending your elbows, keeping your core engaged and your back straight. Lower your chest until it almost touches the ground, and then push back up until your arms are fully extended. Keep your elbows close to your body throughout the exercise, and avoid letting them flare out to the sides. Repeat for 10 to 12 repetitions, or as many as you can do with good form. To modify the exercise, you can perform pushups on your knees or against a wall. Always consult with your healthcare provider before starting any new exercise program.',
      'image': 'assets/easy/pushup.gif',
    },
    {
      'title':'3. Dumbbell Reverse Fly',
      'description': ' The Dumbbell Reverse Fly is an effective exercise for targeting the muscles in your upper back and shoulders. Its a great way to improve your posture, increase your shoulder mobility, and strengthen your upper body.',
      'image': 'assets/easy/dumbell-fly.gif',
    },
    {
      'title':'4. Squat',
      'description': 'To perform a squat, stand with your feet hip-width apart and your toes pointing forward or slightly outward. Lower your body by bending your knees and pushing your hips back, keeping your back straight and your core engaged. Lower your body until your thighs are parallel to the ground, and then push through your heels to stand back up to the starting position. Keep your knees aligned with your toes and avoid letting them collapse inward. You can perform squats with bodyweight or with added weight like a barbell or dumbbells. Repeat for 10 to 12 repetitions, or as many as you can do with good form. Always consult with your healthcare provider before starting any new exercise program.',
      'image': 'assets/easy/squat.gif',
    },
    {
      'title':'4. Dumbbell Bicep Curl',
      'description': 'The Dumbbell Bicep Curl is a classic exercise that targets the biceps, one of the primary muscles in your upper arm. Its a great way to build arm strength, increase muscle tone, and improve your overall fitness level.',
      'image': 'assets/easy/dumbell-1.gif',
    },
    // {
    //   'description': 'Item 4 description',
    //   'image': 'https://via.placeholder.com/150',
    // },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(args[0]),
          backgroundColor: Color(0xff416ce1),
        ),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      items[index]['title'],
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      items[index]['description'],
                      style: TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Image.asset(
                      items[index]['image'],
                      height: 150.0,
                      width: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }));
  }
}
