import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

// COMPONENTS
import 'package:jemona_deals/models/result_data.dart';
import 'package:jemona_deals/models/category.dart';

import 'package:http/http.dart' as http;


class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  ResultData rd;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("http://jemona.dopos.in:3001/api/v2/menu_cards/section_active_menu_card?device_id=DOPOS20&email=admin@dopos.in&resources=categories&section_name=jemona_app"),
        headers: {
          "Content-Type": "application/json"
        }
    );

    if (response.statusCode == 200) {
      this.setState(() {
        final jsonResponse = json.decode(response.body);
        rd = new ResultData.fromJson(jsonResponse);
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
  Widget build(BuildContext context){
    if(rd==null) {
      return new Scaffold(
        body: Center(
          child: ListTile(
            title: Image.asset("images/loading/loading.gif"),
          )
        )
      );
    }
    else{

      List<Category> sub_categories = new List<Category>();
      for(var i = 0; i < rd.mc.cats.length; i++){
        if(rd.mc.cats[i].sub_cats!=null){
          for(var j = 0; j < rd.mc.cats[i].sub_cats.length; j++){
            sub_categories.add(rd.mc.cats[i].sub_cats[j]);
          }
        }
      }

      return new Scaffold(
        body: new ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: (sub_categories.length == 0) ? 0 : sub_categories.length,
          itemBuilder: (BuildContext context, int index){
            return Padding(
              padding: const EdgeInsets.all(2.0),
              child: InkWell(
                onTap: (){},
                child: Container(
                  width: 90.0,
                  child: ListTile(
                    title: Image.network('http://jemona.dopos.in:3001' + sub_categories[index].image, width: 50.0, height: 50.0),
                    subtitle: Container(
                      alignment: Alignment.topCenter,
                      child: Text(sub_categories[index].name, style: new TextStyle(fontSize: 10.0),),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
}