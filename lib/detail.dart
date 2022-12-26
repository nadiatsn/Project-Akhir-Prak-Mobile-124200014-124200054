import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:meal_db/categoryDetail.dart';

class MealsDetails {
  final String strMeal;
  final String strMealThumb;
  final String strCategory;
  final String strArea;
  final String strTags;
  final String strInstructions;
  final String idMeal;

  MealsDetails(this.strMeal, this.strCategory, this.strArea, this.strTags,
      this.strMealThumb, this.strInstructions, this.idMeal);
}

class MealDetail extends StatelessWidget {
  final CategoryMeals cmeals;
  const MealDetail({Key key, this.cmeals}) : super(key: key);

  String get idMeal => cmeals.idMeal.toString();

  Future<List<MealsDetails>> getMeals() async {
    var data = await http
        .get("https://www.themealdb.com/api/json/v1/1/lookup.php?i=$idMeal");

    var jsonData = json.decode(data.body);

    var mealData = jsonData['meals'];
    List<MealsDetails> meals = [];
    for (var data in mealData) {
      MealsDetails mealItem = MealsDetails(
          data['strMealThumb'],
          data['strCategory'],
          data['strInstructions'],
          data['strMeal'],
          data['strArea'],
          data['idMeal'],
          data['strTags']);
      meals.add(mealItem);
    }
    return meals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Meals Details"),
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
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        //padding: EdgeInsets.all(8),
                        //margin: EdgeInsets.all(5),

                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(3)),
                            snapshot.data[index].strMeal == null
                                ? Image.network(
                                    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcR0w3ybznCr9bcpVdZA2N_y5KbZpyBHVax4IQ&usqp=CAU",
                                    height: 300,
                                    width: 300,
                                  )
                                : Image.network(
                                    snapshot.data[index].strMeal,
                                    height: 300,
                                    width: 300,
                                  ),
                            Padding(padding: EdgeInsets.all(3)),
                            snapshot.data[index].strMealThumb == null
                                ? Text("")
                                : Text(
                                    snapshot.data[index].strMealThumb,
                                    softWrap: false,
                                  ),
                            Padding(padding: EdgeInsets.all(3)),
                            snapshot.data[index].strCategory == null
                                ? Text("")
                                : Text(
                                    snapshot.data[index].strCategory,
                                    softWrap: false,
                                  ),
                            Padding(padding: EdgeInsets.all(3)),
                            snapshot.data[index].strTags == null
                                ? Text("")
                                : Text(
                                    snapshot.data[index].strTags,
                                    softWrap: false,
                                  ),
                            Padding(padding: EdgeInsets.all(3)),
                            snapshot.data[index].idMeal == null
                                ? Text("")
                                : Text(
                                    snapshot.data[index].idMeal,
                                    softWrap: false,
                                  ),
                            Padding(padding: EdgeInsets.all(5)),
                            snapshot.data[index].strArea == null
                                ? Text("")
                                : Text(
                                    snapshot.data[index].strArea,
                                  ),
                          ],
                        ),

                        //Padding(padding: EdgeInsets.all(8)),

                        //Text(snapshot.data[index].description)
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
