// ignore_for_file: deprecated_member_use, no_leading_underscores_for_local_identifiers

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../routes/app_routes.dart';
import '../../global_widgets/duration_chip_widget.dart';

class ServicesCarouselWidget extends StatelessWidget {
  final List<EService> services;

  const ServicesCarouselWidget({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return SizedBox(
      height: 300,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(width: 20),
        itemBuilder: (_, index) {
          final _service = services[index];

          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.E_SERVICE, arguments: {
                'eService': _service,
                'heroTag': 'services_carousel'
              });
            },
            child: Container(
              width: 220,
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      imageUrl: _service.firstImageUrl,
                      placeholder: (_, __) => Image.asset(
                        'assets/img/loading.gif',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 130,
                      ),
                      errorWidget: (_, __, ___) => Icon(Icons.error_outline,
                          color: theme.colorScheme.error),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    height: 125,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(10)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _service.name ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(color: theme.hintColor),
                        ),
                        DurationChipWidget(duration: _service.duration!),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text("Start from".tr,
                                style: theme.textTheme.bodySmall),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (_service.getOldPrice > 0)
                                  Ui.getPrice(
                                    _service.getOldPrice,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                        color: theme.focusColor,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                Ui.getPrice(
                                  _service.getPrice,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.secondary),
                                ),
                              ],
                            ),
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
      ),
    );
  }
}
