// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:sensors_plus/sensors_plus.dart';
//
// import 'package:uboho/service_backend/seizure_prediction/global_seizure_service.dart';
// import 'package:uboho/service_backend/seizure_prediction/model_inference_service.dart';
//
// import 'seizure_monitor_service_test.mocks.dart';
//
// @GenerateMocks([ModelInferenceService])
// void main() {
//   late SeizureMonitorService seizureMonitor;
//   late MockModelInferenceService mockModel;
//   late GlobalKey<NavigatorState> navigatorKey;
//
//   late StreamController<AccelerometerEvent> accelController;
//   late StreamController<GyroscopeEvent> gyroController;
//
//   setUp(() {
//     mockModel = MockModelInferenceService();
//     navigatorKey = GlobalKey<NavigatorState>();
//
//     seizureMonitor = SeizureMonitorService.instance;
//     seizureMonitor.dispose();
//
//     // override vibration to no-op in tests
//     seizureMonitor.testOverrideVibration(
//       vibrateIfPossible: () async {},
//       cancelVibration: () async {},
//     );
//
//     accelController = StreamController<AccelerometerEvent>();
//     gyroController = StreamController<GyroscopeEvent>();
//
//     seizureMonitor.testInjectStreams(
//       accelStream: accelController.stream,
//       gyroStream: gyroController.stream,
//     );
//   });
//
//   tearDown(() async {
//     seizureMonitor.dispose();
//     await accelController.close();
//     await gyroController.close();
//   });
//
//   testWidgets('initializes correctly and listens to streams', (tester) async {
//     when(mockModel.initialize()).thenAnswer((_) async {});
//     when(mockModel.isInitialized).thenReturn(true);
//
//     await tester.pumpWidget(
//       MaterialApp(
//         navigatorKey: navigatorKey,
//         home: const Scaffold(body: Text('Test Home')),
//       ),
//     );
//
//     await seizureMonitor.testInjectModel(mockModel);
//     await seizureMonitor.initialize(navigatorKey);
//
//     expect(seizureMonitor.isInitialized, true);
//   });
//
//   testWidgets('triggers prediction and shows alert when thresholds met', (tester) async {
//     when(mockModel.initialize()).thenAnswer((_) async {});
//     when(mockModel.isInitialized).thenReturn(true);
//     when(mockModel.predict(any)).thenAnswer((_) async => 0.9); // high seizure probability
//
//     await tester.pumpWidget(
//       MaterialApp(
//         navigatorKey: navigatorKey,
//         home: const Scaffold(body: Text('Test Home')),
//       ),
//     );
//
//     await seizureMonitor.testInjectModel(mockModel);
//     await seizureMonitor.initialize(navigatorKey);
//
//     for (int i = 0; i < 6; i++) {
//       final now = DateTime.now();
//       accelController.add(AccelerometerEvent(30, 30, 30, now));
//       gyroController.add(GyroscopeEvent(10, 10, 10, now));
//       await tester.pump(const Duration(milliseconds: 10));
//     }
//
//     await tester.pumpAndSettle();
//
//     expect(seizureMonitor.isAlertShown, true);
//     expect(find.byType(AlertDialog), findsOneWidget);
//   });
//
//   test('dispose cancels subscriptions and resets state', () {
//     seizureMonitor.dispose();
//     expect(seizureMonitor.isInitialized, false);
//   });
// }
