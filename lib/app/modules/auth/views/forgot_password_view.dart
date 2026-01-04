// ignore_for_file: deprecated_member_use

import 'package:bookanytime/app/modules/root/controllers/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    controller.forgotPasswordFormKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        title: Text(
          "Forgot Password".tr,
          textAlign: TextAlign.center,
          style: Get.textTheme.titleLarge?.copyWith(
            color: Get.theme.primaryColor.withOpacity(0.8),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Get.find<RootController>().changePageOutRoot(0),
        ),
      ),
      body: Form(
        key: controller.forgotPasswordFormKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 🔹 Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Get.theme.focusColor.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _settings.appName ?? "",
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontSize: 22,
                      color: context.theme.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Enter your email to receive a password reset link".tr,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: context.theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Form Card
            Obx(() {
              if (controller.loading.isTrue) {
                return CircularLoadingWidget(height: 250);
              }

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "Email Address".tr,
                        hintText: "johndoe@gmail.com".tr,
                        initialValue: controller.currentUser.value.email,
                        onSaved: (input) =>
                            controller.currentUser.value.email = input,
                        validator: (input) => !GetUtils.isEmail(input ?? '')
                            ? "Should be a valid email".tr
                            : null,
                        iconData: Icons.alternate_email,
                      ),
                      const SizedBox(height: 25),
                      BlockButtonWidget(
                        onPressed: controller.sendResetLink,
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "Send Reset Link".tr,
                          style: Get.textTheme.titleMedium?.copyWith(
                            color: context.theme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 25),

            // 🔹 Footer Links
            Column(
              children: [
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.REGISTER);
                  },
                  child: Text("You don't have an account?".tr),
                ),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Text("You remember my password!".tr),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
