import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:vibration/vibration.dart';
import 'model_inference_service.dart';
import '../../../utiils/popups/seizure_alert_popup.dart';

class SeizureMonitorService {
  static final SeizureMonitorService instance = SeizureMonitorService._internal();
  SeizureMonitorService._internal();

  final ModelInferenceService _model = ModelInferenceService();
  GlobalKey<NavigatorState>? _navigatorKey;

  final List<List<double>> _window = [];
  final int _windowSize = 5;
  final int _minGraceSeconds = 10;

  bool _alertShown = false;
  DateTime? _startTime;

  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;

  double ax = 0, ay = 0, az = 0;
  double gx = 0, gy = 0, gz = 0;

  double motionPeak = 0;
  double rotationPeak = 0;

  bool _initialized = false;

  Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
    if (_initialized) return;
    _navigatorKey = navigatorKey;
    _startTime = DateTime.now();

    await _model.initialize();
    if (_model.isInitialized) {
      _startListening();
      _initialized = true;
      debugPrint("SeizureMonitorService started");
    } else {
      debugPrint("Failed to initialize model.");
    }
  }

  void _startListening() {
    _accelSub = accelerometerEventStream().listen((e) {
      ax = e.x;
      ay = e.y;
      az = e.z;
      _processData();
    });

    _gyroSub = gyroscopeEventStream().listen((e) {
      gx = e.x;
      gy = e.y;
      gz = e.z;
    });
  }

  void _processData() async {
    final sample = [ax, ay, az, gx, gy, gz];
    _window.add(sample);
    if (_window.length > _windowSize) _window.removeAt(0);

    // Update peaks in real time
    final motionMagnitude = sqrt(ax * ax + ay * ay + az * az);
    final rotationMagnitude = sqrt(gx * gx + gy * gy + gz * gz);

    motionPeak = motionMagnitude > motionPeak ? motionMagnitude : motionPeak;
    rotationPeak = rotationMagnitude > rotationPeak ? rotationMagnitude : rotationPeak;

    final now = DateTime.now();
    final secondsSinceStart = now.difference(_startTime!).inSeconds;

    if (_window.length == _windowSize &&
        !_alertShown &&
        secondsSinceStart > _minGraceSeconds) {
      final prob = await _model.predict(_window);
      debugPrint("Global seizure prob: $prob");
      debugPrint("Motion Peak: $motionPeak | Rotation Peak: $rotationPeak");

      if (prob > 0.5 && motionPeak > 20 && rotationPeak > 6) {
        _alertShown = true;

        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(pattern: [0, 500, 1000, 500, 1000], intensities: [128, 255, 128]);
        }

        final ctx = _navigatorKey?.currentContext;
        if (ctx != null) {
          showDialog(
            context: ctx,
            barrierDismissible: false,
            builder: (_) => const SeizureAlertDialog(),
          ).then((_) {
            _alertShown = false;
            Vibration.cancel();
            // Reset peaks after alert
            motionPeak = 0;
            rotationPeak = 0;
          });
        } else {
          debugPrint(' Unable to show seizure dialog — context is null.');
        }
      }
    }
  }

  void dispose() {
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _initialized = false;
    Vibration.cancel();
  }
}



// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:uboho/service_backend/seizure_prediction/model_inference_service.dart';
// import 'package:uboho/utiils/popups/seizure_alert_popup.dart';
// import 'package:vibration/vibration.dart';
//
//
// class SeizureMonitorService {
//   static final SeizureMonitorService instance = SeizureMonitorService._internal();
//   SeizureMonitorService._internal();
//
//   ModelInferenceService _model = ModelInferenceService();
//   GlobalKey<NavigatorState>? _navigatorKey;
//
//   final List<List<double>> _window = [];
//   final int _windowSize = 5;
//   final int _minGraceSeconds = 10;
//
//   bool _alertShown = false;
//   DateTime? _startTime;
//
//   StreamSubscription? _accelSub;
//   StreamSubscription? _gyroSub;
//
//   double ax = 0, ay = 0, az = 0;
//   double gx = 0, gy = 0, gz = 0;
//
//   double motionPeak = 0;
//   double rotationPeak = 0;
//
//   bool _initialized = false;
//
//   // 🛡 Wrapped vibration functions (can override in tests)
//   Future<void> Function() _vibrateIfPossible = () async {
//     if (await Vibration.hasVibrator() ?? false) {
//       await Vibration.vibrate(pattern: [0, 500, 1000, 500, 1000], intensities: [128, 255, 128]);
//     }
//   };
//   Future<void> Function() _cancelVibration = () async {
//     await Vibration.cancel();
//   };
//
//   Future<void> initialize(GlobalKey<NavigatorState> navigatorKey) async {
//     if (_initialized) return;
//     _navigatorKey = navigatorKey;
//     _startTime = DateTime.now();
//
//     await _model.initialize();
//     if (_model.isInitialized) {
//       _startListening();
//       _initialized = true;
//       debugPrint("SeizureMonitorService started");
//     } else {
//       debugPrint("Failed to initialize model.");
//     }
//   }
//
//   void _startListening() {
//     _accelSub = accelerometerEventStream().listen((e) {
//       ax = e.x;
//       ay = e.y;
//       az = e.z;
//       _processData();
//     });
//
//     _gyroSub = gyroscopeEventStream().listen((e) {
//       gx = e.x;
//       gy = e.y;
//       gz = e.z;
//     });
//   }
//
//   void _processData() async {
//     final sample = [ax, ay, az, gx, gy, gz];
//     _window.add(sample);
//     if (_window.length > _windowSize) _window.removeAt(0);
//
//     final motionMagnitude = sqrt(ax * ax + ay * ay + az * az);
//     final rotationMagnitude = sqrt(gx * gx + gy * gy + gz * gz);
//
//     motionPeak = motionMagnitude > motionPeak ? motionMagnitude : motionPeak;
//     rotationPeak = rotationMagnitude > rotationPeak ? rotationMagnitude : rotationPeak;
//
//     final now = DateTime.now();
//     final secondsSinceStart = now.difference(_startTime!).inSeconds;
//
//     if (_window.length == _windowSize &&
//         !_alertShown &&
//         secondsSinceStart > _minGraceSeconds) {
//       final prob = await _model.predict(_window);
//       debugPrint("Global seizure prob: $prob");
//       debugPrint("Motion Peak: $motionPeak | Rotation Peak: $rotationPeak");
//
//       if (prob > 0.5 && motionPeak > 20 && rotationPeak > 6) {
//         _alertShown = true;
//
//         await _vibrateIfPossible();
//
//         final ctx = _navigatorKey?.currentContext;
//         if (ctx != null) {
//           showDialog(
//             context: ctx,
//             barrierDismissible: false,
//             builder: (_) => const SeizureAlertDialog(),
//           ).then((_) async {
//             _alertShown = false;
//             await _cancelVibration();
//             motionPeak = 0;
//             rotationPeak = 0;
//           });
//         } else {
//           debugPrint(' Unable to show seizure dialog — context is null.');
//         }
//       }
//     }
//   }
//
//   void dispose() {
//     _accelSub?.cancel();
//     _gyroSub?.cancel();
//     _initialized = false;
//     _cancelVibration();
//   }
//
//   //  ---------- TEST HELPERS ----------
//
//   @visibleForTesting
//   void testInjectStreams({
//     required Stream<AccelerometerEvent> accelStream,
//     required Stream<GyroscopeEvent> gyroStream,
//   }) {
//     _accelSub?.cancel();
//     _gyroSub?.cancel();
//     _accelSub = accelStream.listen((e) {
//       ax = e.x;
//       ay = e.y;
//       az = e.z;
//       _processData();
//     });
//     _gyroSub = gyroStream.listen((e) {
//       gx = e.x;
//       gy = e.y;
//       gz = e.z;
//     });
//   }
//
//   @visibleForTesting
//   Future<void> testInjectModel(ModelInferenceService model) async {
//     _model = model;
//   }
//
//   @visibleForTesting
//   void testOverrideVibration({
//     Future<void> Function()? vibrateIfPossible,
//     Future<void> Function()? cancelVibration,
//   }) {
//     _vibrateIfPossible = vibrateIfPossible ?? _vibrateIfPossible;
//     _cancelVibration = cancelVibration ?? _cancelVibration;
//   }
//
//   @visibleForTesting
//   bool get isInitialized => _initialized;
//
//   @visibleForTesting
//   bool get isAlertShown => _alertShown;
// }
