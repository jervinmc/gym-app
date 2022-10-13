import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';


class DonationList extends StatefulWidget {
  const DonationList({Key? key}) : super(key: key);
  @override
  _DonationListState createState() => _DonationListState();
}


class _DonationListState extends State<DonationList> {
  void addToDonationList() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {
     "data":data
    };
    final response = await http.post(Uri.parse(Global.url+'/'+'donation/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));

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
  }
   void notify(DialogType type , title, desc){
      AwesomeDialog(
                context: context,
                dialogType:type,
                animType: AnimType.BOTTOMSLIDE,
                title: title,
                desc: desc,
                btnOkOnPress: () {
                  addToDonationList();
                },
                btnCancelOnPress:(){

                }
                )..show();
    }

 static String BASE_URL = '' + Global.url + '/donation';
  List data = [];
  bool _load = false;
  Future<String> getData() async {
    setState(() {
      _load = true;
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    final response = await http.get(Uri.parse(BASE_URL + '/?search=${prefs.getString('fullname')}' ),
        headers: {"Content-Type": "application/json"});
    data = json.decode(response.body);
          _load = false;
          setState(() {
            
          });
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children:[
            Text('DonationList'),
            // Text('Total: ')
          ]
        ),
        backgroundColor: Color(0xffef5777),
      ),
      body:  _load
                ? Container(
                    color: Colors.white10,
                    width: 70.0,
                    height: 70.0,
                    child: Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        new Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: new Center(
                            child: const CircularProgressIndicator()))
                      ],
                    ),
                  )
                : Container(
        child: new ListView.separated(
              itemCount: data == null ? 0 : data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  child: new ListTile(
                  onTap: (){
                        // Get.toNamed('/item_status',arguments:["${data[index]['image']}","${data[index]['id']}","${data[index]['product_name']}","${data[index]['price']}","${data[index]['quantity']}","${data[index]['status']}"]);
                        },
                  title: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                 
                    // Text("Hostpital Name: ${data[index]['hospital_name']}"),
                    Text("Blood Type: ${data[index]['blood_type']}")
                  ],),
                  // trailing: Column(
                  //   children: [
                  //     Text("Quantity: ${data[index]['quantity']}"),
                  //     Text("Subtotal: Php ${data[index]['subtotal']} ")
                  //   ],
                  // ),
                ),
                );
              },separatorBuilder: (context, index) {
                  return Divider();
                },
            ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     var total = 0.0;
      //     for(int x=0;x<data.length;x++){
      //       total = total + double.parse(data[x]['price']);
      //     }
      //        notify(DialogType.INFO, 'Are you sure you want all to check this out?', "Total:${total}");
      //     // Add your onPressed code here!
      //   },
      //   backgroundColor: Color(0xff222f3e),
      //   child: const Icon(Icons.payment),
      // ),
    );
  } 

}









