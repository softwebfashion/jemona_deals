import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

// COMPONENTS
import 'package:jemona_deals/models/result_data.dart';
import 'package:jemona_deals/models/product.dart';

// PAGES
import 'package:jemona_deals/pages/product_details.dart';

import 'package:http/http.dart' as http;

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  ResultData rd;
  static int page = 0;
  ScrollController _sc = new ScrollController();
  bool isLoading = false;
  List<Product> prods = new List<Product>();

  Future<String> _getMoreData(int index) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });

      var response = await http.get(
          Uri.encodeFull( "http://jemona.dopos.in:3001/api/v2/menu_cards/section_active_menu_card?device_id=DOPOS20&email=admin@dopos.in&page=" +
              index.toString() +
              "&count=10&resources=products&section_name=jemona_app&image_size=medium"),
          headers: {
            "Content-Type": "application/json"
          }
      );
      List tList = new List();
      if (response.statusCode == 200) {
        this.setState(() {
          final jsonResponse = json.decode(response.body);
          rd = new ResultData.fromJson(jsonResponse);
        });
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load album');
      }

      setState(() {
        isLoading = false;
        prods.addAll(rd.mc.products);
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
      body: Card(
        child: _buildList(),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget _buildList() {
    return GridView.builder(
      itemCount: prods.length + 1,
      padding: EdgeInsets.all(4.0),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 4, crossAxisSpacing: 4),
      itemBuilder: (BuildContext context, int index) {
        if (index == prods.length) {
          return _buildProgressIndicator();
        }
        else
        {
          String price = prods[index].price.toString();
          String old_price = prods[index].old_price.toString();
          return new Hero(
            tag: prods[index].name,
            child: Material(
              child: InkWell(
                onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new ProductDetails())),
                child: GridTile(
                  footer: Container(
                    color: Colors.black54,
                    child: new Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 5,
                          child: new Column(
                            children: <Widget>[
                              new  ListTile(
                                leading: Text(prods[index].name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        new Expanded(
                          flex: 5,
                          child: new Column(
                            children: <Widget>[
                              new ListTile(
                                title: Text("\₹$price", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w800)),
                                subtitle: Text(
                                  "\₹$old_price",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.lineThrough
                                  ),
                                )
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  child: Image.network('http://jemona.dopos.in:3001' + prods[index].picture, fit: BoxFit.contain,),
                ),
              ),
            ),
          );
        } // END else
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