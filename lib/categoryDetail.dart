import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meal_db/detail.dart';
import 'package:meal_db/main.dart';

import 'package:http/http.dart' as http;

class CategoryMeals {
  final String strMeal;
  final String strMealThumb;
  final String idMeal;

  CategoryMeals(this.strMeal, this.strMealThumb, this.idMeal);
}

class CategoryDetail extends StatelessWidget {
  final Categories cmeals;
  const CategoryDetail({Key key, this.cmeals}) : super(key: key);

  String get strCategory => cmeals.strCategory.toLowerCase();

  Future<List<CategoryMeals>> getMeals() async {
    var data = await http.get(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$strCategory");

    var jsonData = json.decode(data.body);

    var mealData = jsonData['meals'];
    List<CategoryMeals> meals = [];
    for (var data in mealData) {
      CategoryMeals mealItem = CategoryMeals(
        data['strMealThumb'],
        data['strMeal'],
        data['idMeal'],
      );
      meals.add(mealItem);
    }
    return meals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Categories: ${cmeals.strCategory}"),
        ),
        body: Container(
          child: FutureBuilder(
            future: getMeals(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        CategoryMeals meals = CategoryMeals(
                          snapshot.data[index].strMeal,
                          snapshot.data[index].strMealThumb,
                          snapshot.data[index].idMeal,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MealDetail(cmeals: meals)));
                      },
                      child: Card(
                        child: Container(
                          //padding: EdgeInsets.all(8),
                          //margin: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              snapshot.data[index].strMeal == null
                                  ? Image.network(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR0w3ybznCr9bcpVdZA2N_y5KbZpyBHVax4IQ&usqp=CAU",
                                      height: 100,
                                      width: 100,
                                    )
                                  : Image.network(
                                      snapshot.data[index].strMeal,
                                      height: 100,
                                      width: 100,
                                    ),
                              Padding(padding: EdgeInsets.all(5)),
                              Expanded(
                                  child: Container(
                                child: snapshot.data[index].strMealThumb == null
                                    ? Text("Sorry don't have mean")
                                    : Text(
                                        snapshot.data[index].strMealThumb,
                                      ),
                              ))
                            ],
                          ),

                          //Padding(padding: EdgeInsets.all(8)),

                          //Text(snapshot.data[index].description)
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}
