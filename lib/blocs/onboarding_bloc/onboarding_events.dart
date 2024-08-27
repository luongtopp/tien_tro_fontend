// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class OnBoardingEvent extends Equatable {
  const OnBoardingEvent();

  @override
  List<Object> get props => [];
}

class PageChangedEvent extends OnBoardingEvent {
  final int pageIndex;

  const PageChangedEvent(this.pageIndex);
}

class CompleteOnboardingEvent extends OnBoardingEvent {}
