/*
 * File name: location_service.dart
 * Last modified: 2026.01.03
 * Author: BookAnytime
 * Purpose: Handle location permissions and current location retrieval
 */

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../common/ui.dart';

class LocationService extends GetxService {
  Future<LocationService> init() async {
    return this;
  }

  /// Request location permissions from the user
  Future<bool> requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      return result == LocationPermission.whileInUse ||
          result == LocationPermission.always;
    } else if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, open app settings
      await Geolocator.openLocationSettings();
      return false;
    }

    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Get the current location of the user
  Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await requestLocationPermission();

      if (!hasPermission) {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Location permission is required".tr));
        return null;
      }

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: "Please enable location services".tr));
        return null;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return position;
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "Error getting location: ${e.toString()}".tr));
      return null;
    }
  }
}
