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

class TrackSeizure extends StatelessWidget {
  const TrackSeizure({super.key});

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

                        /// Top Nav + Skip
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

                        /// Image Stack
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              MainImageWithDecoration(imagePath: UImages.motherAndChild),
                              OnboardingArc(),
                              OnboardingSmallDot(),
                              OverlayProfileImage(
                                imagePath: UImages.girlWithCurlyHair,
                                left: 150,
                                bottom: -23,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        /// Title and subtitle
                        OnboardingTitleSubtitle(
                          title: UTexts.onboardingTwoTitle,
                          subtitle: UTexts.onboardingTwoSubTitle,
                        ),
                        const SizedBox(height: 30),

                        /// Button
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
