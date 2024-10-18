import 'package:vibration/vibration.dart';

class VibratorService {
  Future<bool?> hasVibrator() async {
    return Vibration.hasVibrator();
  }

  Future<void> vibrate() async {
    return Vibration.vibrate();
  }
}
