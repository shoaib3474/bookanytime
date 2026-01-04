// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/salon_model.dart';

class SalonLevelBadgeWidget extends StatelessWidget {
  final Salon salon;

  const SalonLevelBadgeWidget({super.key, required this.salon});

  Color _getBadgeColor(String? levelName) {
    switch (levelName?.toLowerCase()) {
      case 'premium':
        return Colors.amber.shade700;
      case 'gold':
        return Colors.orange.shade600;
      case 'silver':
        return Colors.grey.shade400;
      default:
        return Get.theme.colorScheme.secondary.withOpacity(0.8);
    }
  }

  IconData _getBadgeIcon(String? levelName) {
    switch (levelName?.toLowerCase()) {
      case 'premium':
      case 'gold':
        return Icons.star;
      case 'silver':
        return Icons.star_border;
      default:
        return Icons.verified;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelName = salon.salonLevel?.name ?? '';

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: 1,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              _getBadgeColor(levelName).withOpacity(0.9),
              _getBadgeColor(levelName).withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: _getBadgeColor(levelName).withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getBadgeIcon(levelName),
              size: 14,
              color: Colors.white,
            ),
            const SizedBox(width: 6),
            Text(
              levelName,
              style: Get.textTheme.bodyMedium?.merge(
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
