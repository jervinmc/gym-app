import 'package:bloodapp/config/global.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:googleapis/versionhistory/v1.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class qrCodeScanner extends StatefulWidget {
  const qrCodeScanner({ Key? key }) : super(key: key);
 
  @override
  State<qrCodeScanner> createState() => _qrCodeScannerState();
}

class _qrCodeScannerState extends State<qrCodeScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
   static String BASE_URL = '' + Global.url + '/users/';
   static String BASE_URL_DONATE = '' + Global.url + '/donation/';
   
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();

      controller!.pauseCamera();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Container(
                    padding:EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Column(
                              children:[
                                Text('Email:'),
                                Text('${_data['email']}')
                              ]
                            ),
                            Column(
                              children:[
                                Text('Blood Type:'),
                                Text('${_data['blood_type']}')
                              ]
                            )
                          ],
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
                            child: Text('Accept'),
                            onPressed: () {
                              accept();
                              // Get.toNamed('/home');
                            // Login();
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 5),
                          width: 250,
                          child: ElevatedButton(
                              child: Text('Cancel',style: TextStyle(color: Colors.black),),
                            onPressed: () {
                              Get.toNamed('/home');
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
                  )
                  : Text('Scan a code'),
            ),
          )
        ],
      ),
    );
  }

 void accept()async{
    final prefs = await SharedPreferences.getInstance();
   var params = {
        "hospital_name":prefs.getString('fullname'),
        "location":prefs.getString('permanent_address'),
        "donor_id":_data['id'],
        "blood_type":_data['blood_type'],
      };
      setState(() {
  
      });
      final response = await http.post(Uri.parse(BASE_URL_DONATE),headers: {"Content-Type": "application/json"},body:json.encode(params));
      String jsonsDataString = response.body.toString();
      Get.toNamed('/homeInstitution');
 }
 var _data = {};
  bool isDetected = false;
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(()async {
        result = scanData;
         final response = await http.get(
        Uri.parse(BASE_URL+'${result!.code}/'),
        headers: {"Content-Type": "application/json"});
        String jsonsDataString = response.body.toString();
     final  data = jsonDecode(jsonsDataString);
      _data = data;
      setState(() {
        
      });
        isDetected = false;
        controller.dispose();
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  
  }
}