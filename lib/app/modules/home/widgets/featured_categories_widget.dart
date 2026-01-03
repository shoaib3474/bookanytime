/*
 * File name: featured_categories_widget.dart
 * Last modified: 2023.01.26 at 18:30:21
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/home_controller.dart';
import 'services_carousel_widget.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.featured.isEmpty) {
        return CircularLoadingWidget(height: 300);
      }
      return Column(
        children: List.generate(controller.featured.length, (index) {
          var _category = controller.featured.elementAt(index);
          return Column(
            children: [
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _category.name!,
                        style: Get.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Get.theme.hintColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.CATEGORY, arguments: _category);
                      },
                      child: Text(
                        "See All".tr,
                        style: Get.textTheme.bodySmall?.copyWith(
                          color: Get.theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Obx(() {
                if (controller.featured.elementAt(index).eServices!.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 32),
                    child: Text(
                      "Mark services as featured to list them on the home screen"
                          .tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodySmall,
                    ),
                  );
                }
                return ServicesCarouselWidget(
                    services: controller.featured.elementAt(index).eServices!);
              }),
            ],
          );
        }),
      );
    });
  }
}
