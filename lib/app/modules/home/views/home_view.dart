// ignore_for_file: deprecated_member_use

/*
 * File name: home_view.dart
 * Last modified: 2023.01.26 at 18:30:21
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/address_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/welcome_widget.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          Get.find<SettingsService>().setting.value.appName ?? "",
          style: Get.textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: ListView(
            primary: true,
            shrinkWrap: true,
            children: [
              AddressWidget(),
              WelcomeWidget(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Text("Categories".tr,
                            style: Get.textTheme.headlineSmall)),
                    MaterialButton(
                      onPressed: () {},
                      shape: const StadiumBorder(),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                      elevation: 0,
                      child:
                          Text("View All".tr, style: Get.textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
              CategoriesCarouselWidget(),
              Container(
                color: Get.theme.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                        child: Text("Recommended for you".tr,
                            style: Get.textTheme.headlineSmall)),
                    MaterialButton(
                      onPressed: () {},
                      shape: const StadiumBorder(),
                      color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                      elevation: 0,
                      child:
                          Text("View All".tr, style: Get.textTheme.titleMedium),
                    ),
                  ],
                ),
              ),
              RecommendedCarouselWidget(),
              FeaturedCategoriesWidget(),
            ],
          )),
    );
  }
}
