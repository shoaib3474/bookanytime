import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/account_controller.dart';
import '../widgets/account_link_widget.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    final _currentUser = Get.find<AuthService>().user;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Get.theme.colorScheme.secondary,
        title: Text(
          "Account".tr,
          style: Get.textTheme.titleLarge
              ?.copyWith(color: context.theme.primaryColor),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.sort, color: context.theme.primaryColor),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          NotificationsButtonWidget(
            iconColor: context.theme.primaryColor,
            labelColor: context.theme.hintColor,
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Obx(() {
            return Container(
              padding: const EdgeInsets.only(top: 20, bottom: 60),
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
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 20),
                          Text(
                            _currentUser.value.name ?? "",
                            style: Get.textTheme.titleLarge
                                ?.copyWith(color: context.theme.primaryColor),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _currentUser.value.email ?? "",
                            style: Get.textTheme.bodySmall
                                ?.copyWith(color: context.theme.primaryColor),
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          decoration: Ui.getBoxDecoration(
                            radius: 50,
                            border: Border.all(
                                width: 5, color: context.theme.primaryColor),
                          ),
                          child: ClipOval(
                            child: CachedNetworkImage(
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              imageUrl: _currentUser.value.avatar.thumb,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error_outline, size: 100),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          // 🔹 Profile & Bookings Section
          _buildAccountSection(
            [
              AccountLinkWidget(
                icon: Icon(Icons.person_outline,
                    color: Get.theme.colorScheme.secondary),
                text: Text("Profile".tr),
                onTap: () => Get.toNamed(Routes.PROFILE),
              ),
              AccountLinkWidget(
                icon: Icon(Icons.assignment_outlined,
                    color: Get.theme.colorScheme.secondary),
                text: Text("My Bookings".tr),
                onTap: () => Get.find<RootController>().changePage(1),
              ),
              AccountLinkWidget(
                icon: Icon(Icons.notifications_outlined,
                    color: Get.theme.colorScheme.secondary),
                text: Text("Notifications".tr),
                onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
              ),
              AccountLinkWidget(
                icon: Icon(Icons.chat_outlined,
                    color: Get.theme.colorScheme.secondary),
                text: Text("Messages".tr),
                onTap: () => Get.find<RootController>().changePage(2),
              ),
            ],
          ),

          // 🔹 Settings Section
          _buildAccountSection(
            [
              AccountLinkWidget(
                icon: Icon(Icons.settings_outlined,
                    color: Get.theme.colorScheme.secondary),
                text: Text("Settings".tr),
                onTap: () => Get.toNamed(Routes.SETTINGS),
              ),
              AccountLinkWidget(
                icon: Icon(Icons.translate_outlined,
                    color: Get.theme.colorScheme.secondary),
                text: Text("Languages".tr),
                onTap: () => Get.toNamed(Routes.SETTINGS_LANGUAGE),
              ),
              AccountLinkWidget(
                icon: Icon(Icons.brightness_6_outlined,
                    color: Get.theme.colorScheme.secondary),
                text: Text("Theme Mode".tr),
                onTap: () => Get.toNamed(Routes.SETTINGS_THEME_MODE),
              ),
            ],
          ),

          // 🔹 Support & Logout Section
          _buildAccountSection(
            [
              AccountLinkWidget(
                icon: Icon(Icons.support_outlined,
                    color: Get.theme.colorScheme.secondary),
                text: Text("Help & FAQ".tr),
                onTap: () => Get.toNamed(Routes.HELP),
              ),
              AccountLinkWidget(
                icon:
                    Icon(Icons.logout, color: Get.theme.colorScheme.secondary),
                text: Text("Logout".tr),
                onTap: () async {
                  await Get.find<AuthService>().removeCurrentUser();
                  Get.find<RootController>().changePage(0);
                },
              ),
            ],
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // 🔹 Helper to create a card section
  Widget _buildAccountSection(List<AccountLinkWidget> links) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: Ui.getBoxDecoration(),
      child: Column(
        children: links
            .map((widget) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: widget,
                ))
            .toList(),
      ),
    );
  }
}
