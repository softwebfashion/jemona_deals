class ProductImage{
  final product_image;
  final product_image_url;

  ProductImage({this.product_image, this.product_image_url});

  factory ProductImage.fromJson(Map<String, dynamic> parsedJson){
    return ProductImage(
      product_image:parsedJson['product_image'],
      product_image_url:parsedJson['product_image_url'],
    );
  }
}