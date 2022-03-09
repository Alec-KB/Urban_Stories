import 'StoryCreator.dart';
import 'package:flutter/material.dart';

Color primaryColor = Colors.purple;
Color accentColor = Colors.purpleAccent;
Color backgroundColor = Colors.white;
Color bodyTextColor = Colors.black;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Stories',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
        backgroundColor: backgroundColor,
        appBarTheme: AppBarTheme(color: primaryColor),
        textTheme: TextTheme(
          bodyText1: TextStyle(
            fontSize: 16,
            fontFamily: 'Georgia',
            color: bodyTextColor,
          )
        )
      ),
      home: const StoryCreator(),
    );
  }
}

void colorTheme(String type){
  print(type);
  switch(type){
    case "purple":
      primaryColor = Colors.purple;
      accentColor = Colors.purpleAccent;
      break;
    case "black":
      primaryColor = Colors.blue;
      accentColor = Colors.blueAccent;
      break;
  }
  print(primaryColor);
  print(accentColor);

}

