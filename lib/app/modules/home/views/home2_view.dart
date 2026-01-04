// ignore_for_file: deprecated_member_use

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/home_controller.dart';
import '../widgets/categories_carousel_widget.dart';
import '../widgets/featured_categories_widget.dart';
import '../widgets/recommended_carousel_widget.dart';
import '../widgets/slide_item_widget.dart';

class Home2View extends GetView<HomeController> {
  const Home2View({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          await controller.refreshHome(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: theme.primaryColor,
              expandedHeight: 240,
              pinned: true,
              floating: true,
              elevation: 0,
              iconTheme: IconThemeData(color: theme.hintColor),
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: Icon(Icons.menu, color: theme.hintColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  Get.find<SettingsService>().setting.value.appName ?? "",
                  style: Get.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              centerTitle: false,
              actions: const [NotificationsButtonWidget()],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 56, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Welcome, ${Get.find<AuthService>().user.value.name ?? 'Guest'}"
                                  .tr,
                              style: Get.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                        ),
                        AddressWidget(),
                        const SizedBox(height: 12),
                        HomeSearchBarWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// Categories Section
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Categories".tr,
                            style: Get.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.CATEGORIES),
                          child: Text(
                            "See All".tr,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const CategoriesCarouselWidget(),

                  const SizedBox(height: 20),

                  /// Slider / Banner Section
                  Obx(() {
                    if (controller.slider.isEmpty)
                      return const SizedBox.shrink();

                    return Column(
                      children: [
                        CarouselSlider.builder(
                          itemCount: controller.slider.length,
                          itemBuilder: (context, index, realIdx) =>
                              SlideItemWidget(slide: controller.slider[index]),
                          options: CarouselOptions(
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 7),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            viewportFraction: 0.9,
                            aspectRatio: 16 / 9,
                            height: 180,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              controller.currentSlide.value = index;
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              controller.slider.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.currentSlide.value == index
                                      ? theme.colorScheme.secondary
                                      : theme.colorScheme.secondary
                                          .withOpacity(0.4),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).paddingSymmetric(horizontal: 0, vertical: 8),

                  const SizedBox(height: 20),

                  /// Recommended Section
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Featured for you".tr,
                            style: Get.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.hintColor,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.MAPS),
                          child: Text(
                            "See All".tr,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RecommendedCarouselWidget(),

                  const SizedBox(height: 20),
                  FeaturedCategoriesWidget(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
