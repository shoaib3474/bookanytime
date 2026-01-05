// Debug script to check map issues
// Add this temporarily to salon_details_view.dart to debug

// In the build method, add this debug info:
Widget debugMapInfo() {
  final settingsService = Get.find<SettingsService>();
  return Column(
    children: [
      Text('API Key: ${settingsService.setting.value.googleMapsKey ?? "NULL"}'),
      Text('Address: ${controller.salon.value.address?.toString() ?? "NULL"}'),
      if (controller.salon.value.address != null)
        Text('LatLng: ${controller.salon.value.address!.getLatLng()}'),
    ],
  );
}

// Add this before the map widget to see what's happening:
// debugMapInfo(),