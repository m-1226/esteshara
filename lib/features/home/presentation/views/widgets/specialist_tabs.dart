import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/features/home/data/models/specialist_model.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_about_tab.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_experience_tab.dart';
import 'package:esteshara/features/home/presentation/views/widgets/specialist_reviews_tab.dart';
import 'package:flutter/material.dart';

class SpecialistTabs extends StatefulWidget {
  final SpecialistModel specialist;

  const SpecialistTabs({
    super.key,
    required this.specialist,
  });

  @override
  State<SpecialistTabs> createState() => _SpecialistTabsState();
}

class _SpecialistTabsState extends State<SpecialistTabs>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TabBar(
          labelColor: Theme.of(context).primaryColor,
          labelStyle: AppStyles.bold16,
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle: AppStyles.regular16,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'About'),
            Tab(text: 'Experience'),
            Tab(text: 'Reviews'),
          ],
        ),
        const Divider(),
        Flexible(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              SpecialistAboutTab(specialist: widget.specialist),
              const SpecialistExperienceTab(),
              SpecialistReviewsTab(specialist: widget.specialist),
            ],
          ),
        ),
      ],
    );
  }
}
