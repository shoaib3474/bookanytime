/*
 * File name: custom_bottom_nav_bar.dart
 * Last modified: 2022.02.13 at 15:49:17
 * Author: SmarterVision - https://codecanyon.net/user/smartervision
 * Copyright (c) 2022
 */

import 'package:flutter/material.dart';

// ignore: constant_identifier_names
const Color PRIMARY_COLOR = Colors.blueAccent;
// ignore: constant_identifier_names
const Color BACKGROUND_COLOR = Color(0xffE2E7F2);

class CustomBottomNavigationBar extends StatefulWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomBottomNavigationItem> children;
  final Function(int) onChange;
  final int currentIndex;

  const CustomBottomNavigationBar(
      {super.key,
      this.backgroundColor = BACKGROUND_COLOR,
      this.itemColor = PRIMARY_COLOR,
      this.currentIndex = 0,
      required this.children,
      required this.onChange});

  @override
  // ignore: library_private_types_in_public_api
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _changeIndex(int index) {
    widget.onChange(index);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black12.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.children.map((item) {
            var color = item.color ?? widget.itemColor;
            var icon = item.icon;
            var label = item.label;
            int index = widget.children.indexOf(item);
            return GestureDetector(
              onTap: () {
                _changeIndex(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: widget.currentIndex == index
                    ? MediaQuery.of(context).size.width /
                            widget.children.length +
                        8
                    : 60,
                // padding:
                //     const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                margin:
                    const EdgeInsets.only(top: 8, bottom: 8, left: 4, right: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: widget.currentIndex == index
                        ? (item.color ?? widget.itemColor)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20)),
                child: widget.currentIndex == index
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            icon,
                            size: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 12),
                          ),
                        ],
                      )
                    : Icon(
                        icon,
                        size: 24,
                        color: color,
                      ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final IconData icon;
  final String label;
  final Color? color;

  CustomBottomNavigationItem(
      {required this.icon, required this.label, this.color});
}
