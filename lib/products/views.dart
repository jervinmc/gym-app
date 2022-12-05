import 'dart:convert';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:bloodapp/config/global.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:url_launcher/url_launcher.dart';

class Product extends StatefulWidget {
  const Product({ Key? key }) : super(key: key);

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {

 static String BASE_URL = '' + Global.url + '/product';
  List data = [];

  Future<String> getData() async {
    setState(() {
   
    });
    final prefs = await SharedPreferences.getInstance();
    var _id = prefs.getInt("_id");

    final response = await http.get(
        Uri.parse(BASE_URL + '/'),
        headers: {"Content-Type": "application/json"});
    data = json.decode(response.body);
    setState(() {
    });
    setState(() {});
    return "";
  }
  void initState(){
    super.initState();
    getData();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Products')
      ),
      body: Container(
            child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.all(10),
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: ()async{
                  Get.toNamed('/details',arguments:["${data[index]['image']}","${data[index]['_id']}","${data[index]['price']}","${data[index]['price']}","${data[index]['stocks']}","${data[index]['description']}","${data[index]['product_name']}"]);
              },
              child: ProductCard(
                  name: data[index]['product_name'].toString(),
                  picture: data[index]['image'],
                  price: data[index]['price'].toString()),
            );
          }),
          ),
    );
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