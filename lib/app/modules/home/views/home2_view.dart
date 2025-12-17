/*
 * File name: home2_view.dart
 * Last modified: 2023.01.26 at 18:30:21
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../providers/laravel_provider.dart';
import '../../../routes/app_routes.dart';
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
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                expandedHeight: 240,
                elevation: 0,
                floating: true,
                pinned: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
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
                bottom: HomeSearchBarWidget(),
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Stack(
                        alignment: controller.slider.isEmpty
                            ? AlignmentDirectional.center
                            : Ui.getAlignmentDirectional(controller.slider
                                .elementAt(controller.currentSlide.value)
                                .textPosition),
                        children: <Widget>[
                          CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 7),
                              height: 240,
                              viewportFraction: 0.95,
                              padEnds: true,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                controller.currentSlide.value = index;
                              },
                            ),
                            items: controller.slider.map((Slide slide) {
                              return SlideItemWidget(slide: slide);
                            }).toList(),
                          ),
                          Positioned(
                            bottom: 02,
                            left: Get.width / 2 -
                                (controller.slider.length * 12) / 2,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: controller.slider.map((Slide slide) {
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: controller.currentSlide.value ==
                                              controller.slider.indexOf(slide)
                                          ? slide.indicatorColor
                                          : slide.indicatorColor
                                              // ignore: deprecated_member_use
                                              .withOpacity(0.3)),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ).marginOnly(bottom: 0),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    AddressWidget().paddingAll(15),
                    Container(
                      color: Get.theme.colorScheme.secondary.withOpacity(0.05),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Recommended for you".tr,
                                  style: Get.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
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
                    const SizedBox(height: 10),
                    Container(
                      color: Get.theme.colorScheme.secondary.withOpacity(0.05),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text("Categories".tr,
                                  style: Get.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.w600))),
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
                    const SizedBox(height: 10),
                    FeaturedCategoriesWidget(),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
