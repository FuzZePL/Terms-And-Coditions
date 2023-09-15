import 'package:donotnote/screens/main_screen/account_screen/account_screen.dart';
import 'package:donotnote/screens/main_screen/main_card.dart';
import 'package:donotnote/screens/main_screen/your_notes_screen.dart';
import 'package:donotnote/widgets/others/my_bottom_navigation_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:donotnote/models/appuser.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/size_config.dart';
import 'package:donotnote/values/strings.dart';
import 'package:donotnote/web/server.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = '/main-screen';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  final PageController _controller =
      PageController(initialPage: 1, keepPage: true);
  static const String _isShownKey = 'isShownKey';
  final ValueNotifier<int> _selectedPageIndex = ValueNotifier(1);
  AppUser _user = AppUser('', '', '', '', '', '', 0);
  bool _moveBy2 = false;
  bool _isLoading = true;
  bool _canView = false;

  // TODO maybe work a little more on a cache removal

  void _gettingData() async {
    _user = await Server.getUserData();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? number = prefs.getInt(_isShownKey);
    if (number == 2) {
      _canView = true;
    }
    setState(() {
      _isLoading = false;
    });

    if (number == null) {
      _showWelcomeDialog();
      prefs.setInt(_isShownKey, 1);
    }
    _clearCache();
  }

  void _selectPage(int index) {
    if (_isLoading || _selectedPageIndex.value == index) {
      return;
    }

    if ((_selectedPageIndex.value - index).abs() > 1) {
      _moveBy2 = true;
    }
    _selectedPageIndex.value = index;
    _controller.animateToPage(
      _selectedPageIndex.value,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  void _clearCache() async {
    await DefaultCacheManager().emptyCache();
  }

  void _initMessaging() async {
    final FirebaseMessaging fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();
  }

  @override
  void initState() {
    super.initState();
    _gettingData();
    _initMessaging();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        _clearCache();
      case AppLifecycleState.paused:
      case AppLifecycleState.resumed:
      case AppLifecycleState.inactive:
      case AppLifecycleState.hidden:
    }
  }

  void _showWelcomeDialog() {
    final double defaultSize = SizeConfig.defaultSize!;
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.all(22),
            height: defaultSize * 25,
            width: defaultSize * 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    Strings.welcomeText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: defaultSize * 2,
                  ),
                  const Text(
                    Strings.welcomeText2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, -0.06),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: KColors.kPrimaryColor),
    );
    final PageView pageView = PageView(
      onPageChanged: (page) {
        FocusScope.of(context).unfocus();
        if (_selectedPageIndex.value == page) {
          return;
        }
        if (!_moveBy2) {
          _selectedPageIndex.value = page;
        } else {
          _moveBy2 = false;
        }
      },
      controller: _controller,
      scrollDirection: Axis.horizontal,
      physics: _isLoading
          ? const NeverScrollableScrollPhysics()
          : const ScrollPhysics(),
      children: [
        AccountScreen(
          user: _user,
        ),
        MainCard(
          appUser: _user,
          isLoading: _isLoading,
          canView: _canView,
        ),
        YourNotesScreen(
          user: _user,
        ),
      ],
    );

    return Scaffold(
      backgroundColor: KColors.kBackgroundColor,
      drawerEnableOpenDragGesture: true,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        bottom: false,
        child: Container(
          alignment: Alignment.center,
          child: pageView,
        ),
      ),
      bottomNavigationBar: ValueListenableBuilder(
        valueListenable: _selectedPageIndex,
        builder: (_, __, ___) {
          return MyBottomNavigationBar(
            onTap: _selectPage,
            pageIndex: _selectedPageIndex.value,
          );
        },
      ),
    );
  }
}
