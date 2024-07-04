import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  late StreamController<bool> _connectionChangeController;

  Stream<bool> get connectionChange => _connectionChangeController.stream;

  ConnectivityService() {
    _connectionChangeController = StreamController<bool>();
    initConnectivity();
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  void _updateConnectionStatus(ConnectivityResult result) async {
    bool isConnected = result != ConnectivityResult.none;
    _connectionChangeController.add(isConnected);
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result);
  }

  void dispose() {
    _connectionChangeController.close();
  }
}