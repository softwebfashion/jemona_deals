import 'package:jemona_deals/models/product_image.dart';

class Product {
  final product_id;
  final product_name;
  final product_sku;
  final picture;
  final procured_price;
  final sell_price;
  final description;
  final List<ProductImage> product_images;

  Product({
    this.product_id,
    this.product_name,
    this.product_sku,
    this.picture,
    this.procured_price,
    this.sell_price,
    this.description,
    this.product_images,
  });

  factory Product.fromJson(Map<String, dynamic> parsedJson){
    List<ProductImage> imageList = new List<ProductImage>();

    if(parsedJson.containsKey('product_images')) {
      var list = parsedJson['product_images'] as List;
      imageList = list.map((i) => ProductImage.fromJson(i)).toList();
    }

    return Product(
      product_id: parsedJson['product_id'],
      product_name: parsedJson['product_name'],
      product_sku: parsedJson.containsKey('product_sku') ? parsedJson['product_sku'] : null,
      picture: parsedJson.containsKey('product_image_url') ? parsedJson['product_image_url'] : null,
      procured_price: parsedJson['procured_price'],
      sell_price: parsedJson['sell_price'],
      description: parsedJson.containsKey('description') ? parsedJson['description'] : null,
      product_images: parsedJson.containsKey('product_images') ? imageList : null
    );
  }
}