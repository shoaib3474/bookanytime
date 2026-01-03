/*
 * File name: address_widget.dart
 * Last modified: 2023.01.26 at 18:24:51
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2023
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../routes/app_routes.dart';
import '../../services/location_service.dart';
import '../../services/settings_service.dart';
import '../../../common/ui.dart';

class AddressWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
      child: Row(
        children: [
          Icon(Icons.place_outlined),
          SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Get.toNamed(Routes.SETTINGS_ADDRESSES);
              },
              child: Obx(() {
                if (Get.find<SettingsService>().address.value.isUnknown()) {
                  return Text("Please choose your address".tr,
                      style: Get.textTheme.bodyLarge);
                }
                return Text(
                    Get.find<SettingsService>().address.value.address ?? '',
                    style: Get.textTheme.bodyLarge);
              }),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.gps_fixed),
            onPressed: () async {
              await _getCurrentLocation(context);
            },
          )
        ],
      ),
    );
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      Get.showSnackbar(Ui.defaultSnackBar(message: "Getting your location...".tr));

      Position? position =
          await Get.find<LocationService>().getCurrentLocation();

      if (position != null) {
        Get.find<SettingsService>().address.update((val) {
          val?.latitude = position.latitude;
          val?.longitude = position.longitude;
          val?.description = "My Current Location".tr;
        });

        Get.back();
        Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);

        Get.showSnackbar(
            Ui.SuccessSnackBar(message: "Location updated successfully".tr));
      }
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: "Error: ${e.toString()}".tr));
    }
  }
}
