import 'package:flutter/material.dart';
import 'screens/mealScreen.dart';

void main() {
  runApp(const MealsApp());
}

class MealsApp extends StatelessWidget {
  const MealsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Meals App",
      theme: ThemeData(primarySwatch: Colors.orange),
      home: const MealHome(),
    );
  }
}
