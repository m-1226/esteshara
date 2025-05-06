import 'package:esteshara/core/utils/app_routers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionViewBody extends StatelessWidget {
  const IntroductionViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white, // Set explicitly to white
      bodyPadding: const EdgeInsets.only(
          top: 40, left: 20, right: 20), // Reduced padding
      showNextButton: true,
      showSkipButton: true,
      showDoneButton: false,
      dotsFlex: 2,
      dotsDecorator: DotsDecorator(
        size: const Size(10, 10),
        activeSize: const Size(24, 10),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        color: Colors.grey.shade300,
        activeColor: Theme.of(context).primaryColor,
        spacing: const EdgeInsets.symmetric(horizontal: 6),
      ),
      skip: _buildButtonText(context, "Skip"),
      next: _buildNextButton(context),

      onSkip: () => _navigateToLogin(context),
      onDone: () => _navigateToLogin(context),
      pages: _buildPages(context),
      animationDuration: 400,
    );
  }

  void _navigateToLogin(BuildContext context) async {
    await _markIntroAsSeen();
    context.go(AppRouters.kLoginView);
  }

  Future<void> _markIntroAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_intro', true);
  }

  Widget _buildButtonText(BuildContext context, String text) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        text,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: _buildButtonText(context, "Next"),
      ),
    );
  }

  List<PageViewModel> _buildPages(BuildContext context) {
    return [
      _buildFindSpecialistsPage(context),
      _buildExpertAdvicePage(context),
      _buildScheduleAppointmentsPage(context),
      _buildStartNowPage(context),
    ];
  }

  PageViewModel _buildFindSpecialistsPage(BuildContext context) {
    return PageViewModel(
      titleWidget: _buildTitle(context, "Find Verified Specialists"),
      bodyWidget: _buildBody(
        context,
        "Connect with top-rated specialists across multiple fields. Our platform ensures you have access to verified professionals when you need them most.",
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 20), // Reduced padding
        child: Lottie.asset(
          'assets/animations/search_doctor_animation.json',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
        ),
      ),
      decoration: _buildPageDecoration(),
    );
  }

  PageViewModel _buildExpertAdvicePage(BuildContext context) {
    return PageViewModel(
      titleWidget: _buildTitle(context, "Expert Advice On Demand"),
      bodyWidget: _buildBody(
        context,
        "Get personalized advice from experienced professionals in healthcare, business, career counseling, and more. Quality guidance at your fingertips.",
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 20), // Reduced padding
        child: Lottie.asset(
          'assets/animations/doctor_animation.json',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
        ),
      ),
      decoration: _buildPageDecoration(),
    );
  }

  PageViewModel _buildScheduleAppointmentsPage(BuildContext context) {
    return PageViewModel(
      titleWidget: _buildTitle(context, "Schedule With Ease"),
      bodyWidget: _buildBody(
        context,
        "Book appointments instantly with our simple scheduling system. View specialist availability in real-time and find slots that work for you.",
      ),
      image: Padding(
        padding: const EdgeInsets.only(top: 20), // Reduced padding
        child: Lottie.asset(
          'assets/animations/schedule.json',
          width: 280,
          height: 280,
          fit: BoxFit.contain,
        ),
      ),
      decoration: _buildPageDecoration(),
    );
  }

  PageViewModel _buildStartNowPage(BuildContext context) {
    return PageViewModel(
      titleWidget: _buildTitle(context, "Your Wellness Journey Starts Here"),
      bodyWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBody(
            context,
            "Join thousands of satisfied users who have found the perfect specialists for their needs. Your journey to better health and wellbeing begins now.",
          ),
          const SizedBox(height: 32),
          _buildGetStartedButton(context),
        ],
      ),
      // Removed the background container for illustration to match other pages
      image: Padding(
        padding: const EdgeInsets.only(top: 20), // Reduced padding
        child: Lottie.asset(
          'assets/animations/health_animation.json', // Replaced with Lottie animation
          width: 280,
          height: 280,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to icon if animation isn't available
            return Icon(
              Icons.health_and_safety,
              size: 120,
              color: Theme.of(context).primaryColor,
            );
          },
        ),
      ),
      decoration: _buildPageDecoration(),
    );
  }

  Widget _buildTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, top: 8), // Reduced padding
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        description,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.grey[700],
          height: 1.5,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () => _navigateToLogin(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.4),
        ),
        child: const Text(
          "Get Started Now",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  PageDecoration _buildPageDecoration() {
    return const PageDecoration(
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
      contentMargin: EdgeInsets.zero,
      bodyAlignment: Alignment.center,
      titlePadding: EdgeInsets.zero,
    );
  }
}
