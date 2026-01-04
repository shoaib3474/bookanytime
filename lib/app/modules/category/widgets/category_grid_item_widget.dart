// ignore_for_file: deprecated_member_use

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../routes/app_routes.dart';

class CategoryGridItemWidget extends StatelessWidget {
  final Category category;
  final String heroTag;

  const CategoryGridItemWidget({
    super.key,
    required this.category,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      splashColor: theme.colorScheme.primary.withOpacity(0.08),
      onTap: () {
        Get.toNamed(Routes.CATEGORY, arguments: category);
      },
      child: Container(
        decoration: Ui.getBoxDecoration(
          radius: 16,
          border: Border.all(color: theme.dividerColor.withOpacity(0.08)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Image / Icon section
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: category.color?.withOpacity(0.12),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Center(
                child: category.image == null
                    ? const Icon(Icons.broken_image_outlined)
                    : category.image!.url.toLowerCase().endsWith('.svg')
                        ? SvgPicture.network(
                            category.image!.url,
                            color: category.color,
                            height: 48,
                          )
                        : CachedNetworkImage(
                            imageUrl: category.image!.url,
                            height: 48,
                            fit: BoxFit.contain,
                            placeholder: (context, url) =>
                                Image.asset('assets/img/loading.gif'),
                            errorWidget: (_, __, ___) =>
                                const Icon(Icons.broken_image_outlined),
                          ),
              ),
            ),

            /// Text + sub categories
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
              child: Column(
                children: [
                  Text(
                    category.name ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if ((category.subCategories?.length ?? 0) > 0) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      alignment: WrapAlignment.center,
                      children: category.subCategories!
                          .take(3)
                          .map((sub) => GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.CATEGORY, arguments: sub);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.08),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    sub.name ?? '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
