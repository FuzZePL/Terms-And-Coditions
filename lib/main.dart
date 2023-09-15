import 'package:donotnote/firebase_options.dart';
import 'package:donotnote/screens/login/auth_screen.dart';
import 'package:donotnote/screens/main_screen/main_screen.dart';
import 'package:donotnote/screens/register_screen/register_screen.dart';
import 'package:donotnote/screens/reset_password/reset_password.dart';
import 'package:donotnote/screens/splash_screen.dart';
import 'package:donotnote/values/colors.dart';
import 'package:donotnote/values/strings.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const MyApp());
}

// TODO change in launch.json flutterMode to release or debug or profile

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: KColors.kPrimaryColor,
          primary: Colors.white,
        ),
        canvasColor: Colors.transparent,
        useMaterial3: true,
        fontFamily: 'Gramatika',
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      home: const SplashScreen(),
      localizationsDelegates: const [
        DefaultWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
      ],
      /* supportedLocales: const [
        Locale('en', ''),
      ], */
      routes: {
        RegisterScreen.routeName: (_) => const RegisterScreen(),
        MainScreen.routeName: (_) => const MainScreen(),
        AuthScreen.routeName: (_) => const AuthScreen(),
        ResetPassword.routeName: (_) => const ResetPassword(),
      },
    );
  }
}
