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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _search = new TextEditingController();
  final List<String> imgList = [
    'https://www.muscleandfitness.com/wp-content/uploads/2019/11/Young-Muscular-Man-Doing-Lunges-In-Dark-Gym.jpg?quality=86&strip=all',
  ];
  late Channel _channel;
  String _email = '';
  bool _load = false;
  List data = [];
  List data_breakfast = [];
  List data_lunch = [];
  String category_data = "";
  List data_dinner = [];
  List data_recommend = [];
  bool isLoggedin = false;
  late String channel;
  static String BASE_URL = '' + Global.url + '/product/';
  List feature = [];
  Future<String> getData() async {
    _load = true;
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("isLoggedIn") == null ||
        prefs.getBool("isLoggedIn") == false) {
      isLoggedin = false;
    } else {
      isLoggedin = true;
    }
    _email = prefs.getString("_email").toString();
    channel = prefs.getString("_channel").toString();
    print(channel);
    setState(() {});
    var _id = prefs.getInt("_id");
    final response = await http.get(Uri.parse(BASE_URL),
        headers: {"Content-Type": "application/json"});
    String jsonsDataString = response.body.toString();
    final _data = jsonDecode(jsonsDataString);
    data = data;
    print(_data);
    setState(() {
      try {
        data = _data;
        print(data.length);
        print(response);
      } finally {
        _load = false;
      }
    });
    return "";
  }

  @override
  void initState() {
    // // TODO: implement initState
    // super.initState();
    // getData();
    // _initPusher();
    //  tz.initializeTimeZones();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    _email,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xff416ce1),
                ),
              ),
              // ListTile(
              //   trailing: Icon(Icons.settings),
              //   title: const Text('Settings'),
              //   onTap: () {
              //     Get.toNamed('/profile');
              //   },
              // ),
              Divider(),
              ListTile(
                trailing: Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  AwesomeDialog(
                      context: context,
                      dialogType: DialogType.QUESTION,
                      animType: AnimType.BOTTOMSLIDE,
                      title: "Are you sure you want to logout ?",
                      btnOkOnPress: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isLoggedIn', false);
                        Navigator.pop(context);
                        Get.toNamed('/login');
                        // runApp(());
                      },
                      btnCancelOnPress: () {})
                    ..show();
                },
              ),
              Divider(),
              ListTile(
                trailing: Icon(Icons.sell),
                title: const Text('Tools and Products'),
                onTap: () {
                  Get.toNamed('/product');
                },
              ),
              ListTile(
                trailing: Icon(Icons.sell),
                title: const Text('Appointment'),
                onTap: () {
                  Get.toNamed('/appointment');
                },
              ),
              ListTile(
                trailing: Icon(Icons.sell),
                title: const Text('Transaction'),
                onTap: () {
                  Get.toNamed('/transaction');
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Dashboard'),
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
          children:[ Container( padding:EdgeInsets.all(10), child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  child: CarouselSlider(
                options: CarouselOptions(),
                items: imgList
                    .map((item) => Container(
                          child: Center(
                              child: Image.network(item,
                                  fit: BoxFit.cover, width: 1000)),
                        ))
                    .toList(),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.toNamed('/exercise',arguments:['Easy']);
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
                                'https://img.freepik.com/free-photo/strong-man-training-gym_1303-23478.jpg?w=1480&t=st=1667744172~exp=1667744772~hmac=3023901a3f8513185a8af3f93da7f1b1d6433b07e0fd58590d314b56a63be1fe'),
                            fit: BoxFit.cover),
                      ),
                      child:
                          Container(
                            padding:EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text('Easy',style: TextStyle(fontSize:30,color: Colors.white,))
                              ]
                            ),
                          )),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.only(top:10,bottom: 10),
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.toNamed('/exercise',arguments:['Average']);
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
                      child:
                          Container(
                            padding:EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text('Average',style: TextStyle(fontSize:30,color: Colors.white,))
                              ]
                            ),
                          ))),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top:10,bottom: 10),
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.toNamed('/exercise',arguments:['Hard']);
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
                      child:
                          Container(
                            padding:EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text('Hard',style: TextStyle(fontSize:30,color: Colors.white,))
                              ]
                            ),
                          ))),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top:10,bottom: 10),
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.toNamed('/exercise',arguments:['Extreme']);
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
                      child:
                          Container(
                            padding:EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text('Extreme',style: TextStyle(fontSize:30,color: Colors.white,))
                              ]
                            ),
                          ))),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top:10,bottom: 10),
              ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: (){
                      Get.toNamed('/category',arguments:['Exercises']);
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
                      child:
                          Container(
                            padding:EdgeInsets.all(15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:[
                                Text('Exercises',style: TextStyle(fontSize:30,color: Colors.white,))
                              ]
                            ),
                          ))),
                ],
              ),
            ],
          ))],
        ));
  }

  Future<void> _initPusher() async {
    try {
      Pusher.init('33efacb6a0d9c7baad00', PusherOptions(cluster: 'ap1'));
      print('okay');
    } catch (e) {
      print(e);
    }
    Pusher.connect(onConnectionStateChange: (val) {
      print(val.currentState);
    }, onError: (error) {
      print(error);
    });
    _channel = await Pusher.subscribe('notif');
    _channel.bind('my-test', (onEvent) {
      var data = jsonDecode(onEvent.data);
      print(data['message']);
      NotificationService()
          .showNotification(1, "New Notification", data['message'], 1);
    });
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
      required this.name,
      required this.picture,
      required this.price})
      : super(key: key);
  final name;
  final picture;
  final price;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Hero(
        tag: name,
        child: Material(
          child: InkWell(
            child: GridTile(
              child: Image.network(
                picture,
                fit: BoxFit.cover,
              ),
              footer: Container(
                height: 80,
                color: Colors.white,
                child: ListTile(
                  title: Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // leading: Text(name,style: TextStyle(fontWeight: FontWeight.bold),),
                  subtitle: Text("Php $price"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationService {
  void selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    // await Navigator.push(
    //   context,
    //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    // );
  }

  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  Future<void> initNotification() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      print("okayyyy");
      Get.toNamed('/transaction');
    });
  }

  Future<void> showNotification(
      int id, String title, String body, int seconds) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      const NotificationDetails(
        android: AndroidNotificationDetails('main_channel', 'Main Channel',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@drawable/ic_launcher'),
        iOS: IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
