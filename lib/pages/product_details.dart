import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ProductDetails extends StatefulWidget {
  final id;
  final name;
  final images = [];
  final price;
  final old_price;
  final description;

  ProductDetails({
    this.id,
    this.name,
    this.price,
    this.old_price,
    this.description
  });

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 400.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/products/blazer1.jpeg'),
          // AssetImage('images/m1.jpeg'),
          // AssetImage('images/w3.jpeg'),
          // AssetImage('images/w4.jpeg'),
          // AssetImage('images/m2.jpg'),
        ],
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
