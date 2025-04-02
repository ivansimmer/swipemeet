import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swipemeet/auth/firebase_auth/auth_check.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_theme_provider.dart';
import 'pages/start_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/log_in_page.dart';
import 'pages/verification_page.dart';
import 'pages/completing_profile1.dart';
import 'pages/completing_profile2.dart';
import 'pages/completing_profile3.dart';
import 'pages/home_page.dart';
import 'pages/chat_page.dart';
import 'pages/profile_page.dart';
import 'pages/pass_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
            theme: themeProvider.themeData,  // Usamos themeData desde el ThemeProvider
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,  // Esto gestiona el modo oscuro y claro
          );
        },
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => AuthCheckWidget()), // Verificador de sesión
    GoRoute(path: '/startPage', name: 'StartPage', builder: (context, state) => const StartPageWidget()),
    GoRoute(path: '/signInPage', name: 'SignInPage', builder: (context, state) => const SignInPageWidget()),
    GoRoute(path: '/logInPage', name: 'LogInPage', builder: (context, state) => const LogInPageWidget()),
    GoRoute(path: '/verificationPage', name: 'VerificationPage', builder: (context, state) => const VerificationPageWidget()),
    GoRoute(path: '/completingProfile1Page', name: 'CompletingProfile1Page', builder: (context, state) => const CompletingProfile1Widget()),
    GoRoute(
      path: '/completingProfile2Page/:name',
      name: 'CompletingProfile2Page',
      builder: (context, state) => CompletingProfile2Widget(name: state.pathParameters['name'] ?? 'Unknown'),
    ),
    GoRoute(
      path: '/completingProfile3Page/:name/:borndate',
      name: 'CompletingProfile3Page',
      builder: (context, state) {
        final name = state.pathParameters['name'] ?? 'Unknown';
        final borndate = state.pathParameters['borndate'] ?? 'Unknown';
        return CompletingProfile3Widget(name: name, borndate: borndate);
      },
    ),
    GoRoute(path: '/homePage', name: 'HomePage', builder: (context, state) => const HomePageWidget()),
    GoRoute(path: '/chatPage', name: 'ChatPage', builder: (context, state) => const ChatPageWidget()),
    GoRoute(path: '/profilePage', name: 'ProfilePage', builder: (context, state) => const ProfilePageWidget()),
    GoRoute(path: '/passPage', name: 'PassPage', builder: (context, state) => const PassWidget()),
  ],
);
