import 'package:flutter/material.dart';
import 'package:jemona_deals/pages/product_details.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  var product_list = [
    {
      "id": 1,
      "name":"Blazer",
      "picture":"images/products/blazer1.jpeg",
      "old_price": 120.00,
      "price": 99.00,
    },
    {
      "id": 2,
      "name":"Red Dress",
      "picture":"images/products/dress1.jpeg",
      "old_price": 120.00,
      "price": 99.00,
    }
  ];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: product_list.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext con, int index){
        return Product(
          id: product_list[index]["id"],
          name: product_list[index]["name"],
          picture: product_list[index]["picture"],
          old_price: product_list[index]["old_price"],
          price: product_list[index]["price"]
        );
      }
    );
  }
}

// SINGLE PRODUCT CLASS
 class Product extends StatelessWidget {
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

   @override
   Widget build(BuildContext context) {
     return Card(
       child: Hero(
           tag: name,
           child: Material(
             child: InkWell(
               onTap: ()=> Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new ProductDetails())),
               child: GridTile(
                 footer: Container(
                   color: Colors.white70,
                   child: ListTile(
                     leading: Text(name,
                       style: TextStyle(
                         fontWeight: FontWeight.bold
                       ),
                     ),
                     title: Text("\₹$price", style: TextStyle(color: Colors.pink, fontWeight: FontWeight.w800),),
                     subtitle: Text(
                       "\₹$old_price",
                       style: TextStyle(
                         color: Colors.black54,
                         fontWeight: FontWeight.w800,
                         decoration: TextDecoration.lineThrough
                       ),
                     )
                   ),
                 ),
                 child: Image.asset(picture, fit: BoxFit.cover,),
               ),
             ),
           ),
       ),
     );
   }
 }
 
