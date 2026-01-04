// ignore_for_file: deprecated_member_use

/*
 * File name: category_list_item_widget.dart
 * Last modified: 2026.01.04
 * Author: Shoaib (Updated)
 * Description: Modern List Item with ExpansionTile, shadow, and rounded corners
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';
import '../../../routes/app_routes.dart';

class CategoryListItemWidget extends StatelessWidget {
  final Category category;
  final String heroTag;
  final bool expanded;

  const CategoryListItemWidget(
      {super.key,
      required this.category,
      required this.heroTag,
      required this.expanded});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: category.color!.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      child: Theme(
        data: Get.theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: expanded,
          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          title: InkWell(
            onTap: () => Get.toNamed(Routes.CATEGORY, arguments: category),
            highlightColor: Colors.transparent,
            splashColor: Get.theme.colorScheme.secondary.withOpacity(0.08),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: category.image == null
                      ? const Icon(Icons.error_outline)
                      : category.image!.url.toLowerCase().endsWith('.svg')
                          ? SvgPicture.network(category.image!.url,
                              color: category.color)
                          : CachedNetworkImage(
                              imageUrl: category.image!.url,
                              placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error_outline),
                            ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    category.name ?? '',
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          children: List.generate(category.subCategories?.length ?? 0, (index) {
            var sub = category.subCategories!.elementAt(index);
            return GestureDetector(
              onTap: () => Get.toNamed(Routes.CATEGORY, arguments: sub),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor.withOpacity(0.2),
                  border: Border(
                    top: BorderSide(
                        color:
                            Get.theme.scaffoldBackgroundColor.withOpacity(0.3)),
                  ),
                ),
                child: Text(
                  sub.name!,
                  style: Get.textTheme.bodyLarge,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
