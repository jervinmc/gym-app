import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:googleapis/cloudbuild/v1.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  dynamic args = Get.arguments;

  @override
  State<Details> createState() => _DetailsState(args);
}

class _DetailsState extends State<Details> {
  List args;
  _DetailsState(this.args);
  void paypalCheckout() async {
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");
    var params = {
      "user_id":_id,
      "product_id":args[1],
      "quantity":1
    };
    final response123 = await http.post(
        Uri.parse(Global.url + '/' + 'transaction/'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(params));
    
    print(response123);
    String username =
        "AfhkPCUFnmyofuwN3OSicO7Z83gKoXlDUmba7meh3GewvB6eC1nQ74JrMCSANpYyUudyjEvZBoda-5q-";
    String password =
        "EFmDE0yWqqoyTN6LuLgF7Wn0j2iZGq8gSkSOGzaNlfHKZy2upl2FkbriFlgk55_SGmFSvIVgmVf9cXdk";
    var bytes = utf8.encode("$username:$password");
    var credentials = base64.encode(bytes);
    Map token = {'grant_type': 'client_credentials'};

    var headers = {
      "Accept": "application/json",
      'Accept-Language': 'en_US',
      "Authorization": "Basic $credentials"
    };

    var url = "https://api.sandbox.paypal.com/v1/oauth2/token";
    var requestBody = token;
    http.Response response =
        await http.post(Uri.parse(url), body: requestBody, headers: headers);
    var responseJson = json.decode(response.body);
    print(responseJson['access_token']);
    var params1 = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": "25.00",
            "currency": "USD",
            "details": {"subtotal": "25.00"}
          },
          "description": "This is the payment transaction description.",
          "custom": "EBAY_EMS_90048630024435",
          "invoice_number": "48787582672",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "soft_descriptor": "ECHI5786786",
          "item_list": {
            "items": [
              {
                "name": "handbag",
                "description": "Black color hand bag",
                "quantity": "1",
                "price": "25",
                "sku": "product34",
                "currency": "USD"
              }
            ],
            "shipping_address": {
              "recipient_name": "Hello World",
              "line1": "4thFloor",
              "line2": "unit#34",
              "city": "SAn Jose",
              "country_code": "US",
              "postal_code": "95131",
              "phone": "011862212345678",
              "state": "CA"
            }
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {
        "return_url": "http://3.112.82.82/payments/",
        "cancel_url": "https://example.com"
      }
    };
    url = "https://api-m.sandbox.paypal.com/v1/payments/payment";
    var headers_payment = {
      "Accept": "application/json",
      'Accept-Language': 'en_US',
      "Authorization": "Bearer ${responseJson['access_token']}",
      "Content-Type": "application/json"
    };
    http.Response response_payment = await http.post(Uri.parse(url),
        body: json.encode(params1), headers: headers_payment);
    var responseJson_payment = json.decode(response_payment.body);
    print(responseJson_payment['links'][1]['href']);
    // if (await canLaunch(responseJson_payment['links'][1]['href']))
    //   await launch(responseJson_payment['links'][1]['href']);
    // else
    //   // can't launch url, there is some error
    //   throw "Could not launch $responseJson_payment['links'][1]['href']";

    // launchURL(responseJson_payment['links'][1]['href']);
    if (await canLaunch(responseJson_payment['links'][1]['href'])) {
      await launch(responseJson_payment['links'][1]['href']);
    } else {
      throw 'Could not launch $url';
    }
    return responseJson;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(args[0]),
          backgroundColor: Color(0xff416ce1),
        ),
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
                        image: NetworkImage(args[1]), fit: BoxFit.cover),
                  ),
                  child: Text('')),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    args[0],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  )),
              Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Text(args[2], style: TextStyle(fontSize: 20)),
                    ],
                  )),
              // Container(
              //   padding: EdgeInsets.all(15),
              //   width: 350,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStateProperty.all<Color>(Color(0xff222f3e)),
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(18.0),
              //         ))),
              //     child: Text('Paypal'),
              //     onPressed: () {
              //       paypalCheckout();
              //     },
              //   ),
              // ),
              //  Container(
              //   padding: EdgeInsets.all(15),
              //   width: 350,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //         backgroundColor:
              //             MaterialStateProperty.all<Color>(Color(0xff222f3e)),
              //         shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              //             RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(18.0),
              //         ))),
              //     child: Text('Cancel'),
              //     onPressed: () {
              //       Get.toNamed('/product');
              //     },
              //   ),
              // ),
            ],
          ),
        ));
  }
}
