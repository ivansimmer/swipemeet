import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:swipemeet/auth/firebase_auth/auth_check.dart';
import 'package:swipemeet/flutter_flow/flutter_flow_theme_provider.dart';
import 'package:swipemeet/flutter_flow/tracking_wrapper.dart';
import 'package:swipemeet/pages/communities_page_model.dart';
import 'package:swipemeet/pages/community_chat_page.dart';
import 'package:swipemeet/pages/discover_communities.dart';
import 'package:swipemeet/pages/edit_page.dart';
import 'package:swipemeet/pages/interests_page.dart';
import 'package:swipemeet/pages/marketplace_page.dart';
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
import 'pages/communities_page.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

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
          name: state.pathParameters['name'] ?? 'Unknown',
        ),
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
    GoRoute(
      name: 'CommunitiesPage',
      path: '/communitiesPage',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: CommunitiesPageWidget(
          screenName: 'CommunitiesPage',
          child: CommunitiesWidget(),
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            child,
      ),
    ),
    GoRoute(
      path: '/discover_communities',
      name: 'DiscoverCommunities',
      builder: (context, state) => const ScreenTrackingWrapper(
        screenName: 'DiscoverCommunities',
        child: DiscoverCommunitiesWidget(),
      ),
    ),
    GoRoute(
      path: '/community_chat/:id',
      name: 'CommunityChat',
      builder: (context, state) {
        final communityId = state.pathParameters['id']!;
        final extra = state.extra as Map<String, dynamic>?;
        final communityName = extra?['name'] ?? 'Comunidad';

        return CommunityChatPage(
          communityId: communityId,
          communityName: communityName,
        );
      },
    ),
    GoRoute(
  path: '/marketplacePage',
  name: 'MarketplacePage',
  pageBuilder: (context, state) {
    final extra = state.extra as Map<String, dynamic>? ?? {};
    final profileImageUrl = extra['profileImageUrl'] ??
        'https://upload.wikimedia.org/wikipedia/commons/2/2c/Default_pfp.svg';

    return CustomTransitionPage(
      key: state.pageKey,
      child: MarketplacePage(profileImageUrl: profileImageUrl),
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    );
  },
),
GoRoute(
  name: 'AddProductPage',
  path: '/addProductPage',
  builder: (context, state) => const AddProductPage(),
),


    
  ],
);

void logScreenView(String screenName) {
  FirebaseAnalytics.instance.logScreenView(screenName: screenName);
  debugPrint("Registrando pantalla: $screenName");
}

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
              textTheme: ThemeData.light().textTheme.apply(
                    fontFamily: 'Georgia',
                    bodyColor: Colors.black,
                    displayColor: Colors.black,
                  ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              textTheme: ThemeData.dark().textTheme.apply(
                    fontFamily: 'Georgia',
                    bodyColor: Colors.white,
                    displayColor: Colors.white,
                  ),
            ),
            themeMode: ThemeMode.system,
          );
        },
      ),
    );
  }
}
