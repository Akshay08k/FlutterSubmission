import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/mealModel.dart';

class MealService {
  static const String baseUrl = "http://localhost/meals/api.php";

  Future<List<Meal>> getMeals({String type = '', String search = ''}) async {
    final url = Uri.parse('$baseUrl?action=get_meals&type=$type&search=$search');
    final res = await http.get(url);
    if(res.statusCode == 200){
      final List data = jsonDecode(res.body);
      return data.map((e) => Meal.fromJson(e)).toList();
    }
    return [];
  }

  Future<bool> toggleFavorite(int id) async {
    final res = await http.post(Uri.parse('$baseUrl?action=toggle_favorite'), body: {'id':'$id'});
    if(res.statusCode == 200){
      final data = jsonDecode(res.body);
      return data['success'] ?? false;
    }
    return false;
  }
}
