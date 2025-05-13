import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swipemeet/auth/firebase_auth/auth_check.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_theme_provider.dart';
import 'package:swipemeet/flutter_flow/tracking_wrapper.dart';
import 'package:swipemeet/pages/edit_page.dart';
import 'package:swipemeet/pages/interests_page.dart';
import 'pages/start_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/log_in_page.dart';
import 'pages/completing_profile1.dart';
import 'pages/completing_profile2.dart';
import 'pages/completing_profile3.dart';
import 'pages/home_page.dart';
import 'pages/chat_page.dart';
import 'pages/profile_page.dart';
import 'pages/pass_page.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'SwipeMeet',
            routerConfig: _router,
            theme: ThemeData(
              brightness: Brightness.light,
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                displayMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                displaySmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                headlineLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                headlineMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                headlineSmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                titleLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                titleMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                titleSmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                bodyLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                bodyMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                bodySmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                labelLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                labelMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                labelSmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: const TextTheme(
                displayLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                displayMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                displaySmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                headlineLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                headlineMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                headlineSmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                titleLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                titleMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                titleSmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                bodyLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                bodyMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                bodySmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                labelLarge: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                labelMedium: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
                labelSmall: TextStyle(
                    fontFamily: 'Georgia', fontStyle: FontStyle.italic),
              ),
            ),
            themeMode: ThemeMode.system,
          );
        },
      ),
    );
  }
}

void logScreenView(String screenName) {
  FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  debugPrint("Registrando pantalla: $screenName");
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'AuthCheck',
      builder: (context, state) => ScreenTrackingWrapper(
        screenName: 'AuthCheck',
        child: AuthCheckWidget(),
      ),
    ),
    GoRoute(
      path: '/startPage',
      name: 'StartPage',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'StartPage',
        child: StartPageWidget(),
      ),
    ),
    GoRoute(
      path: '/signInPage',
      name: 'SignInPage',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'SignInPage',
        child: SignInPageWidget(),
      ),
    ),
    GoRoute(
      path: '/logInPage',
      name: 'LogInPage',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'LogInPage',
        child: LogInPageWidget(),
      ),
    ),
    GoRoute(
      path: '/completingProfile1Page',
      name: 'CompletingProfile1Page',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'CompletingProfile1Page',
        child: CompletingProfile1Widget(),
      ),
    ),
    GoRoute(
      path: '/completingProfile2Page/:name',
      name: 'CompletingProfile2Page',
      builder: (context, state) => ScreenTrackingWrapper(
        screenName: 'CompletingProfile2Page',
        child: CompletingProfile2Widget(
            name: state.pathParameters['name'] ?? 'Unknown'),
      ),
    ),
    GoRoute(
      path: '/completingProfile3Page/:name/:borndate',
      name: 'CompletingProfile3Page',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'Unknown';
        final borndate = state.pathParameters['borndate'] ?? 'Unknown';
        return ScreenTrackingWrapper(
          screenName: 'CompletingProfile3Page',
          child: CompletingProfile3Widget(name: name, borndate: borndate),
        );
      },
    ),
    GoRoute(
      path: '/homePage',
      name: 'HomePage',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ScreenTrackingWrapper(
          screenName: 'HomePage',
          child: HomePageWidget(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
    ),
    GoRoute(
      path: '/chatPage',
      name: 'ChatPage',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ScreenTrackingWrapper(
          screenName: 'ChatPage',
          child: ChatPageWidget(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
    ),
    GoRoute(
      path: '/profilePage',
      name: 'ProfilePage',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ScreenTrackingWrapper(
          screenName: 'ProfilePage',
          child: ProfilePageWidget(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
    ),
    GoRoute(
      path: '/passPage',
      name: 'PassPage',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'PassPage',
        child: PassWidget(),
      ),
    ),
    GoRoute(
      path: '/interestsPage',
      name: 'InterestsPage',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'InterestsPage',
        child: InterestsPageWidget(),
      ),
    ),
    GoRoute(
      path: '/editPage',
      name: 'EditPage',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'EditPage',
        child: EditWidget(),
      ),
    ),
  ],
);
