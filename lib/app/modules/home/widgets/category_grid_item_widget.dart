// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../models/category_model.dart';
import '../../../routes/app_routes.dart';

class CategoryGridItemWidget extends StatelessWidget {
  final Category category;
  final String heroTag;

  const CategoryGridItemWidget(
      {super.key, required this.category, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(Routes.CATEGORY, arguments: category),
      borderRadius: BorderRadius.circular(12),
      splashColor: Get.theme.colorScheme.secondary.withOpacity(0.1),
      highlightColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: category.color!.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Category Icon / Image
            SizedBox(
              height: 50,
              child: category.image == null
                  ? const Icon(Icons.error_outline)
                  : category.image!.url.toLowerCase().endsWith('.svg')
                      ? SvgPicture.network(
                          category.image!.url,
                          color: category.color,
                        )
                      : CachedNetworkImage(
                          imageUrl: category.image!.url,
                          placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error_outline),
                        ),
            ),
            const SizedBox(height: 8),

            // Category Name
            Flexible(
              child: Text(
                category.name ?? '',
                style: Get.textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
