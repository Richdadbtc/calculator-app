import 'package:flutter/material.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1D1D1D),
        primaryColor: Colors.orange,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String _output = "0";
  String _currentInput = "0";
  String _previousInput = "";
  String _operation = "";
  bool _shouldClear = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "AC") {
        _output = "0";
        _currentInput = "0";
        _previousInput = "";
        _operation = "";
        _shouldClear = false;
      } else if (buttonText == "±") {
        _currentInput = (_currentInput.startsWith('-') ? _currentInput.substring(1) : '-' + _currentInput);
        _output = _currentInput;
      } else if (buttonText == "%") {
        _currentInput = (double.parse(_currentInput) / 100).toString();
        _output = _currentInput;
      } else if (buttonText == "=") {
        _calculate();
      } else if (buttonText == "÷" || buttonText == "×" || buttonText == "-" || buttonText == "+") {
        _setOperation(buttonText);
      } else {
        _appendInput(buttonText);
      }
    });
  }

  void _calculate() {
    if (_previousInput.isEmpty || _operation.isEmpty) {
      return;
    }
    double num1 = double.parse(_previousInput);
    double num2 = double.parse(_currentInput);

    double result;
    if (_operation == "+") {
      result = num1 + num2;
    } else if (_operation == "-") {
      result = num1 - num2;
    } else if (_operation == "×") {
      result = num1 * num2;
    } else if (_operation == "÷") {
      if (num2 == 0) {
        _output = "Error";
        _currentInput = "0";
        _previousInput = "";
        _operation = "";
        return;
      }
      result = num1 / num2;
    } else {
      return;
    }

    _output = result.toString();
    _currentInput = result.toString();
    _previousInput = "";
    _operation = "";
    _shouldClear = true;
  }

  void _setOperation(String operation) {
    if (_previousInput.isNotEmpty && _currentInput.isNotEmpty && !_shouldClear) {
      _calculate();
    }
    _previousInput = _currentInput;
    _currentInput = "0";
    _operation = operation;
    _shouldClear = false;
  }

  void _appendInput(String input) {
    if (_shouldClear) {
      _currentInput = "0";
      _shouldClear = false;
    }
    if (input == "." && _currentInput.contains(".")) {
      return;
    }
    if (_currentInput == "0" && input != ".") {
      _currentInput = input;
    } else {
      _currentInput += input;
    }
    _output = _currentInput;
  }

  Widget _buildButton(String buttonText, {Color color = const Color(0xFF323232), Color textColor = Colors.white, double flex = 1}) {
    return Expanded(
      flex: flex.toInt(),
      child: Container(
        margin: EdgeInsets.all(5),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(22),
            backgroundColor: color,
            shape: CircleBorder(),
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              fontSize: 24,
              color: textColor,
            ),
          ),
          onPressed: () => _buttonPressed(buttonText),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
            child: Text(
              _output,
              style: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: Divider(),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _buildButton("AC", color: Color(0xFFa5a5a5), textColor: Colors.black),
                  _buildButton("±", color: Color(0xFFa5a5a5), textColor: Colors.black),
                  _buildButton("%", color: Color(0xFFa5a5a5), textColor: Colors.black),
                  _buildButton("÷", color: Colors.orange),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("7"),
                  _buildButton("8"),
                  _buildButton("9"),
                  _buildButton("×", color: Colors.orange),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("4"),
                  _buildButton("5"),
                  _buildButton("6"),
                  _buildButton("-", color: Colors.orange),
                ],
              ),
              Row(
                children: <Widget>[
                  _buildButton("1"),
                  _buildButton("2"),
                  _buildButton("3"),
                  _buildButton("+", color: Colors.orange),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(22),
                          backgroundColor: Color(0xFF323232),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "0",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () => _buttonPressed("0"),
                      ),
                    ),
                  ),
                  _buildButton(".", color: Color(0xFF323232), textColor: Colors.white),
                  _buildButton("=", color: Colors.orange),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
