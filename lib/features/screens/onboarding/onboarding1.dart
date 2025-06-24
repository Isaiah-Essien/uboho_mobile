import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utiils/constants/colors.dart';
import '../../../utiils/constants/image_strings.dart';
import '../../../utiils/constants/text_strings.dart';
import '../../controllers/onboarding_controller.dart';
import '../../reuseable_widgets/arc_and_dot.dart';
import '../../reuseable_widgets/onboarding_dot_nav.dart';
import '../../reuseable_widgets/onboarding_main_image.dart';
import '../../reuseable_widgets/onboarding_overlay_small_image.dart';
import '../../reuseable_widgets/onboarding_skip.dart';
import '../../reuseable_widgets/onboarding_title_subtitle.dart';
import '../../reuseable_widgets/primary_button.dart';

class MeetUboho extends StatelessWidget {
  const MeetUboho({super.key});

  @override
  Widget build(BuildContext context) {
    final onboardingController = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        /// Top Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => OnboardingDotNavigation(
                              activeIndex: onboardingController.currentIndex.value,
                            )),
                            SkipButton(
                              onPressed: () {
                                onboardingController.pageController.jumpToPage(2);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        /// Main Image Stack
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              MainImageWithDecoration(imagePath: UImages.smileyBlackMan),
                              OnboardingArc(),
                              OnboardingSmallDot(),
                              OverlayProfileImage(imagePath: UImages.smileyManWithGlasses),
                            ],
                          ),
                        ),

                        const Spacer(),

                        /// Title, Subtitle, Button
                        OnboardingTitleSubtitle(
                          title: UTexts.onboardingOneTitle,
                          subtitle: UTexts.onboardingOneSubTitle,
                        ),
                        const SizedBox(height: 30),

                        PrimaryButton(
                          text: 'Next',
                          onPressed: () {
                            onboardingController.nextPage();
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
