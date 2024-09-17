import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class OnboardingConfig {
  static final List<String> onboardingImages = [
    "assets/images/onboarding_1.png",
    "assets/images/onboarding_2.png",
    "assets/images/onboarding_3.png",
  ];
  static final List<String> onboardingPage = [
    "assets/images/page_1.svg",
    "assets/images/page_2.svg",
    "assets/images/page_3.svg",
  ];

  static List<String> getTitleText(BuildContext context) {
    final l10n = S.of(context);
    return [
      l10n.onboardingTitle1,
      l10n.onboardingTitle2,
      l10n.onboardingTitle3,
    ];
  }

  static List<String> getSubTitleText(BuildContext context) {
    final l10n = S.of(context);
    return [
      l10n.onboardingSubtitle1,
      l10n.onboardingSubtitle2,
      l10n.onboardingSubtitle3,
    ];
  }
}
