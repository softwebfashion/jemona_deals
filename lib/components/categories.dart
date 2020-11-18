import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
                  width: 100.0,
                  child: ListTile(
                    title: Image.network('http://jemona.dopos.in:3001' + sub_categories[index].image, width: 100.0, height: 80.0),
                    subtitle: Container(
                      alignment: Alignment.topCenter,
                      child: Text(sub_categories[index].name, style: new TextStyle(fontSize: 12.0,),),
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
  final List<Category> cats;

  MenuCard({
    this.id,
    this.mode,
    this.section_id,
    this.unit_id,
    this.name,
    this.cats
  });

  factory MenuCard.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['categories'] as List;
    List<Category> dataList = list.map((i) => Category.fromJson(i)).toList();


    return MenuCard(
        id: parsedJson['id'],
        mode: parsedJson['mode'],
        section_id: parsedJson['section_id'],
        unit_id: parsedJson['unit_id'],
        name: parsedJson['name'],
        cats: dataList
    );
  }
}

class Category {

  final int id;
  final String name;
  final String image;
  final List<Category> sub_cats;

  Category({
    this.id,
    this.name,
    this.image,
    this.sub_cats
  });

  factory Category.fromJson(Map<String, dynamic> parsedJson){

    var list = parsedJson['sub_categories'] as List;
    List<Category> subCatList = (parsedJson['sub_categories'] == null) ? null : list.map((i) => Category.fromJson(i)).toList();
    return Category(
        id:parsedJson['id'],
        name:parsedJson['name'],
        image:parsedJson['menu_category_image'],
        sub_cats: subCatList
    );
  }
}
