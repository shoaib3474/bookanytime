/*
 * File name: home2_view.dart
 * Last modified: 2023.01.26 at 18:30:21
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/slide_model.dart';
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
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Get.theme.primaryColor,
                expandedHeight: 240,
                pinned: true,
                floating: true,
                elevation: 0,
                iconTheme: IconThemeData(color: Get.theme.hintColor),
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(Icons.menu, color: Get.theme.hintColor),
                  onPressed: () => {Scaffold.of(context).openDrawer()},
                ),
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          /// Greeting with user name
                          Obx(() {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                "Welcome, ${Get.find<AuthService>().user.value.name ?? 'Guest'}"
                                    .tr,
                                style: Get.textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Get.theme.hintColor,
                                ),
                              ),
                            );
                          }),

                          /// Address Widget
                          AddressWidget(),

                          const SizedBox(height: 12),

                          /// Search bar
                          HomeSearchBarWidget(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      /// Categories Section
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
                                  color: Get.theme.hintColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.CATEGORIES);
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
                      CategoriesCarouselWidget(),

                      const SizedBox(height: 20),

                      /// Promotional Banner Carousel
                      Obx(() {
                        if (controller.slider.isEmpty) {
                          return const SizedBox(height: 0);
                        }
                        return Column(
                          children: [
                            CarouselSlider(
                              options: CarouselOptions(
                                autoPlay: true,
                                autoPlayInterval: const Duration(seconds: 7),
                                autoPlayAnimationDuration:
                                    const Duration(milliseconds: 800),
                                autoPlayCurve: Curves.fastOutSlowIn,
                                pauseAutoPlayOnTouch: true,
                                aspectRatio: 16 / 9,
                                viewportFraction: 0.9,
                                height: 180,
                                onPageChanged: (index, reason) {
                                  controller.currentSlide.value = index;
                                },
                              ),
                              items: controller.slider.map((Slide slide) {
                                return SlideItemWidget(slide: slide);
                              }).toList(),
                            ),
                            const SizedBox(height: 12),
                            Obx(() {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  controller.slider.length,
                                  (index) => Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          controller.currentSlide.value == index
                                              ? Get.theme.colorScheme.secondary
                                              : Get.theme.colorScheme.secondary
                                                  .withOpacity(0.4),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        );
                      }).paddingSymmetric(horizontal: 0, vertical: 8),

                      const SizedBox(height: 20),

                      /// Featured for you Section
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
                                  color: Get.theme.hintColor,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.MAPS);
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
                      RecommendedCarouselWidget(),

                      const SizedBox(height: 20),

                      FeaturedCategoriesWidget(),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
