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
import '../create_account/create_account.dart';

class AlwaysHere extends StatelessWidget {
  const AlwaysHere({super.key});

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

                        /// Navigation Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() => OnboardingDotNavigation(
                              activeIndex: onboardingController.currentIndex.value,
                            )),
                            SkipButton(
                              icon: Icons.chevron_left,
                              onPressed: () {
                                onboardingController.pageController.jumpToPage(0);
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 40),

                        /// Image stack
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              MainImageWithDecoration(imagePath: UImages.doctor),
                              OnboardingArc(),
                              OnboardingSmallDot(),
                              OverlayProfileImage(
                                imagePath: UImages.healthPro,
                                left: 250,
                                bottom: 20,
                              ),
                            ],
                          ),
                        ),

                        /// Spacer preserved for large screens
                        const Spacer(),

                        /// Title + Subtitle
                        OnboardingTitleSubtitle(
                          title: UTexts.onboardingThreeTitle,
                          subtitle: UTexts.onboardingThreeSubTitle,
                        ),
                        const SizedBox(height: 30),

                        /// Get Started Button
                        PrimaryButton(
                          text: 'Get Started',
                          onPressed: () {
                            onboardingController.nextPage();
                            Get.to(() => const CreateAccountScreen());
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
