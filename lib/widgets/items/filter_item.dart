import 'package:donotnote/values/colors.dart';
import 'package:flutter/material.dart';

class FilterItem extends StatelessWidget {
  const FilterItem({
    Key? key,
    required this.text,
    required this.onTap,
    required this.isInList,
    this.isViewOnly = false,
  }) : super(key: key);
  final String text;
  final void Function(String) onTap;
  final bool isInList;
  final bool isViewOnly;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(26),
      onTap: isViewOnly
          ? null
          : () {
              onTap(text);
            },
      splashColor: !isInList
          ? KColors.kButtonColorGreen.withOpacity(0.5)
          : KColors.kPrimaryColor.withOpacity(0.5),
      hoverColor: KColors.kPrimaryColor,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 45,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(26),
            ),
            color: KColors.kTextColor,
            /* border: Border.all(
              color: isInList ? KColors.kButtonColorGreen : Colors.black,
              width: 2.5,
            ), */
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                offset: Offset.zero,
                spreadRadius: 3,
                color: KColors.kShadowColor,
              ),
            ]),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isInList ? KColors.kButtonColorGreen : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
