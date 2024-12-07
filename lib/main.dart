
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/currentweather.dart';


void main(){
  runApp(MaterialApp(
   initialRoute: '/',
    routes: {
     "/":(context)=>WeatherPage(city: 'Madina'
         ),
    },
  ));
}
