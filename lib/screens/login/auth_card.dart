import 'package:donotnote/screens/register_screen/register_screen.dart';
import 'package:donotnote/screens/reset_password/reset_password.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/widgets/buttons/default_button.dart';
import 'package:donotnote/widgets/buttons/ink_well_rounded.dart';
import 'package:donotnote/widgets/others/spacer_bar.dart';
import 'package:donotnote/widgets/text_fields/rounded_input_field.dart';
import 'package:flutter/material.dart';

class AuthCard extends StatefulWidget {
  const AuthCard({
    Key? key,
    required this.submitFn,
    required this.isWrong,
    required this.triesLeft,
  }) : super(key: key);
  final void Function(
    String email,
    String password,
    BuildContext ctx,
  ) submitFn;
  final bool isWrong;
  final int triesLeft;

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final double _defaultSize = SizeConfig.defaultSize!;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: '_homeScreenkey');
  String _userEmail = '';
  String _userPassword = '';

  void _trySubmit() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/icons/icon_new.png',
                          height: size.width * 0.45,
                          width: size.width * 0.45,
                        ),
                        SizedBox(
                          height: _defaultSize * 4,
                        ),
                        RoundedInputField(
                          hintText: Strings.email,
                          icon: Icons.email_rounded,
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                          type: 'Email',
                          onSaved: (value) {
                            if (value != null) {
                              _userEmail = value;
                            }
                          },
                          textInputAction: TextInputAction.next,
                          inputType: TextInputType.name,
                          isPassword: false,
                          i: 0,
                        ),
                        RoundedInputField(
                          onChanged: (value) {
                            _formKey.currentState!.validate();
                          },
                          hintText: Strings.password,
                          onSaved: (value) {
                            if (value != null) {
                              _userPassword = value;
                            }
                          },
                          maxLines: 1,
                          isPassword: true,
                          icon: Icons.password_rounded,
                          type: 'Password',
                          textInputAction: TextInputAction.done,
                          inputType: TextInputType.visiblePassword,
                          i: 1,
                        ),
                        if (widget.isWrong)
                          Container(
                            padding: const EdgeInsets.all(5),
                            margin: const EdgeInsets.only(left: 25),
                            child: Row(
                              children: [
                                Text(
                                  widget.triesLeft > 0
                                      ? '${Strings.leftTries} ${widget.triesLeft}'
                                      : Strings.blockedAccount5Min,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 13,
                                    color: KColors.kWhiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          child: DefaultButton(
                            defaultSize: _defaultSize,
                            onTap: _trySubmit,
                            text: Strings.login,
                            icon: Icons.login_rounded,
                            gradient: ConstantFunctions.defaultGradient(),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pushNamed(ResetPassword.routeName);
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Strings.forgotPassword,
                          style: TextStyle(
                            color: KColors.kTextColor,
                          ),
                        ),
                        Text(
                          Strings.resetPassword,
                          style: TextStyle(
                            color: KColors.kTextColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: _defaultSize * 1,
                  ),
                  SpacerBar(
                    size: size,
                    text: Strings.or,
                    weight: FontWeight.w600,
                  ),
                  SizedBox(
                    height: _defaultSize * 2,
                  ),
                  CreateAccountButton(
                    size: size,
                    defaultSize: _defaultSize,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      Navigator.of(context).pushNamed(RegisterScreen.routeName);
                    },
                  ),
                  SizedBox(
                    height: _defaultSize * 3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CreateAccountButton extends StatelessWidget {
  const CreateAccountButton({
    super.key,
    required this.size,
    required this.defaultSize,
    required this.onTap,
  });

  final Size size;
  final double defaultSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWellRounded(
          radius: 12,
          shadow: ConstantFunctions.defaultShadow(),
          onTap: onTap,
          gradient: ConstantFunctions.defaultGradient(),
          child: Container(
            height: defaultSize * 5,
            padding: const EdgeInsets.symmetric(horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  Strings.createAccount,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: KColors.kWhiteColor,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 24,
                  color: KColors.kWhiteColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
