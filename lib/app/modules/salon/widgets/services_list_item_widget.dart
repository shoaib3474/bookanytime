/*
 * File name: services_list_item_widget.dart
 * Last modified: 2023.01.26 at 18:27:05
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../global_widgets/duration_chip_widget.dart';
import '../controllers/salon_e_services_controller.dart';
import '../widgets/option_group_item_widget.dart';

class ServicesListItemWidget extends GetView<SalonEServicesController> {
  const ServicesListItemWidget({
    Key? key,
    required EService service,
  })  : _service = service,
        super(key: key);

  final EService _service;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Get.theme.colorScheme.secondary.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Obx(() {
            return GestureDetector(
              onTap: () {
                controller.selectEService(_service);
              },
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        Hero(
                          tag: 'salon_services_list_item' + (_service.id ?? ''),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            child: CachedNetworkImage(
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              imageUrl: _service.firstImageUrl,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            ),
                          ),
                        ),
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            color: Get.theme.colorScheme.secondary.withOpacity(
                                controller.isCheckedEService(_service)
                                    ? 0.7
                                    : 0),
                          ),
                          child: Icon(
                            Icons.check_circle,
                            size: 40,
                            color: Theme.of(context).primaryColor.withOpacity(
                                controller.isCheckedEService(_service) ? 1 : 0),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _service.name ?? '',
                                style: Get.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: controller.isCheckedEService(_service)
                                      ? Get.theme.colorScheme.secondary
                                      : Get.theme.hintColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 6),
                              if (_service.categories != null &&
                                  _service.categories!.isNotEmpty)
                                Text(
                                  _service.categories!
                                      .map((c) => c.name)
                                      .join(", "),
                                  style: Get.textTheme.bodySmall?.copyWith(
                                    color: Get.theme.hintColor.withOpacity(0.7),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_service.duration != null)
                                DurationChipWidget(
                                    duration: _service.duration!),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (_service.getOldPrice > 0)
                                    Ui.getPrice(
                                      _service.getOldPrice,
                                      style: Get.textTheme.bodySmall?.copyWith(
                                        color: Get.theme.hintColor,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  Ui.getPrice(
                                    _service.getPrice,
                                    style: Get.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Get.theme.colorScheme.secondary,
                                    ),
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
          }),
          if (_service.optionGroups != null &&
              _service.optionGroups!.isNotEmpty) ...[
            Divider(height: 1, thickness: 0.5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: ListView.separated(
                padding: EdgeInsets.all(0),
                itemBuilder: (context, index) {
                  return OptionGroupItemWidget(
                      optionGroup: _service.optionGroups!.elementAt(index),
                      eService: _service);
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemCount: _service.optionGroups!.length,
                primary: false,
                shrinkWrap: true,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
