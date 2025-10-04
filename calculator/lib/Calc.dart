import 'package:flutter/material.dart';

class Calc extends StatefulWidget {
  const Calc({super.key});

  @override
  State<Calc> createState() => _CalcState();
}

class _CalcState extends State<Calc> {
  String input = "";
  String result = "";

  void buttonPressed(String value) {
    setState(() {
      if (value == "C") {
        input = "";
        result = "";
      } else if (value == "=") {
        // basic evaluation (you can improve with parser later)
        try {
          result = _evaluateExpression(input);
        } catch (e) {
          result = "Error";
        }
      } else {
        input += value;
      }
    });
  }
  String _evaluateExpression(String expr) {
    try {
      // Remove spaces
      expr = expr.replaceAll(" ", "");

      // Tokenize (numbers + operators)
      final tokens = _tokenize(expr);

      // Convert infix to postfix (RPN)
      final postfix = _infixToPostfix(tokens);

      // Evaluate postfix
      final result = _evalPostfix(postfix);

      // Format output (remove .0 if int)
      if (result == result.toInt()) {
        return result.toInt().toString();
      } else {
        return result.toString();
      }
    } catch (e) {
      return "Error";
    }
  }

  List<String> _tokenize(String expr) {
    final tokens = <String>[];
    final buffer = StringBuffer();

    for (int i = 0; i < expr.length; i++) {
      final ch = expr[i];
      if ("0123456789.".contains(ch)) {
        buffer.write(ch);
      } else if ("+-*/()".contains(ch)) {
        if (buffer.isNotEmpty) {
          tokens.add(buffer.toString());
          buffer.clear();
        }
        tokens.add(ch);
      }
    }
    if (buffer.isNotEmpty) tokens.add(buffer.toString());

    return tokens;
  }

  int _precedence(String op) {
    if (op == '+' || op == '-') return 1;
    if (op == '*' || op == '/') return 2;
    return 0;
  }

  List<String> _infixToPostfix(List<String> tokens) {
    final output = <String>[];
    final stack = <String>[];

    for (var token in tokens) {
      if (double.tryParse(token) != null) {
        output.add(token);
      } else if ("+-*/".contains(token)) {
        while (stack.isNotEmpty &&
            _precedence(stack.last) >= _precedence(token)) {
          output.add(stack.removeLast());
        }
        stack.add(token);
      } else if (token == "(") {
        stack.add(token);
      } else if (token == ")") {
        while (stack.isNotEmpty && stack.last != "(") {
          output.add(stack.removeLast());
        }
        stack.removeLast();
      }
    }

    while (stack.isNotEmpty) {
      output.add(stack.removeLast());
    }

    return output;
  }

  double _evalPostfix(List<String> postfix) {
    final stack = <double>[];

    for (var token in postfix) {
      if (double.tryParse(token) != null) {
        stack.add(double.parse(token));
      } else {
        final b = stack.removeLast();
        final a = stack.removeLast();

        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
        }
      }
    }
    return stack.single;
  }


  Widget buildButton(String text, {Color? color}) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color ?? Colors.grey[300],
        ),
        onPressed: () => buttonPressed(text),
        child: Text(
          text,
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Display area
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              input,
              style: const TextStyle(fontSize: 32),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              result,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(),

          // Buttons
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    buildButton("7"),
                    buildButton("8"),
                    buildButton("9"),
                    buildButton("/"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("4"),
                    buildButton("5"),
                    buildButton("6"),
                    buildButton("*"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("1"),
                    buildButton("2"),
                    buildButton("3"),
                    buildButton("-"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("0"),
                    buildButton("."),
                    buildButton("="),
                    buildButton("+"),
                  ],
                ),
                Row(
                  children: [
                    buildButton("C", color: Colors.red[300]),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
