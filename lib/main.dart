
import 'package:bloodapp/appointment/views.dart';
import 'package:bloodapp/details/views.dart';
import 'package:bloodapp/donation_list/views.dart';
import 'package:bloodapp/exercises/views.dart';
import 'package:bloodapp/home/views.dart';
import 'package:bloodapp/homeFinder/views.dart';
import 'package:bloodapp/homeInstitution/views.dart';
import 'package:bloodapp/login/views.dart';
import 'package:bloodapp/maps/views.dart';
import 'package:bloodapp/product_details/views.dart';
import 'package:bloodapp/products/views.dart';
import 'package:bloodapp/profile/views.dart';
import 'package:bloodapp/qrprofile/views.dart';
import 'package:bloodapp/qrscanner/views.dart';
import 'package:bloodapp/register/views.dart';
import 'package:bloodapp/register_institution/views.dart';
import 'package:bloodapp/searchDonor/views.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter',
      theme: ThemeData(
      ),
      getPages: [
        GetPage(name: "/login", page:()=>Login()),
        GetPage(name: "/register", page:()=>SignUp()),
        GetPage(name: "/home", page:()=>Home()),
        GetPage(name: "/map", page:()=>MapPage()),
        GetPage(name: "/profile", page:()=>Profile()),
         GetPage(name: "/finder", page:()=>Finder()),
          GetPage(name: "/search", page:()=>Search()),
           GetPage(name: "/registerInstitution", page:()=>RegisterInstitution()),
          GetPage(name: "/qrprofile", page:()=>QRProfile()),
           GetPage(name: "/qrprofile", page:()=>QRProfile()),
            GetPage(name: "/homeInstitution", page:()=>Institution()),
             GetPage(name: "/donationList", page:()=>DonationList()),
           GetPage(name: "/scanner", page:()=>qrCodeScanner()),
            GetPage(name: "/exercise", page:()=>Exercise()),
            GetPage(name: "/details", page:()=>Details()),
              GetPage(name: "/product-details", page:()=>ProductDetails()),
            GetPage(name: "/appointment", page:()=>Appointment()),
           GetPage(name: "/product", page:()=>Product()),
      //   GetPage(name: "/home", page:()=>Home()),
      //   GetPage(name: "/details", page:()=>Details()),
      //   GetPage(name: "/cart", page:()=>Carts()),
      //   GetPage(name: "/chat", page:()=>ChatPage()),
      //   GetPage(name: "/transaction", page:()=>Transaction()),
      //   GetPage(name: "/checkout", page:()=>Checkout()),
      //  GetPage(name: "/item_status", page:()=>ItemStatus()),
      //  GetPage(name: "/notification", page:()=>Notifications()),
      //   GetPage(name: "/profile", page:()=>Profile()),
      //   GetPage(name: "/search", page:()=>Search()),
      //   GetPage(name: "/checkout_cart", page:()=>CheckoutCart()),
      //   GetPage(name: "/about", page:()=>About()),
      //  GetPage(name: "/reset_password", page:()=>ResetPassword()),
      //  GetPage(name: "/most_buy", page:()=>MostBuy()),
      //  GetPage(name: "/wishlist", page:()=>Wishlist()),
      //  GetPage(name: "/most_view", page:()=>MostView()),
        
        // GetPage(name: "/signup", page:()=>SignUp()),
        // GetPage(name: "/profile", page:()=>Profile()),
        // GetPage(name: "/resetPassword", page:()=>ResetPassword()),
        // GetPage(name: "/receiptList", page:()=>receiptList()),
        // GetPage(name: "/receipt", page:()=>receipt()),
        // GetPage(name: "/products", page:()=>Products()),
        // GetPage(name: "/cart", page:()=>Cart()),
        // GetPage(name: "/favorites", page:()=>Favorites()),
        // GetPage(name: "/product_details", page:()=>ProductDetails()),
      ],
      initialRoute: "/login"  ,
    );
  }
}
