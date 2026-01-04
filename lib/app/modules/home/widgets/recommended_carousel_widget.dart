// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/salon_availability_badge_widget.dart';
import '../controllers/home_controller.dart';
import 'salon_main_thumb_widget.dart';
import 'salon_thumbs_widget.dart';

class RecommendedCarouselWidget extends GetWidget<HomeController> {
  const RecommendedCarouselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return SizedBox(
      height: 375,
      child: Obx(() {
        if (controller.salons.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: controller.salons.length,
          separatorBuilder: (_, __) => const SizedBox(width: 20),
          itemBuilder: (_, index) {
            // ignore: no_leading_underscores_for_local_identifiers
            final _salon = controller.salons[index];

            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.SALON, arguments: {
                  'salon': _salon,
                  'heroTag': 'recommended_carousel'
                });
              },
              child: Container(
                width: 280,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.focusColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SalonMainThumbWidget(salon: _salon),
                    const SizedBox(height: 4),
                    SalonThumbsWidget(salon: _salon),
                    Container(
                      padding: const EdgeInsets.all(12),
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.primaryColor,
                        borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(10)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            _salon.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium
                                ?.copyWith(color: theme.hintColor),
                          ),
                          Text(
                            Ui.getDistance(_salon.distance!) ?? '',
                            style: theme.textTheme.bodySmall,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: Ui.getStarsList(_salon.rate)),
                              SalonAvailabilityBadgeWidget(salon: _salon),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
