import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/app_constants.dart';
import '../../global.dart';
import 'onboarding_events.dart';
import 'onboarding_states.dart';

class OnBoardingBloc extends Bloc<OnBoardingEvent, OnBoardingState> {
  OnBoardingBloc() : super(OnBoardingInitial(0)) {
    on<PageChangedEvent>((event, emit) {
      emit(OnBoardingInitial(event.pageIndex));
    });

    on<CompleteOnboardingEvent>((event, emit) {
      Global.storageService
          .setBool(AppConstants.STORAGE_DEVICE_FIRST_OPEN, true);

      emit(OnBoardingCompleted());
    });
  }
}
