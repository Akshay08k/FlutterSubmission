import 'package:flutter/material.dart';
import '../models/mealModel.dart';
import '../services/mealService.dart';

class MealHome extends StatefulWidget {
  const MealHome({super.key});

  @override
  State<MealHome> createState() => _MealHomeState();
}

class _MealHomeState extends State<MealHome> {
  final MealService _service = MealService();
  List<Meal> _meals = [];
  String _search = '';
  String _filter = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => _loading = true);
    final meals = await _service.getMeals(type: _filter, search: _search);
    setState(() {
      _meals = meals;
      _loading = false;
    });
  }

  void _toggleFavorite(Meal meal) async {
    final success = await _service.toggleFavorite(meal.id);
    if(success){
      setState(() => meal.isFavorite = !meal.isFavorite);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("🍴 Meals App"),
        backgroundColor: Colors.orange.shade600,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                hintText: "Search meals...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _loadMeals,
                ),
              ),
              onChanged: (val) => _search = val,
              onSubmitted: (_) => _loadMeals(),
            ),
            const SizedBox(height: 10),
            // Filter buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _filterButton("All", ''),
                const SizedBox(width: 10),
                _filterButton("Veg", 'veg'),
                const SizedBox(width: 10),
                _filterButton("Non-Veg", 'non-veg'),
              ],
            ),
            const SizedBox(height: 10),

            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _meals.isEmpty
                  ? const Center(child: Text("No meals found"))
                  : ListView.builder(
                itemCount: _meals.length,
                itemBuilder: (_, index){
                  final meal = _meals[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(meal.name),
                      subtitle: Text("${meal.type.toUpperCase()} - ${meal.description}"),
                      trailing: IconButton(
                        icon: Icon(
                          meal.isFavorite? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                        ),
                        onPressed: () => _toggleFavorite(meal),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String label, String value) {
    final bool active = _filter == value;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: active ? Colors.orange.shade700 : Colors.grey.shade400,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        setState(() => _filter = value);
        _loadMeals();
      },
      child: Text(label),
    );
  }
}
