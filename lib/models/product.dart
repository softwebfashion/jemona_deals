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
      name:parsedJson['product_name'],
      picture:parsedJson['product_image_url'],
      old_price:parsedJson['procured_price'],
      price:parsedJson['sale_price'],
    );
  }
}