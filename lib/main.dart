import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

// My Own Imports
import 'package:jemona_deals/components/categories.dart';
import 'package:jemona_deals/components/product_list.dart';

void main(){
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      )
  );
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('images/c1.jpg'),
          AssetImage('images/m1.jpeg'),
          AssetImage('images/w3.jpeg'),
          AssetImage('images/w4.jpeg'),
          AssetImage('images/m2.jpg'),
        ],
        autoplay: false,
        // animationCurve: Curves.fastOutSlowIn,
        // animationDuration: Duration(microseconds: 1000),
        dotSize: 4.0,
        // dotColor: Colors.pink,
        indicatorBgPadding: 2.0,
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.1,
        backgroundColor: Colors.pink,
        title: Text("Jemona Deals"),
        actions: [
          new IconButton(icon: Icon(Icons.search, color: Colors.white), onPressed: (){}),
          new IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white), onPressed: (){})
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: [
          //  Header
            new UserAccountsDrawerHeader(
                accountName: Text("Abdul Nasim"),
                accountEmail: Text("abdul@gmail.com"),
              currentAccountPicture: GestureDetector(
               child: new CircleAvatar(
                 backgroundColor: Colors.grey,
                 child: Icon(Icons.person,color: Colors.white,),
               ),
              ),
              decoration: new BoxDecoration(
                color: Colors.pink
              ),
            ),
            // MENU BODY
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text("Home"),
                leading: Icon(Icons.home),
              )
            ),

            InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text("My Account"),
                  leading: Icon(Icons.person),
                )
            ),

            InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text("My Orders"),
                  leading: Icon(Icons.shopping_basket),
                )
            ),

            InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text("Categories"),
                  leading: Icon(Icons.dashboard),
                )
            ),

            InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text("Favourites"),
                  leading: Icon(Icons.favorite),
                )
            ),

            Divider(),

            InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text("Settings"),
                  leading: Icon(Icons.settings, color: Colors.blue),
                )
            ),

            InkWell(
                onTap: (){},
                child: ListTile(
                  title: Text("About"),
                  leading: Icon(Icons.help, color: Colors.green),
                )
            ),

          ],
        ),
      ),

      body: new ListView(
        children: [
          // IMAGE SLIDER CAROUSEL
          image_carousel,

          // Padding widget
          new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Text("Categories")
          ),

          // Horizontal list view
          // HorizontalList(),
          Container(
            height: 100.0,
            child: Categories(),
          ),

          // Padding widget
          new Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Text("Recent Products")
          ),

          //  GRID VIEW
          Container(
            height: 320.0,
            child: ProductList(),
          )

        ],
      ),
    );
  }
}