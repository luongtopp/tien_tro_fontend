abstract class OnBoardingState {}

class OnBoardingInitial extends OnBoardingState {
  final int currentPage;

  OnBoardingInitial(this.currentPage);
}

class OnBoardingCompleted extends OnBoardingState {}
