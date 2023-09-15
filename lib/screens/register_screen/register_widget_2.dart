import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/widgets/buttons/default_button.dart';

class RegisterWidget2 extends StatefulWidget {
  const RegisterWidget2({
    super.key,
    required this.controller,
    required this.submitStep2,
    required this.email,
  });
  final PageController controller;
  final Function() submitStep2;
  final String email;

  @override
  State<RegisterWidget2> createState() => _RegisterPart2State();
}

class _RegisterPart2State extends State<RegisterWidget2> {
  //static const int _step = 1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _code = '';
  String _email = '';
  String _sendCode = '';
  final List<dynamic> _focusNodeList = [];
  final double _defaultSize = SizeConfig.defaultSize!;

  void _sendGmail(String email) async {
    final String code1 = (Random().nextInt(900) + 100).toString();
    final String code2 = (Random().nextInt(900) + 100).toString();
    _sendCode = '';
    _sendCode = code1 + code2;
    final String codeGenerated = '$code1 $code2';
    String senderEmail = 'emailauth338@gmail.com';
    String password = 'kkgvcnhryfwbamgl';
    Message message = Message();
    message.subject = Strings.verifyEmail;
    message.html =
        '<h1 style="color: #5e9ca0; text-align: left;">${Strings.email1}</h1><p style="text-align: left;"><strong><span style="color: #000000;">${Strings.email2}</span></strong></p><p style="text-align: left;">&nbsp;</p><h2 style="text-align: left;"><strong><span style="color: #000000;">$codeGenerated</span></strong></h2><p>&nbsp;</p><p><span style="color: #000000;">${Strings.email3}</span></p><p><strong>&nbsp;</strong></p>';
    message.from = Address(senderEmail);
    message.recipients.add(email);
    SmtpServer smtpServer = gmail(senderEmail, password);
    await send(message, smtpServer);
  }

  void _verifyOTP(String email) async {
    _formKey.currentState!.save();
    if (_code == _sendCode) {
      FocusScope.of(context).unfocus();
      widget.submitStep2();
    } else {
      _code = '';
      ConstantFunctions.showSnackBar(
        context,
        KColors.kErrorColor,
        KColors.kWhiteColor,
        Strings.wrongCode,
      );
    }
  }

  void _saveOneDigit(String? digit) {
    if (digit != null) {
      _code += digit.toString();
    }
  }

  void _nextField(String value, FocusNode? focusNode) {
    if (focusNode != null) {
      if (value.length == 1) {
        focusNode.requestFocus();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _sendGmail(_email);
    _focusNodeList.add(null);
    for (int i = 0; i < 5; i++) {
      _focusNodeList.add(FocusNode());
    }
    _focusNodeList.add(null);
  }

  @override
  void dispose() {
    for (FocusNode? element in _focusNodeList) {
      if (element != null) {
        element.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double doubleDefaultSize = _defaultSize * 2;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: KColors.kBackgroundColor,
        child: Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(left: 8, right: 8),
          decoration: const BoxDecoration(
            color: KColors.kBackgroundColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                Strings.verifyTo,
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 32,
                    color: KColors.kTextColor),
              ),
              SizedBox(
                height: _defaultSize,
              ),
              const Text(
                Strings.verifyToContinue,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: KColors.kTextColor,
                ),
              ),
              SizedBox(
                height: doubleDefaultSize * 2,
              ),
              Container(
                width: size.width,
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      Strings.emailNotRecieved,
                      style: TextStyle(
                        fontSize: 18,
                        color: KColors.kTextColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      width: _defaultSize * 0.8,
                    ),
                    GestureDetector(
                      onTap: () {
                        _sendGmail(_email);
                      },
                      child: const Text(
                        Strings.sendAgain,
                        style: TextStyle(
                          fontSize: 18,
                          color: KColors.kTextColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: doubleDefaultSize * 2,
              ),
              Container(
                height: _defaultSize * 10,
                width: size.width,
                padding: const EdgeInsets.all(5),
                child: Form(
                  key: _formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (int i = 0; i < 6; i++)
                        OneDigitCodeInput(
                          defaultSize: _defaultSize,
                          onSaved: _saveOneDigit,
                          focusNode: _focusNodeList[i],
                          onChanged: (val) {
                            _nextField(val, _focusNodeList[i + 1]);
                          },
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: doubleDefaultSize,
              ),
              DefaultButton(
                defaultSize: _defaultSize,
                onTap: () {
                  _verifyOTP(_email);
                },
                text: Strings.nextStep,
                icon: Icons.arrow_forward_rounded,
                gradient: ConstantFunctions.defaultGradient(),
              ),
              SizedBox(
                height: doubleDefaultSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OneDigitCodeInput extends StatelessWidget {
  const OneDigitCodeInput({
    super.key,
    required this.defaultSize,
    required this.onSaved,
    required this.focusNode,
    required this.onChanged,
  });

  final Function(String?) onSaved;
  final Function(String) onChanged;
  final double defaultSize;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: defaultSize * 6.5,
      width: defaultSize * 5.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: KColors.kShadowColor,
      ),
      alignment: Alignment.center,
      child: TextFormField(
        focusNode: focusNode,
        textAlign: TextAlign.center,
        textInputAction: TextInputAction.next,
        style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        onSaved: onSaved,
        onChanged: onChanged,
        decoration: const InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
