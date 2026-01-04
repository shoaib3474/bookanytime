// ignore_for_file: deprecated_member_use

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
    final theme = Get.theme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          Get.find<SettingsService>().setting.value.appName ?? "",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.sort_rounded, color: theme.hintColor),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.refreshHome(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: ListView(
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            const SizedBox(height: 8),

            /// Address
            AddressWidget(),

            /// Welcome
            WelcomeWidget(),

            /// Categories Header
            _SectionHeader(
              title: "Categories".tr,
              onViewAll: () {},
            ),

            /// Categories Carousel
            const CategoriesCarouselWidget(),

            const SizedBox(height: 16),

            /// Recommended Section (soft background)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.04),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                  bottom: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  _SectionHeader(
                    title: "Recommended for you".tr,
                    onViewAll: () {},
                  ),
                  RecommendedCarouselWidget(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Featured Categories
            FeaturedCategoriesWidget(),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Reusable modern section header
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onViewAll;

  const _SectionHeader({
    required this.title,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              shape: const StadiumBorder(),
            ),
            child: Text(
              "View All".tr,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
