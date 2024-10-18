import 'package:bloc_test/bloc_test.dart';
import 'package:breizh_blok_mobile/blocs/vibrator_bloc.dart';
import 'package:breizh_blok_mobile/vibrator_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([VibratorService])
import './vibrator_bloc_test.mocks.dart';

void main() {
  final mockVibration = MockVibratorService();

  setUp(() {
    reset(mockVibration);
  });
  group('VibratorBloc', () {
    blocTest<VibratorBloc, VibratorState>(
      'vibrate',
      build: () => VibratorBloc(vibratorService: mockVibration),
      act: (bloc) => bloc.add(VibrateEvent()),
      setUp: () {
        when(
          mockVibration.hasVibrator(),
        ).thenAnswer((_) async {
          return true;
        });
      },
      verify: (VibratorBloc bloc) {
        verify(
          mockVibration.vibrate(),
        ).called(1);
      },
    );

    blocTest<VibratorBloc, VibratorState>(
      'cannot vibrate',
      build: () => VibratorBloc(vibratorService: mockVibration),
      act: (bloc) => bloc.add(VibrateEvent()),
      setUp: () {
        when(
          mockVibration.hasVibrator(),
        ).thenAnswer((_) async {
          return false;
        });
      },
      verify: (VibratorBloc bloc) {
        verifyNever(
          mockVibration.vibrate(),
        );
      },
    );
  });
}
