import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/home_controller.dart';
import 'category_grid_item_widget.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  const CategoriesCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return CircularLoadingWidget(height: 280);
      }

      return GridView.builder(
        controller: ScrollController(keepScrollOffset: false),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        itemCount: controller.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? 4
                  : 6,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          return CategoryGridItemWidget(
            category: controller.categories[index],
            heroTag: 'category_$index',
          );
        },
      );
    });
  }
}
