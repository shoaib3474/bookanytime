import 'package:bookanytime/app/modules/root/controllers/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/helper.dart';
import '../../../models/setting_model.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class PhoneVerificationView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: Get.theme.colorScheme.secondary,
          title: Text(
            "Phone Verification".tr,
            textAlign: TextAlign.center,
            style: Get.textTheme.titleLarge?.copyWith(
              // ignore: deprecated_member_use
              color: Get.theme.primaryColor.withOpacity(0.8),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Get.find<RootController>().changePageOutRoot(0),
          ),
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 🔹 Header with logo & app name
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
                    "Enter the OTP sent to your phone".tr,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: context.theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 OTP Input & Verify Button
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
                      Text(
                        "We sent the OTP code to your phone, please check it and enter below"
                            .tr,
                        style: Get.textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 25),
                      TextFieldWidget(
                        labelText: "OTP Code".tr,
                        hintText: "- - - - - -".tr,
                        style: Get.textTheme.headlineMedium
                            ?.copyWith(letterSpacing: 8),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        onChanged: (input) => controller.smsSent.value = input,
                      ),
                      const SizedBox(height: 25),
                      BlockButtonWidget(
                        onPressed: () async {
                          await controller.verifyPhone();
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "Verify".tr,
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

            const SizedBox(height: 20),

            // 🔹 Resend OTP
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    controller.resendOTPCode();
                  },
                  child: Text("Resend the OTP Code Again".tr),
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
