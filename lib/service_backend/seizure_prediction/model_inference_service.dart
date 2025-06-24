import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelInferenceService {
  late Interpreter _interpreter;
  late List<double> _mean;
  late List<double> _scale;
  bool _initialized = false;

  Future<void> initialize() async {
    try {
      // Load TFLite model from assets
      _interpreter = await Interpreter.fromAsset('assets/models/seizure_cnn_model.tflite');

      // Load normalization values
      final jsonString = await rootBundle.loadString('assets/models/scaler_values.json');
      final Map<String, dynamic> scaler = jsonDecode(jsonString);
      _mean = List<double>.from(scaler['mean']);
      _scale = List<double>.from(scaler['scale']);

      _initialized = true;
      print("Conv1D model loaded successfully.");
    } catch (e) {
      print("Model initialization failed: $e");
      _initialized = false;
    }
  }

  bool get isInitialized => _initialized;

  Future<double> predict(List<List<double>> inputWindow) async {
    if (!_initialized) throw Exception("Model not initialized.");

    // Normalize each feature
    final List<List<double>> normalized = inputWindow.map((row) {
      return List.generate(row.length, (i) => (row[i] - _mean[i]) / _scale[i]);
    }).toList();

    final input = [normalized]; // shape: [1, 5, 6]
    final output = List.filled(1, 0.0).reshape([1, 1]);

    try {
      _interpreter.run(input, output);
      return output[0][0];
    } catch (e) {
      print("Model inference failed: $e");
      return 0.0;
    }
  }
}
