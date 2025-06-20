import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:tflite_flutter/tflite_flutter.dart';

class ModelInferenceService {
  late Interpreter _interpreter;
  late List<double> _mean;
  late List<double> _scale;

  bool _initialized = false;

  Future<void> initialize() async {
    // Load TFLite model
    final model = await rootBundle.load('assets/models/mobile_seizure_GRU_model.tflite');
    _interpreter = await Interpreter.fromBuffer(model.buffer.asUint8List());

    // Load scaler values
    final jsonString = await rootBundle.loadString('assets/models/scaler_values.json');
    final Map<String, dynamic> scaler = jsonDecode(jsonString);
    _mean = List<double>.from(scaler['mean']);
    _scale = List<double>.from(scaler['scale']);

    _initialized = true;
  }

  bool get isInitialized => _initialized;

  /// Normalize input buffer and run inference
  Future<double> predict(List<List<double>> inputWindow) async {
    if (!_initialized) {
      throw Exception("ModelInferenceService is not initialized.");
    }

    // Ensure shape is 5x6 (5 rows, 6 features)
    final List<List<double>> normalized = inputWindow.map((row) {
      return List.generate(row.length, (i) => (row[i] - _mean[i]) / _scale[i]);
    }).toList();

    // Convert to tensor input
    final input = List.generate(1, (_) => normalized); // shape [1, 5, 6]
    final output = List.filled(1, 0.0).reshape([1, 1]);

    _interpreter.run(input, output);

    return output[0][0];
  }
}
