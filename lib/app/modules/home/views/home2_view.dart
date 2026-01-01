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
                backgroundColor: Colors.amber,
                expandedHeight: 300,
                pinned: true,
                floating: false,
                elevation: 0,
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
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  background: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 56, 8, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Greeting
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Hello, Abhishek",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          /// Location
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,
                                    color: Colors.white70, size: 18),
                                SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    "3J67+RCP, Tulsi Marg, near Ess...",
                                    style: TextStyle(color: Colors.white70),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    color: Colors.white),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Search bar
                          HomeSearchBarWidget(),

                          const SizedBox(height: 6),

                          /// Categories
                          CategoriesCarouselWidget(),
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
                      AddressWidget().paddingSymmetric(horizontal: 16),
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
                      const SizedBox(height: 20),
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
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
