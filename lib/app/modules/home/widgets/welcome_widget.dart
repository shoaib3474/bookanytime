import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/auth_service.dart';
import '../../global_widgets/search_bar_widget.dart';
import '../controllers/home_controller.dart';

class WelcomeWidget extends StatelessWidget {
  WelcomeWidget({super.key});
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    final userName = Get.find<AuthService>().user.value.name ?? "Guest";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: theme.colorScheme.secondary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: "Welcome, ".tr,
                style:
                    theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
                children: [
                  TextSpan(
                    text: userName,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.primaryColor),
                  ),
                  TextSpan(
                    text: "!",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: theme.primaryColor),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Can I help you something?".tr,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.primaryColor),
            ),
            const SizedBox(height: 22),
            SearchBarWidget(),
          ],
        ),
      ),
    );
  }
}
