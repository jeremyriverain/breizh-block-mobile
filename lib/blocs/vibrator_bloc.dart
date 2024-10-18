import 'package:breizh_blok_mobile/vibrator_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VibratorEvent {}

class RequestVibratorEvent extends VibratorEvent {
  RequestVibratorEvent();
}

class VibrateEvent extends VibratorEvent {
  VibrateEvent();
}

class VibratorState {
  const VibratorState();
}

class VibratorBloc extends Bloc<VibratorEvent, VibratorState> {
  VibratorBloc({
    required this.vibratorService,
  }) : super(const VibratorState()) {
    var canVibrate = false;
    on<RequestVibratorEvent>(
      (event, emit) async {
        canVibrate = await vibratorService.hasVibrator() ?? false;
      },
    );

    on<VibrateEvent>(
      (event, emit) async {
        if (canVibrate) {
          await vibratorService.vibrate();
        }
      },
    );

    add(RequestVibratorEvent());
  }
  final VibratorService vibratorService;
}
