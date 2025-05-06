import 'package:esteshara/core/services/setup_service_locator.dart';
import 'package:esteshara/core/utils/app_routers.dart';
import 'package:esteshara/core/utils/app_styles.dart';
import 'package:esteshara/core/widgets/custom_alert_dialog.dart';
import 'package:esteshara/features/auth/data/repos/auth/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final authRepo = getIt<AuthRepo>();

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CustomAlertDialog(
            title: 'هل تود تسجيل الخروج ؟',
            textBtn1: 'نعم',
            textBtn2: 'لا',
            onPressedBtn1: () {
              authRepo.signOut().then(
                    (value) => context.go(AppRouters.kLoginView),
                  );
            },
            onPressedBtn2: () {
              context.pop();
            },
          ),
        );
      },
      child: Row(
        children: [
          const Icon(
            Icons.logout_outlined,
            color: Colors.red,
          ),
          const Gap(10),
          Text(
            'Log Out',
            style: AppStyles.regular14.copyWith(
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
