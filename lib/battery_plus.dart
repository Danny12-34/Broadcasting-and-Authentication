import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'dart:async';

class BatteryService {
  final Battery _battery = Battery();
  late StreamController<int> _batteryChangeController;

  Stream<int> get batteryChange => _batteryChangeController.stream.asBroadcastStream();

  BatteryService() {
    _batteryChangeController = StreamController<int>.broadcast();
    _battery.onBatteryStateChanged.listen(_updateBatteryState);
  }

  void _updateBatteryState(BatteryState state) async {
    int batteryLevel = await _battery.batteryLevel;
    _batteryChangeController.add(batteryLevel);

    if (state == BatteryState.charging && batteryLevel >= 90) {
      
      FlutterRingtonePlayer.play(
        android: AndroidSounds.notification,
        ios: IosSounds.glass,
        looping: true,
        volume: 1.0,
        asAlarm: true,
      );
    } else {
      FlutterRingtonePlayer.stop();
    }
  }

  void dispose() {
    _batteryChangeController.close();
  }
}
