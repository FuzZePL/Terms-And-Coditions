import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:donotnote/models/note.dart';
import 'package:donotnote/screens/search_screen.dart';
import 'package:donotnote/widgets/main_screen/item_card_note.dart';
import 'package:donotnote/widgets/shimmer/shimmer.dart';
import 'package:donotnote/widgets/text_fields/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/constant_functions.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainCard extends StatefulWidget {
  const MainCard({
    Key? key,
    required this.appUser,
    required this.isLoading,
    required this.canView,
  }) : super(key: key);
  final AppUser appUser;
  final bool isLoading;
  final bool canView;

  @override
  State<MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<MainCard>
    with AutomaticKeepAliveClientMixin {
  List<Note> _suggestedList = [];
  final int _randomNumber = Random().nextInt(5000);
  bool _isFirstTime = true;

  void _getSuggestedList() async {
    if (!widget.isLoading) {
      await Server.getSuggestedNotes(widget.appUser).then((value) {
        setState(() {
          _suggestedList = value;
        });
      });
    }
  }

  void _onSearch(String query) async {
    FocusScope.of(context).unfocus();
    if (widget.canView) {
      _onSearchGetNotes(query);
    } else {
      const String isShownKey = 'isShownKey';
      await SharedPreferences.getInstance().then(
        (value) {
          int? number = value.getInt(isShownKey);
          if (number == 2) {
            _onSearchGetNotes(query);
          } else {
            ConstantFunctions.showSnackBar(context, KColors.kErrorColor,
                KColors.kWhiteColor, Strings.beGoodPerson);
          }
        },
      );
    }
  }

  void _onSearchGetNotes(String query1) {
    if (widget.isLoading) {
      return;
    }
    if (query1.isNotEmpty) {
      Navigator.of(context).push(
        ConstantFunctions.createRoute(
          SearchScreen(query: query1, user: widget.appUser),
          const Offset(0.0, 1.0),
        ),
      );
    }
  }

  @override
  void didUpdateWidget(covariant MainCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isFirstTime) {
      _isFirstTime = false;
      _getSuggestedList();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size size = MediaQuery.of(context).size;
    final AppUser user = widget.appUser;
    final String username = user.username;
    String welcomeText = '${Strings.hi} $username!';
    if (username.isNotEmpty) {
      if (_randomNumber == 69 ||
          _randomNumber == 420 ||
          _randomNumber == 2137 ||
          _randomNumber == 1337) {
        welcomeText = '${Strings.help}, $username! ${Strings.theyClosedMe}';
      } else if (_randomNumber > 1337 && _randomNumber < 2137) {
        welcomeText = '${Strings.howDaysGoing}, $username?';
      } else if (_randomNumber > 2137 && _randomNumber < 3000) {
        welcomeText = '${Strings.whatYouLearning}, $username?';
      }
    }

    return SafeArea(
      bottom: false,
      child: Shimmer(
        linearGradient: KColors.shimmerGradient,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 50),
                height: size.height * 0.35,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 56,
                      ),
                      height: size.height * 0.35 - 27,
                      decoration: const BoxDecoration(
                        color: KColors.kPrimaryColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                      ),
                      child: Row(
                        children: [
                          Flexible(
                            child: AnimatedTextKit(
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                TyperAnimatedText(
                                  welcomeText,
                                  speed: const Duration(milliseconds: 100),
                                  textStyle: const TextStyle(
                                    color: KColors.kWhiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: SearchTextField(
                        onSearch: _onSearch,
                      ),
                    ),
                  ],
                ),
              ),
              ItemCardNote(
                notes: _suggestedList,
                notesName: Strings.suggestedList,
                appUser: user,
              ),
              SizedBox(
                height: size.height * 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
