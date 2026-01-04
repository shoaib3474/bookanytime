// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/slide_model.dart';
import '../../../routes/app_routes.dart';

class SlideItemWidget extends StatelessWidget {
  final Slide slide;

  const SlideItemWidget({
    required this.slide,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;

    return Stack(
      children: [
        /// Background Image
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(
              Directionality.of(context) == TextDirection.rtl ? math.pi : 0),
          child: CachedNetworkImage(
            width: double.infinity,
            height: 310,
            fit: Ui.getBoxFit(slide.imageFit),
            imageUrl: slide.image.url,
            placeholder: (context, url) =>
                Image.asset('assets/img/loading.gif', fit: BoxFit.cover),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline),
          ),
        ),

        /// Text & Button Overlay
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(16),
            color: Colors.black.withOpacity(0.25), // soft overlay for text
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: Ui.getCrossAxisAlignment(slide.textPosition),
              children: [
                if (slide.text != '')
                  Text(
                    slide.text,
                    style: Get.textTheme.bodyMedium!.merge(
                      TextStyle(
                        color: slide.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                if (slide.text != '') const SizedBox(height: 8),
                if (slide.button != '')
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: slide.buttonColor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        textStyle: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () {
                        if (slide.salon.hasData) {
                          Get.toNamed(Routes.SALON, arguments: {
                            'salon': slide.salon,
                            'heroTag': 'salon_slide_item'
                          });
                        } else if (slide.eService.hasData) {
                          Get.toNamed(Routes.E_SERVICE, arguments: {
                            'eService': slide.eService,
                            'heroTag': 'slide_item'
                          });
                        }
                      },
                      child: Text(
                        slide.button,
                        style: TextStyle(color: theme.primaryColor),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
