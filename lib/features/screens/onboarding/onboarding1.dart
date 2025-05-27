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
import 'onboarding2.dart';

class MeetUboho extends StatelessWidget {
  const MeetUboho({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final onboardingController = Get.find<OnboardingController>();

    return Scaffold(
      backgroundColor: UColors.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Top Row: Navigation dots + Skip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => OnboardingDotNavigation(
                        activeIndex: onboardingController.currentIndex.value,
                      )),


                      SkipButton(onPressed: () {
                        onboardingController.pageController.jumpToPage(2);
                      },),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Arc, Dot, Main Image, and Profile Image
                  Center(
                    child: Stack(
                      clipBehavior: Clip.none, // <- important to prevent clipping!
                      children: [
                        // Main Image
                        MainImageWithDecoration(imagePath: UImages.smileyBlackMan,),

                        // Arc PNG
                        OnboardingArc(),

                        // Small Dot
                        OnboardingSmallDot(),

                        // Smaller Profile Image
                        OverlayProfileImage(imagePath: UImages.smileyManWithGlasses,),
                      ],
                    ),
                  ),



                  const Spacer(),

                  // Title and subtitle
                  OnboardingTitleSubtitle(title: UTexts.onboardingOneTitle, subtitle: UTexts.onboardingOneSubTitle,),
                  const SizedBox(height: 30),

                  // Button
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
          ],
        ),
      ),
    );
  }
}
