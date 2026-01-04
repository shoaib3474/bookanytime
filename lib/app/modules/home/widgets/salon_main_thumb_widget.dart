import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/salon_model.dart';
import 'salon_level_badge_widget.dart';

class SalonMainThumbWidget extends StatelessWidget {
  final Salon salon;

  const SalonMainThumbWidget({super.key, required this.salon});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Stack(
      children: [
        Hero(
          tag: 'recommended_carousel_${salon.id}',
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: CachedNetworkImage(
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              imageUrl: salon.firstImageUrl,
              placeholder: (_, __) => Image.asset(
                'assets/img/loading.gif',
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
              errorWidget: (_, __, ___) =>
                  Icon(Icons.error_outline, color: theme.colorScheme.error),
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: SalonLevelBadgeWidget(salon: salon),
        ),
      ],
    );
  }
}
