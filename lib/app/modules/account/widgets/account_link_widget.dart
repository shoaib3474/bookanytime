import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountLinkWidget extends StatelessWidget {
  final Icon? icon;
  final Widget? text;
  final VoidCallback? onTap;

  const AccountLinkWidget({
    super.key,
    this.icon,
    this.text,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Row(
            children: [
              if (icon != null) icon!,
              if (icon != null) const SizedBox(width: 12),
              Expanded(
                child: text ?? const SizedBox(),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                // ignore: deprecated_member_use
                color: Get.theme.focusColor.withOpacity(0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
