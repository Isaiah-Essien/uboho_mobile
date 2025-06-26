import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../popups/alert.dart';

class NetworkManager extends StatefulWidget {
  final Widget child; // The main app content
  const NetworkManager({super.key, required this.child});

  @override
  _NetworkManagerState createState() => _NetworkManagerState();
}

class _NetworkManagerState extends State<NetworkManager> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen((event) {
          if (event.isNotEmpty) {
            _updateConnectionStatus(event.first);
          } else {
            _updateConnectionStatus(ConnectivityResult.none);
          }
        });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _initConnectivity() async {
    try {
      final dynamic result = await _connectivity.checkConnectivity();
      if (result is ConnectivityResult) {
        _updateConnectionStatus(result);
      } else if (result is List<ConnectivityResult> && result.isNotEmpty) {
        _updateConnectionStatus(result.first);
      } else {
        debugPrint("Unexpected connectivity result: $result");
      }
    } on PlatformException catch (e) {
      debugPrint("Couldn't check connectivity status: $e");
    }
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final bool hasInternet = result != ConnectivityResult.none;

    if (_hasInternet != hasInternet) {
      setState(() {
        _hasInternet = hasInternet;
      });

      if (!_hasInternet) {
        _showNoInternetAlert();
      } else {
        _showInternetRestoredAlert();
      }
    }
  }

  void _showNoInternetAlert() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(seconds: 6),
          content: ErrorAlert(message: "No Internet Connection!"),
        ),
      );
    });
  }

  void _showInternetRestoredAlert() {
    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          duration: Duration(seconds: 6),
          content: InformativeAlert(message: "Internet Connection Restored!"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasInternet) {
      return const Scaffold(
        body: Center(
          child: Text(
            "No Internet Connection",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }
    return widget.child;
  }
}
