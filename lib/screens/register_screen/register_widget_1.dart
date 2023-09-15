import 'package:donotnote/databases/school_data.dart';
import 'package:donotnote/widgets/text_fields/text_field_with_suggestions.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/widgets/buttons/default_button.dart';
import 'package:donotnote/widgets/text_fields/rounded_input_field.dart';

class RegisterWidget1 extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    PageController controller,
    String school,
  ) submitFirstStep;
  final BuildContext ctx;
  final PageController controller;
  const RegisterWidget1({
    Key? key,
    required this.ctx,
    required this.submitFirstStep,
    required this.controller,
  }) : super(key: key);

  @override
  State<RegisterWidget1> createState() => _RegisterWidget1State();
}

class _RegisterWidget1State extends State<RegisterWidget1>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final double _defaultSize = SizeConfig.defaultSize!;
  String _username = '';
  String _email = '';
  String _password = '';
  String _password2 = '';
  final ValueNotifier<String> _school = ValueNotifier(Strings.provideSchool);
  final ValueNotifier<bool> _acceptTerms = ValueNotifier(false);

  void _openTermsAndConditions() async {
    Uri url = Uri.parse(
        'https://github.com/bartekzajac12/termsAndCoditions/blob/main/DOnotNOTE');
    try {
      await launchUrl(url).onError((error, stackTrace) {
        ConstantFunctions.showSnackBar(
          context,
          KColors.kErrorColor,
          Colors.white,
          Strings.cannnotOpenTerms,
        );
        return false;
      });
    } catch (e) {
      //
    }
  }

  void _onTap() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate() && _acceptTerms.value) {
      _formKey.currentState!.save();
      if (_password == _password2) {
        for (String element in BackendService.list) {
          if (element.toLowerCase() == _school.value.toLowerCase()) {
            _school.value = element;
            widget.submitFirstStep(
              _email.trim(),
              _password,
              _username.trim(),
              widget.controller,
              _school.value,
            );
            return;
          }
        }
        ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
            KColors.kWhiteColor, Strings.pleaseContainSchool);
        return;
      } else {
        ConstantFunctions.showSnackBar(widget.ctx, KColors.kErrorColor,
            KColors.kWhiteColor, Strings.passwordsMustBeTheSame);
      }
    } else {
      ConstantFunctions.showSnackBar(widget.ctx, KColors.kErrorColor,
          KColors.kWhiteColor, Strings.fillAndCorrectAllData);
    }
  }

  void _changeSchoolValue(String school) {
    _school.value = school;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        color: KColors.kBackgroundColor,
        alignment: Alignment.center,
        width: size.width,
        height: size.height,
        padding: EdgeInsets.only(
          top: size.width * 0.018,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: _defaultSize,
                ),
                const Text(
                  Strings.register,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    color: KColors.kTextColor,
                  ),
                ),
                SizedBox(
                  height: _defaultSize,
                ),
                const Text(
                  Strings.fillDataToContinue,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: KColors.kTextColor,
                  ),
                ),
                SizedBox(
                  height: _defaultSize * 3,
                ),
                ValueListenableBuilder(
                  valueListenable: _school,
                  builder: (_, __, ___) {
                    return TextFieldWithSuggestions(
                      onChange: _changeSchoolValue,
                      text: _school.value,
                    );
                  },
                ),
                RoundedInputField(
                  hintText: Strings.username,
                  icon: Icons.person,
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  type: 'Username',
                  onSaved: (value) {
                    if (value != null) {
                      _username = value;
                    }
                  },
                  textInputAction: TextInputAction.next,
                  inputType: TextInputType.name,
                  isPassword: false,
                  i: 0,
                ),
                RoundedInputField(
                  hintText: Strings.email12,
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
                  textInputAction: TextInputAction.next,
                  inputType: TextInputType.emailAddress,
                  isPassword: false,
                  i: 1,
                ),
                SizedBox(
                  height: _defaultSize * 3,
                ),
                RoundedInputField(
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  hintText: Strings.password,
                  onSaved: (value) {
                    if (value != null) {
                      _password = value;
                    }
                  },
                  inputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  isPassword: true,
                  icon: Icons.lock_rounded,
                  type: 'pass',
                  i: 2,
                ),
                RoundedInputField(
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  hintText: Strings.passwordRepeat,
                  onSaved: (value) {
                    if (value != null) {
                      _password2 = value;
                    }
                  },
                  inputType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  isPassword: true,
                  icon: Icons.lock_reset_outlined,
                  type: 'pass',
                  i: 3,
                ),
                SizedBox(
                  height: _defaultSize,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  child: ValueListenableBuilder(
                    valueListenable: _acceptTerms,
                    builder: (context, value, child) {
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: CheckboxListTile(
                          value: _acceptTerms.value,
                          onChanged: (val) {
                            if (val != null) {
                              _acceptTerms.value = val;
                            }
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: KColors.kButtonColorPurple,
                          activeColor: Colors.black,
                          contentPadding: const EdgeInsets.all(8),
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                Strings.iAcceptTerms1,
                                style: TextStyle(
                                  color: KColors.kTextColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                              GestureDetector(
                                onTap: _openTermsAndConditions,
                                child: const Text(
                                  Strings.iAcceptTerms2,
                                  style: TextStyle(
                                    color: KColors.kTextColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                    decoration: TextDecoration.underline,
                                    decorationColor: KColors.kTextColor,
                                  ),
                                  softWrap: true,
                                  maxLines: 2,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: _defaultSize,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                  child: DefaultButton(
                    defaultSize: _defaultSize,
                    onTap: _onTap,
                    text: Strings.nextStep,
                    icon: Icons.arrow_forward_rounded,
                    gradient: ConstantFunctions.defaultGradient(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
