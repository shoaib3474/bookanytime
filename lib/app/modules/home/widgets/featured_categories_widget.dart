import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/home_controller.dart';
import 'services_carousel_widget.dart';

class FeaturedCategoriesWidget extends GetWidget<HomeController> {
  const FeaturedCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Obx(() {
      if (controller.featured.isEmpty) {
        return CircularLoadingWidget(height: 300);
      }

      return Column(
        children: controller.featured.map((category) {
          final services = category.eServices ?? [];
          return Column(
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        category.name!,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.hintColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () =>
                          Get.toNamed(Routes.CATEGORY, arguments: category),
                      child: Text(
                        "See All".tr,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (services.isEmpty)
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                  child: Text(
                    "Mark services as featured to list them on the home screen"
                        .tr,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall,
                  ),
                )
              else
                ServicesCarouselWidget(services: services),
            ],
          );
        }).toList(),
      );
    });
  }
}
