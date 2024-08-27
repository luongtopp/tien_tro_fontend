import 'package:chia_se_tien_sinh_hoat_tro/config/app_color.dart';
import 'package:chia_se_tien_sinh_hoat_tro/config/onboarding_config.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../blocs/onboarding_bloc/onboarding_blocs.dart';
import '../../blocs/onboarding_bloc/onboarding_events.dart';
import '../../blocs/onboarding_bloc/onboarding_states.dart';
import '../../config/text_styles.dart';
import '../../routes/app_route.dart';
import '../../widgets/buttons/custom_button.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  Widget _buildPaint(CustomClipper<Path> paints) {
    return ClipPath(
      clipper: paints,
      child: Container(
        color: Colors.white,
        width: 430.w,
        height: 624.h,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnBoardingBloc, OnBoardingState>(
      builder: (context, state) {
        if (state is OnBoardingInitial) {
          return Container(
            color: Colors.white,
            child: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundColor,
                ),
                child: Stack(
                  children: [
                    PageView(
                      controller: _pageController,
                      onPageChanged: (page) {
                        BlocProvider.of<OnBoardingBloc>(context)
                            .add(PageChangedEvent(page));
                      },
                      children: [
                        _page(
                          state.currentPage,
                          _buildPaint(PaintOne()),
                          OnboardingConfig.onboardingImages[0],
                          OnboardingConfig.titleText[0],
                          OnboardingConfig.subTitleText[0],
                        ),
                        _page(
                          state.currentPage,
                          _buildPaint(PaintTow()),
                          OnboardingConfig.onboardingImages[1],
                          OnboardingConfig.titleText[1],
                          OnboardingConfig.subTitleText[1],
                        ),
                        _page(
                          state.currentPage,
                          _buildPaint(PaintThree()),
                          OnboardingConfig.onboardingImages[2],
                          OnboardingConfig.titleText[2],
                          OnboardingConfig.subTitleText[2],
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.only(bottom: 250.h),
                      child: DotsIndicator(
                        position: state.currentPage,
                        decorator: DotsDecorator(
                            color: Colors.white,
                            activeColor: AppColors.primaryColor,
                            activeSize: const Size(18.0, 8.0),
                            activeShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                        dotsCount: 3,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _page(int index, Widget widget, String image, String headingText,
      String subText) {
    return Stack(
      children: [
        widget,
        SafeArea(
          child: Container(
            padding: const EdgeInsets.only(left: 20, right: 20),
            width: 430.w,
            child: Column(
              children: [
                Container(
                  width: 300.w,
                  height: 300.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(image)),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  headingText,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleStyle,
                ),
                SizedBox(height: 15.h),
                Text(
                  subText,
                  style: TextStyles.subtitleStyle,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 763.h),
          alignment: Alignment.topCenter,
          child: CustomButton(
            isBorder: false,
            onTap: () {
              if (index < 2) {
                _pageController.animateToPage(
                  index = index + 1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.decelerate,
                );
              } else if (index == 2) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(AppRoutes.LOGIN, (route) => false);
              }
            },
            text: index == 2 ? 'Bắt đầu' : 'Tiếp theo',
            width: 261.w,
            height: 70.h,
            color: Colors.white,
            textStyle: TextStyles.outlinedButton,
            borderRadius: 67.w,
          ),
        )
      ],
    );
  }
}

class PaintOne extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0,
        530.01.h); // Adjust the height factor to control the depth of the curve
    path.quadraticBezierTo(228.5.w, 624.h, 430.w, 553.51.h);
    path.lineTo(430.w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class PaintTow extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0,
        553.5.h); // Adjust the height factor to control the depth of the curve
    path.quadraticBezierTo(220.49.w, 477.61.h, 430.w, 567.h);
    path.lineTo(430.w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class PaintThree extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(
        0, 567.h); // Adjust the height factor to control the depth of the curve
    path.quadraticBezierTo(219.5.w, 653.h, 430.w, 575.21.h);
    path.lineTo(430.w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
