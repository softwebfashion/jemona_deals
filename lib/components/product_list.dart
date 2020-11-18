import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jemona_deals/pages/product_details.dart';

import 'package:http/http.dart' as http;

class ProductList extends StatefulWidget {
  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  static int page = 0;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List prods = new List();

  Future<String> _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var response = await http.get(
          Uri.encodeFull( "http://jemona.dopos.in:3001/api/v2/menu_cards/section_active_menu_card?device_id=DOPOS20&email=admin@dopos.in&page=" +
              index.toString() +
              "&count=10&resources=products&section_name=jemona_app"),
          headers: {
            "Content-Type": "application/json"
          }
      );
      List tList = new List();
      if (response.statusCode == 200) {
        this.setState(() {
          final jsonResponse = json.decode(response.body);
          // rd = new ResultData.fromJson(jsonResponse);
          for (int i = 0; i < jsonResponse['data']['products'].length; i++) {
            tList.add(jsonResponse['data']['products'][i]);
          }
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }

      setState(() {
        isLoading = false;
        prods.addAll(tList);
        page++;
      });
    }
  }

  @override
  void initState() {
    this._getMoreData(page);
    super.initState();
    _sc.addListener(() {
      if (_sc.position.pixels ==
          _sc.position.maxScrollExtent) {
        _getMoreData(page);
      }
    });
  }

  @override
  void dispose() {
    _sc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lazy Load Large List"),
      ),
      body: Container(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: prods.length + 1, // Add one more item for progress indicator
      padding: EdgeInsets.symmetric(vertical: 8.0),
      itemBuilder: (BuildContext context, int index) {

        if (index == prods.length) {
          return _buildProgressIndicator();
        } else {
          String price = prods[index]['sell_price'].toString();
          return new ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: NetworkImage(
                'http://jemona.dopos.in:3001' + prods[index]['product_image_url'],
              ),
            ),
            title: Text((prods[index]['product_name'])),
            subtitle: Text("\₹$price"),
          );
        }
      },
      controller: _sc,
    );
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(valueColor:new AlwaysStoppedAnimation<Color>(Colors.pink)),
        ),
      ),
    );
  }
}

class ResultData{
  final String status;
  final Messages message;
  final MenuCard mc;

  ResultData({
    this.status,
    this.message,
    this.mc
  });

  factory ResultData.fromJson(Map<String, dynamic> parsedJson){
    return ResultData(
        status:parsedJson['status'],
        message:parsedJson['message'],
        mc: parsedJson["data"] == null ? null : MenuCard.fromJson(parsedJson["data"])
    );
  }

}

class Messages{
  final String simple_message;
  final String internal_message;

  Messages({
    this.simple_message,
    this.internal_message
  });

  factory Messages.fromJson(Map<String, dynamic> parsedJson){
    return Messages(
        simple_message:parsedJson['simple_message'],
        internal_message:parsedJson['internal_message']
    );
  }

}

class MenuCard{
  final int id;
  final int mode;
  final int section_id;
  final int unit_id;
  final String name;
  final List<Product> products;

  MenuCard({
    this.id,
    this.mode,
    this.section_id,
    this.unit_id,
    this.name,
    this.products
  });

  factory MenuCard.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['categories'] as List;
    List<Product> dataList = list.map((i) => Product.fromJson(i)).toList();


    return MenuCard(
        id: parsedJson['id'],
        mode: parsedJson['mode'],
        section_id: parsedJson['section_id'],
        unit_id: parsedJson['unit_id'],
        name: parsedJson['name'],
        products: dataList
    );
  }
}

class Product {

  final id;
  final name;
  final picture;
  final old_price;
  final price;

  Product({
    this.id,
    this.name,
    this.picture,
    this.old_price,
    this.price
  });

  factory Product.fromJson(Map<String, dynamic> parsedJson){
    return Product(
        id:parsedJson['id'],
        name:parsedJson['name'],
        picture:parsedJson['picture'],
        old_price:parsedJson['old_price'],
        price:parsedJson['price'],
    );
  }
}