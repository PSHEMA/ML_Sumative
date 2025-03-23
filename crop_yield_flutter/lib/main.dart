import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const CropYieldApp());
}

class CropYieldApp extends StatelessWidget {
  const CropYieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AgriPredict',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  final List<String> _featureNames = [
    'Temperature (°C)', 'Humidity (%)', 'pH', 'Rainfall (mm)', 'Nitrogen (kg/ha)'
  ];
  
  final List<IconData> _featureIcons = [
    Icons.thermostat, Icons.water_drop, Icons.science, Icons.cloud, Icons.eco
  ];
  
  // Sample test values based on your example
  final List<String> _sampleValues = [
    '30.5', '75.2', '6.8', '120', '3.5'
  ];
  
  bool _isLoading = false;
  String _result = '';
  String _message = '';
  String _apiUrl = 'http://127.0.0.1:8000 '; // Default URL for Android emulator
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers for each feature
    for (int i = 0; i < _featureNames.length; i++) {
      _controllers.add(TextEditingController(text: _sampleValues[i]));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _trainModel() async {
    setState(() {
      _isLoading = true;
      _message = 'Training model...';
      _result = '';
    });

    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/train'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _message = data['message'];
        });
      } else {
        setState(() {
          _message = 'Error training model: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Exception occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _predictYield() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _message = 'Calculating prediction...';
      _result = '';
    });

    try {
      List<double> features = _controllers
          .map((controller) => double.parse(controller.text))
          .toList();

      final response = await http.post(
        Uri.parse('$_apiUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': features,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = 'Predicted Yield: ${data['prediction'].toStringAsFixed(2)} tons/hectare';
          _message = 'Prediction successful!';
        });
      } else {
        setState(() {
          _message = 'Error making prediction: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _message = 'Exception occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showApiDialog() {
    final TextEditingController urlController = TextEditingController(text: _apiUrl);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('API Configuration'),
          content: TextFormField(
            controller: urlController,
            decoration: const InputDecoration(
              labelText: 'API URL',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _apiUrl = urlController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AgriPredict'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showApiDialog,
            tooltip: 'API Settings',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Environmental Factors',
                              style: TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            const SizedBox(height: 16),
                            ...List.generate(_featureNames.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: TextFormField(
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    labelText: _featureNames[index],
                                    border: const OutlineInputBorder(),
                                    prefixIcon: Icon(_featureIcons[index]),
                                    filled: true,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a value';
                                    }
                                    if (double.tryParse(value) == null) {
                                      return 'Please enter a valid number';
                                    }
                                    return null;
                                  },
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (_result.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Prediction Result',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            if (_message.isNotEmpty && !_isLoading)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  _message,
                  style: TextStyle(
                    color: _message.contains('Error') || _message.contains('Exception')
                        ? Colors.red
                        : Colors.blue,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_isLoading)
              Column(
                children: [
                  const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      _message,
                      style: const TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _trainModel,
                    icon: const Icon(Icons.model_training),
                    label: const Text('Train Model'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.amber,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isLoading ? null : _predictYield,
                    icon: const Icon(Icons.auto_graph),
                    label: const Text('Predict Yield'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}