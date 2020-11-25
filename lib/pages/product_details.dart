import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

// COMPONENTS
import 'package:jemona_deals/models/product.dart';

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
        Uri.encodeFull("http://jemona.dopos.in:3001/api/v2/menu_cards/"+ widget.mc_id.toString() +"/product/"+ widget.p_id.toString() +"?device_id=DOPOS20&email=admin@dopos.in&resources=product_images,unit&image_size=original"),
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
    String price;
    String old_price;
    String discount;

    var p = 0 ;
    var op = 0 ;
    var d = 0 ;
    if(product == null){
      price = p.toString();
      old_price = op.toString();
      discount = d.toString();
    }else{
      price = product.sell_price.toString();
      old_price = product.procured_price.toString();
      if ((product.procured_price - product.sell_price) > 0)
      {
        d = (((product.procured_price - product.sell_price)*100) / product.procured_price).toInt();
        discount = d.toString();
      }
      else{
        discount = 0.toString();
      }
    }

    double full_width = MediaQuery.of(context).size.width;

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
          // new IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: (){}),
          new IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white), onPressed: (){})
        ],
      ),
      body: ListView(
        children: [
          // image_carousel,
          new Container(
            height: 400.0,
            child: GridTile(
              child: Container(
                color: Colors.white,
                child: image_carousel,
              ),
            ),
          ),
          new Container(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: HexColor("#19B6AA"))),
                  onPressed: (){
                    String _mobile = null;
                    String _msg = null;
                    if(product != null){
                      _mobile = product.unit.phone;

                      _msg = "I want to buy product collection *_("+ product.product_sku +") "+ product.product_name +"_*";
                      print(_msg);
                    }
                    _sendToWhatsApp(phone: "91$_mobile", message: _msg.toString());
                    },
                  color: HexColor("#19B6AA"),
                  textColor: Colors.white,
                  child: Text("Buy now".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: HexColor("#A10968"))),
                  onPressed: (){
                    _shareBottomSheet(context);
                  },
                  color: HexColor("#A10968"),
                  textColor: Colors.white,
                  child: Text("Share".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: HexColor("#e3af41"))),
                  onPressed: () {},
                  color: HexColor("#e3af41"),
                  textColor: Colors.white,
                  child: Text("Download".toUpperCase(),
                      style: TextStyle(fontSize: 14)),
                ),
              ],
            )
          ),
          new Container(
            // color: Colors.yellow,
            padding: new EdgeInsets.symmetric(horizontal: 20.0),
            height: 20.0,
            child: GridTile(
              child: Row(
                children: [
                  Text(
                    product!=null ? product.product_sku : " ",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0
                    )
                  ),
                  SizedBox(width: 10),
                  Text(
                    product!=null ? product.product_name : " ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 18.0
                    )
                  ),
                ],
              )
            ),
          ),
          new Container(
            // color: Colors.yellow,
            padding: new EdgeInsets.symmetric(horizontal: 20.0),
            height: 35.0,
            child: GridTile(
                child: Row(
                  children: [
                    Text(
                        "\₹$price",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 26.0
                        )
                    ),
                    SizedBox(width: 10),
                    Text(
                        "\₹$old_price",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20.0,
                            decoration: TextDecoration.lineThrough
                        )
                    ),
                    SizedBox(width: 10),
                    Text(
                        "$discount\% off",
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic
                        )
                    ),

                  ],
                )
            ),
          ),
          new Container (
            padding: const EdgeInsets.all(16.0),
            width: full_width,
            child: new Column (
              children: <Widget>[
                new Text (
                    product!=null ? product.description : " ",
                    textAlign: TextAlign.left
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _shareBottomSheet(context){
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc){
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.share),
                    title: new Text('Share Description'),
                    onTap: () => {}
                ),
                new ListTile(
                  leading: new Icon(Icons.folder_shared),
                  title: new Text('Share Images'),
                  onTap: () => {},
                ),
                new ListTile(
                  leading: new Icon(Icons.copy),
                  title: new Text('Copy Description'),
                  onTap: () => {},
                ),
              ],
            ),
          );
        }
    );
  }

  void _sendToWhatsApp(
      {@required String phone,
        @required String message,
      }) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(message)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(message)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

}
