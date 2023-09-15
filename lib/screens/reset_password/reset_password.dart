import 'package:flutter/material.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';
import 'package:donotnote/widgets/buttons/default_button.dart';
import 'package:donotnote/widgets/text_fields/rounded_input_field.dart';

class ResetPassword extends StatefulWidget {
  static const String routeName = '/resetPassword';
  const ResetPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  final double _defaultSize = SizeConfig.defaultSize!;

  void _onTap() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Server.resetPassword(_email);
      ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
          KColors.kTextColor, Strings.followEmail);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          Strings.resetPassword12,
          style: TextStyle(
            color: KColors.kWhiteColor,
          ),
        ),
        elevation: 2,
        backgroundColor: KColors.kPrimaryColor,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: KColors.kWhiteColor,
          ),
        ),
      ),
      body: Container(
        color: KColors.kBackgroundColor,
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedInputField(
                    key: const ValueKey('resetPassword'),
                    hintText: Strings.email,
                    icon: Icons.email,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    type: 'Email',
                    onSaved: (value) {
                      if (value != null) {
                        _email = value;
                      }
                    },
                    textInputAction: TextInputAction.done,
                    inputType: TextInputType.emailAddress,
                    isPassword: false,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  DefaultButton(
                    defaultSize: _defaultSize,
                    text: Strings.toNextStep,
                    icon: Icons.arrow_forward_rounded,
                    onTap: _onTap,
                    gradient: ConstantFunctions.defaultGradient(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
