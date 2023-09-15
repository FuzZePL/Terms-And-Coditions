import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/screens/login/auth_screen.dart';
import 'package:donotnote/screens/main_screen/account_screen/edit_account_screen.dart';
import 'package:donotnote/screens/main_screen/account_screen/saved_screen.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';
import 'package:donotnote/widgets/buttons/default_button.dart';
import 'package:donotnote/widgets/items/user_account_detail_item.dart';
import 'package:donotnote/widgets/text_fields/rounded_input_field.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  static const routeName = '/account-screen';
  const AccountScreen({
    Key? key,
    required this.user,
  }) : super(key: key);
  final AppUser user;

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final double _defaultSize = SizeConfig.defaultSize!;

  void _showDeleteAccount() {
    final size = MediaQuery.of(context).size;
    final formKey = GlobalKey<FormState>();
    String password = '';
    String email = '';
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      backgroundColor: KColors.kBackgroundColor,
      builder: (ctx) {
        return Container(
          height: size.height * 0.75,
          width: double.infinity,
          margin: const EdgeInsets.only(
            left: 12,
            right: 12,
            top: 12,
          ),
          decoration: BoxDecoration(
            color: KColors.kBackgroundColor,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Column(
            children: [
              SizedBox(
                width: size.width * 0.07,
              ),
              Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundedInputField(
                      hintText: Strings.provideEmail,
                      icon: Icons.email,
                      onChanged: (value) {
                        email = value;
                      },
                      type: 'Email',
                      onSaved: (value) {
                        if (value != null) {
                          email = value;
                        }
                      },
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      isPassword: false,
                    ),
                    RoundedInputField(
                      hintText: Strings.providePassword2,
                      icon: Icons.password_rounded,
                      onChanged: (value) {
                        password = value;
                      },
                      type: 'Pass',
                      onSaved: (value) {
                        if (value != null) {
                          password = value;
                        }
                      },
                      textInputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      isPassword: true,
                    ),
                    DefaultButton(
                      defaultSize: _defaultSize,
                      onTap: () {
                        _deleteUserAccount(email, password, formKey, ctx);
                      },
                      text: Strings.ok,
                      icon: Icons.delete_forever_rounded,
                      gradient: ConstantFunctions.defaultGradient(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteUserAccount(String email, String password,
      GlobalKey<FormState> formKey, BuildContext ctx) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      try {
        Server.deleteUserAccount(email, password, ctx).then((value) {
          Navigator.of(context).pop();
          Navigator.of(context).pushNamed(AuthScreen.routeName);
        });
      } catch (error) {
        ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
            KColors.kWhiteColor, error.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppUser userData = widget.user;
    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      appBar: AppBar(
        backgroundColor: KColors.kPrimaryColor,
        title: const Text(
          Strings.yourAccount,
          style: TextStyle(
            color: KColors.kWhiteColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserInfo(
              uri: userData.image,
              name: userData.username,
            ),
            SizedBox(
              height: SizeConfig.defaultSize! * 2,
            ),
            UserAccoutDetailItem(
              icon: const Icon(
                Icons.favorite_outline_rounded,
                color: KColors.kButtonColorBlue,
              ),
              name: Strings.saved,
              i: 0,
              onClick: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SavedScreen(user: userData),
                  ),
                );
              },
            ),
            UserAccoutDetailItem(
              icon: const Icon(
                Icons.mode_edit_outline_outlined,
                color: KColors.kButtonColorPurple,
              ),
              name: Strings.editAccount,
              i: 1,
              onClick: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditAccountScreen(userData: userData),
                  ),
                );
              },
            ),
            UserAccoutDetailItem(
              name: Strings.logOut,
              onClick: () {
                Server.logOut().then(
                  (value) {
                    Navigator.of(context)
                        .pushReplacementNamed(AuthScreen.routeName);
                  },
                );
              },
              i: 2,
              icon: const Icon(
                Icons.logout_rounded,
                color: KColors.kButtonColorGreen,
              ),
            ),
            UserAccoutDetailItem(
              icon: const Icon(
                Icons.delete_outline_outlined,
                color: KColors.kButtonColorYellow,
              ),
              i: 3,
              name: Strings.deleteAccount,
              onClick: () {
                _showDeleteAccount();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.uri,
    required this.name,
  }) : super(key: key);
  final String uri;
  final String name;

  @override
  Widget build(BuildContext context) {
    final double defaultSize = SizeConfig.defaultSize!;
    return SizedBox(
      height: defaultSize * 24,
      child: Stack(
        children: [
          ClipPath(
            clipper: CustomShape(),
            child: Container(
              height: defaultSize * 16,
              color: KColors.kPrimaryColor,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: defaultSize * 14,
                  width: defaultSize * 14,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: defaultSize * 0.4,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(uri),
                    ),
                  ),
                ),
                SizedBox(
                  height: defaultSize,
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: defaultSize * 2.2,
                    color: KColors.kTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: defaultSize / 1.6,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double height = size.height;
    double width = size.width;
    path.lineTo(0, height - 100);
    path.quadraticBezierTo(width / 2, height, width, height - 20);
    path.lineTo(width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
