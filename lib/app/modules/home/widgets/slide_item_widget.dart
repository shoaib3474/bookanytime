/*
 * File name: slide_item_widget.dart
 * Last modified: 2023.01.26 at 18:26:28
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

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
    return Stack(
      children: [
        Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(
              Directionality.of(context) == TextDirection.rtl ? math.pi : 0),
          child: CachedNetworkImage(
            width: double.infinity,
            height: 310,
            fit: Ui.getBoxFit(slide.imageFit),
            imageUrl: slide.image.url,
            placeholder: (context, url) => Image.asset(
              'assets/img/loading.gif',
              fit: BoxFit.cover,
              width: double.infinity,
            ),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error_outline),
          ),
        ),
        Container(
            alignment: Ui.getAlignmentDirectional(slide.textPosition),
            width: double.infinity,
            height: 240,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: SizedBox(
              width: Get.width / 2.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment:
                    Ui.getCrossAxisAlignment(slide.textPosition),
                children: [
                  if (slide.text != '')
                    Flexible(
                      child: Text(
                        slide.text,
                        style: Get.textTheme.bodyMedium!
                            .merge(TextStyle(color: slide.textColor)),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  if (slide.text != '') const SizedBox(height: 8),
                  if (slide.button != '')
                    MaterialButton(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 16),
                      color: slide.buttonColor,
                      shape: const StadiumBorder(),
                      elevation: 0,
                      child: Text(
                        slide.button,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Get.theme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            )),
      ],
    );
  }
}
