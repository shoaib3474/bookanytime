import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../controllers/categories_controller.dart';
import '../widgets/category_grid_item_widget.dart';
import '../widgets/category_list_item_widget.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "Categories".tr,
          style:
              Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          await controller.refreshCategories(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: ListView(
          primary: true,
          children: [
            /// Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: HomeSearchBarWidget(),
            ),

            /// Header + Layout Toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Categories of services".tr,
                      style: Get.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(() {
                        return IconButton(
                          onPressed: () =>
                              controller.layout.value = CategoriesLayout.LIST,
                          icon: Icon(
                            Icons.format_list_bulleted,
                            color:
                                controller.layout.value == CategoriesLayout.LIST
                                    ? Get.theme.colorScheme.secondary
                                    : Get.theme.focusColor,
                          ),
                        );
                      }),
                      Obx(() {
                        return IconButton(
                          onPressed: () =>
                              controller.layout.value = CategoriesLayout.GRID,
                          icon: Icon(
                            Icons.apps,
                            color:
                                controller.layout.value == CategoriesLayout.GRID
                                    ? Get.theme.colorScheme.secondary
                                    : Get.theme.focusColor,
                          ),
                        );
                      }),
                    ],
                  )
                ],
              ),
            ),

            /// Grid Layout
            Obx(() {
              return Offstage(
                offstage: controller.layout.value != CategoriesLayout.GRID,
                child: controller.categories.isEmpty
                    ? CircularLoadingWidget(height: 400)
                    : MasonryGridView.count(
                        primary: false,
                        shrinkWrap: true,
                        crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 2
                            : 4,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        itemCount: controller.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          final _category =
                              controller.categories.elementAt(index);
                          return CategoryGridItemWidget(
                              category: _category, heroTag: "heroTag");
                        },
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                      ),
              );
            }),

            /// List Layout
            Obx(() {
              return Offstage(
                offstage: controller.layout.value != CategoriesLayout.LIST,
                child: controller.categories.isEmpty
                    ? CircularLoadingWidget(height: 400)
                    : ListView.separated(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        primary: false,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        itemCount: controller.categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final _category =
                              controller.categories.elementAt(index);
                          return CategoryListItemWidget(
                            heroTag: 'category_list',
                            expanded: index == 0, // Highlight first item
                            category: _category,
                          );
                        },
                      ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
