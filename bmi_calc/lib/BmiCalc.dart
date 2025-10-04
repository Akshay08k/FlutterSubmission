import 'package:flutter/material.dart';

class BmiCalc extends StatefulWidget {
  const BmiCalc({super.key});

  @override
  State<BmiCalc> createState() => _BmiCalcState();
}

class _BmiCalcState extends State<BmiCalc> {
  final TextEditingController age = TextEditingController();
  final TextEditingController height = TextEditingController();
  final TextEditingController weight = TextEditingController();

  String result = '';

  void calculateBmi() {
    final double? h = double.tryParse(height.text);
    final double? w = double.tryParse(weight.text);

    if (h == null || w == null || h <= 0 || w <= 0) {
      setState(() {
        result = "Please enter valid height and weight.";
      });
      return;
    }

    // Convert height to meters
    double heightInMeters = h / 100;
    double bmi = w / (heightInMeters * heightInMeters);

    String category;
    if (bmi < 18.5) {
      category = "Underweight";
    } else if (bmi < 25) {
      category = "Normal";
    } else if (bmi < 30) {
      category = "Overweight";
    } else {
      category = "Obese";
    }

    setState(() {
      result = "Your BMI is ${bmi.toStringAsFixed(2)} ($category)";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI Calculator"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildTextField(controller: age, hint: "Age"),
              const SizedBox(height: 12),
              _buildTextField(controller: height, hint: "Height (cm)"),
              const SizedBox(height: 12),
              _buildTextField(controller: weight, hint: "Weight (kg)"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBmi,
                child: const Text("Calculate BMI"),
              ),
              const SizedBox(height: 20),
              Text(
                result,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
