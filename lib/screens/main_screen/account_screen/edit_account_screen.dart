import 'package:donotnote/databases/school_data.dart';
import 'package:donotnote/widgets/text_fields/text_field_with_suggestions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';
import 'package:donotnote/widgets/buttons/default_button.dart';
import 'package:donotnote/widgets/text_fields/rounded_input_field.dart';

class EditAccountScreen extends StatefulWidget {
  static const routeName = '/edit-account-screen';
  const EditAccountScreen({
    Key? key,
    required this.userData,
  }) : super(key: key);
  final AppUser userData;

  @override
  State<EditAccountScreen> createState() => _EditAccountScreenState();
}

class _EditAccountScreenState extends State<EditAccountScreen> {
  final double _defaultSize = SizeConfig.defaultSize!;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  String _school = '';

  void _changeSchoolValue(String school) {
    _school = school;
  }

  void _saveEditUser(AppUser userData) async {
    final bool validate1 = _formKey.currentState!.validate();
    if (validate1) {
      try {
        if (!BackendService.list.contains(_school)) {
          ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
              KColors.kWhiteColor, Strings.wrongSchool);
          return;
        }
        userData.school = _school;
        _formKey.currentState!.save();
        ConstantFunctions.showLoadingDialog(context);
        Server.editUser(userData).then((value) {
          ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
              KColors.kWhiteColor, Strings.toSeeUpdate);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      } on PlatformException catch (error) {
        String message = Strings.anErrorOccurred;

        if (error.message != null) {
          message = error.message!;
        }

        ConstantFunctions.showSnackBar(
            context, KColors.kErrorColor, KColors.kWhiteColor, message);
      } on FirebaseException catch (error) {
        ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
            KColors.kWhiteColor, error.message.toString());
      } catch (error) {
        ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
            KColors.kWhiteColor, error.toString());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    final AppUser user = widget.userData;
    _emailController.text = user.email;
    _nameController.text = user.username;
    _school = user.school;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final AppUser userData = widget.userData;
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          Strings.editAccount,
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
        width: size.width,
        height: size.height,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* SizedBox(
                    height: size.height * 0.12,
                  ), */
                GestureDetector(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(userData.image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFieldWithSuggestions(
                  onChange: _changeSchoolValue,
                  text: _school,
                ),
                RoundedInputField(
                  hintText: Strings.username,
                  icon: Icons.person,
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  inputType: TextInputType.text,
                  controller: _nameController,
                  type: 'Username',
                  isPassword: false,
                  onSaved: (value) {
                    if (value != null) {
                      userData.username = value;
                    }
                  },
                  textInputAction: TextInputAction.next,
                ),
                RoundedInputField(
                  hintText: Strings.email,
                  icon: Icons.email,
                  onChanged: (value) {
                    _formKey.currentState!.validate();
                  },
                  type: 'Email',
                  controller: _emailController,
                  inputType: TextInputType.emailAddress,
                  isPassword: false,
                  onSaved: (value) {
                    if (value != null) {
                      userData.email = value;
                    }
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(
                  height: 20,
                ),
                DefaultButton(
                  defaultSize: _defaultSize,
                  onTap: () {
                    _saveEditUser(userData);
                  },
                  text: Strings.save,
                  icon: Icons.save_outlined,
                  gradient: ConstantFunctions.defaultGradient(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
