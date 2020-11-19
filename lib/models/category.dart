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