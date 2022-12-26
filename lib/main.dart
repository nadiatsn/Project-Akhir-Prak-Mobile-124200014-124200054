import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_db/categoryDetail.dart';
import 'package:meal_db/random_detail.dart';

void main() {
  runApp(MyApp());
}

class Meals {
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final String strArea;
  final String strTags;
  final String strInstructions;
  final String idMeal;

  Meals(this.strMeal, this.strCategory, this.strArea, this.strTags,
      this.strMealThumb, this.strInstructions, this.idMeal);
}

class Categories {
  final String strCategory;
  final String strCategoryThumb;
  final String strCategoryDescription;

  Categories(
      this.strCategory, this.strCategoryDescription, this.strCategoryThumb);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.green[200],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: new Center(child : Text("Foods", textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic, fontFamily:'LilitaOne',
                  fontWeight: FontWeight.normal, fontSize: 35)),),
        ),
        body: CategoriesMeal(),
      ),
    );
  }
}

class CategoriesMeal extends StatefulWidget {
  @override
  _CategoriesMealState createState() => _CategoriesMealState();
}

class _CategoriesMealState extends State<CategoriesMeal> {
  Future<List<Categories>> getCategory() async {
    var category = await http
        .get("https://www.themealdb.com/api/json/v1/1/categories.php");

    var jsonCategoryData = json.decode(category.body);

    var mealCategoryData = jsonCategoryData['categories'];

    List<Categories> categories = [];
    for (var data in mealCategoryData) {
      Categories mealItem = Categories(data['strCategory'],
          data['strCategoryThumb'], data['strCategoryDescription']);
      categories.add(mealItem);
    }
    return categories;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getCategory(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Categories meals = Categories(
                      snapshot.data[index].strCategory,
                      snapshot.data[index].strCategoryThumb,
                      snapshot.data[index].strCategoryDescription,
                    );
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CategoryDetail(
                                  cmeals: meals,
                                )));
                  },
                  child: Card(
                    child: Container(
                      // margin: EdgeInsets.all(4),

                      child: Column(
                        children: [
                          // snapshot.data[index].strCategoryThumb == null
                          //     ? Image.network(
                          //         "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR0w3ybznCr9bcpVdZA2N_y5KbZpyBHVax4IQ&usqp=CAU",
                          //         height: 90,
                          //       )
                          //     : Image.network(
                          //         snapshot.data[index].strCategoryThumb,
                          //         height: 90,
                          //       ),
                          Text(
                            snapshot.data[index].strCategory,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
