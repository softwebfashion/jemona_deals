import 'package:jemona_deals/models/category.dart';
import 'package:jemona_deals/models/product.dart';
import 'package:jemona_deals/models/unit.dart';

class MenuCard{
  final int id;
  final int mode;
  final int section_id;
  final int unit_id;
  final String name;
  final List<Category> cats;
  final List<Product> products;
  final Unit unit;

  MenuCard({
    this.id,
    this.mode,
    this.section_id,
    this.unit_id,
    this.name,
    this.cats,
    this.products,
    this.unit
  });

  factory MenuCard.fromJson(Map<String, dynamic> parsedJson){

    List<Category> dataList = null;
    List<Product> dataListProd = null;

    if(parsedJson.containsKey('categories')) {
      var list = parsedJson['categories'] as List;
      dataList = list.map((i) => Category.fromJson(i)).toList();
    }

    if(parsedJson.containsKey('products')) {
      var list_pros = parsedJson['products'] as List;
      dataListProd = list_pros.map((i) => Product.fromJson(i)).toList();
    }

    return MenuCard(
        id: parsedJson['id'],
        mode: parsedJson['mode'],
        section_id: parsedJson['section_id'],
        unit_id: parsedJson['unit_id'],
        name: parsedJson['name'],
        cats: dataList,
        products: dataListProd,
        unit: parsedJson.containsKey('unit') ? Unit.fromJson(parsedJson['unit']) : null
    );
  }
}