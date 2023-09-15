import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/strings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final void Function(int pageIndex) onTap;
  final int pageIndex;
  const MyBottomNavigationBar({
    Key? key,
    required this.onTap,
    required this.pageIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: const BoxDecoration(
        color: KColors.kPrimaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            color: Colors.black,
            spreadRadius: 2,
            offset: Offset(0, 15),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          gap: 8,
          activeColor: KColors.kWhiteColor,
          iconSize: 24,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: KColors.kButtonColorPurple,
          color: KColors.kButtonColorGreen,
          tabs: const [
            GButton(
              icon: Icons.assignment_ind_rounded,
              text: Strings.account,
            ),
            GButton(
              icon: Icons.home_rounded,
              text: Strings.home,
            ),
            GButton(
              icon: Icons.app_registration_rounded,
              text: Strings.add,
            ),
          ],
          selectedIndex: pageIndex,
          onTabChange: onTap,
        ),
      ),
    );
  }
}
