// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../common/map.dart';
import '../../../../common/ui.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/salon_availability_badge_widget.dart';
import '../controllers/salon_controller.dart';
import '../widgets/availability_hour_item_widget.dart';
import '../widgets/salon_til_widget.dart';

class SalonDetailsView extends GetView<SalonController> {
  const SalonDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final salon = controller.salon.value;
      return Wrap(
        children: [
          // Description Card
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description".tr, style: Get.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Ui.applyHtml(salon.description,
                      style: Get.textTheme.bodyMedium),
                ],
              ),
            ),
          ),

          // Contact Card
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Contact us".tr, style: Get.textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text("If you have any question!".tr,
                            style: Get.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildIconButton(
                        icon: Icons.phone_android_outlined,
                        color: Get.theme.colorScheme.secondary,
                        onPressed: () =>
                            launchUrlString("tel:${salon.mobileNumber}"),
                      ),
                      _buildIconButton(
                        icon: Icons.call_outlined,
                        color: Get.theme.colorScheme.secondary,
                        onPressed: () =>
                            launchUrlString("tel:${salon.phoneNumber}"),
                      ),
                      _buildIconButton(
                        icon: Icons.chat_outlined,
                        color: Get.theme.colorScheme.secondary,
                        onPressed: controller.startChat,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Address / Map Card
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: (salon.address == null)
                ? Shimmer.fromColors(
                    baseColor: Colors.grey.withOpacity(0.15),
                    highlightColor: Colors.grey[200]!.withOpacity(0.1),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12)),
                        child:
                            MapsUtil.getStaticMaps(salon.address!.getLatLng()),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Location".tr,
                                      style: Get.textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  Text(salon.address!.address ?? '',
                                      style: Get.textTheme.bodySmall),
                                ],
                              ),
                            ),
                            MaterialButton(
                              onPressed: () => MapsUtil.openMapsSheet(context,
                                  salon.address!.getLatLng(), salon.name!),
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(0.2),
                              padding: EdgeInsets.zero,
                              minWidth: 44,
                              height: 44,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Icon(Icons.directions_outlined,
                                  color: Get.theme.colorScheme.secondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),

          // Availability Hours
          SalonTilWidget(
            title: Text("Availability".tr, style: Get.textTheme.titleMedium),
            content: (salon.availabilityHours?.isEmpty ?? true)
                ? CircularLoadingWidget(height: 150)
                : ListView.separated(
                    padding: EdgeInsets.zero,
                    primary: false,
                    shrinkWrap: true,
                    itemCount: salon.groupedAvailabilityHours().entries.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 16, thickness: 0.8),
                    itemBuilder: (_, index) {
                      var entry = salon
                          .groupedAvailabilityHours()
                          .entries
                          .elementAt(index);
                      var data = salon.getAvailabilityHoursData(entry.key);
                      return AvailabilityHourItemWidget(
                          availabilityHour: entry, data: data);
                    },
                  ),
            actions: [SalonAvailabilityBadgeWidget(salon: salon)],
          ),
        ],
      );
    });
  }

  Widget _buildIconButton(
      {required IconData icon,
      required Color color,
      required VoidCallback onPressed}) {
    return MaterialButton(
      onPressed: onPressed,
      height: 44,
      minWidth: 44,
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: color.withOpacity(0.2),
      elevation: 0,
      child: Icon(icon, color: color),
    );
  }
}
