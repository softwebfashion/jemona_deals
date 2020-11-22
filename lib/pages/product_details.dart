import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

// COMPONENTS
import 'package:jemona_deals/models/product.dart';

import 'package:http/http.dart' as http;

class ProductDetails extends StatefulWidget {
  final mc_id;
  final p_id;

  ProductDetails({
    this.mc_id,
    this.p_id,
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Product product;
  List _images = List<NetworkImage>();

  Future<String> getData() async {
    // print("PRODUCT ID: " + widget.p_id.toString());
    // print("MENU CARD ID: " + widget.mc_id.toString());
    var response = await http.get(
        Uri.encodeFull("http://jemona.dopos.in:3001/api/v2/menu_cards/"+ widget.mc_id.toString() +"/product/"+ widget.p_id.toString() +"?device_id=DOPOS20&email=admin@dopos.in&resources=product_images&image_size=original"),
        headers: {
          "Content-Type": "application/json"
        }
    );

    if (response.statusCode == 200) {
      this.setState(() {
        final jsonResponse = json.decode(response.body);
        product = new Product.fromJson(jsonResponse["data"]);
        if (product.product_images != null) {
          product.product_images.forEach((p_img) {
            _images.add(NetworkImage('http://jemona.dopos.in:3001' + p_img.product_image_url));
          });
        }
      });

      return "Success!";
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState(){
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 400.0,
      child: new Carousel(
        boxFit: BoxFit.contain,
        images: _images.length > 0 ? _images : [ AssetImage("images/loading/loading.gif") ],
        autoplay: false,
        // animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(microseconds: 1000),
        dotSize: 4.0,
        // dotColor: Colors.pink,
        indicatorBgPadding: 2.0,
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.pink,
        title: Text("Product"),
        actions: [
          new IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: (){}),
          new IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white), onPressed: (){})
        ],
      ),
      body: ListView(
        children: [
          image_carousel,
        ],
      ),
    );
  }
}
