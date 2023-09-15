import 'package:donotnote/values/colors.dart';
import 'package:flutter/material.dart';

class SpacerBar extends StatelessWidget {
  const SpacerBar({
    super.key,
    required this.size,
    required this.text,
    required this.weight,
  });

  final Size size;
  final String text;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(right: 8, left: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: KColors.kPrimaryColor,
              ),
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: weight, color: KColors.kTextColor),
          ),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.only(left: 8, right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: KColors.kPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
