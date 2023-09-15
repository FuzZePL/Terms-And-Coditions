import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:flutter/material.dart';

class TextFieldContainer extends StatelessWidget {
  final Widget child;
  const TextFieldContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(10)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenHeight(5),
      ),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: KColors.kTextFieldColor,
        borderRadius: BorderRadius.circular(29),
        boxShadow: [ConstantFunctions.defaultLightShadow()],
      ),
      child: child,
    );
  }
}
