import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/auth/login/login.dart';
import 'package:tbd/landing/landing_page.dart';
import 'package:tbd/providers/auth.dart';
import 'package:tbd/routes/guards.dart';
import 'package:tbd/utils/constants.dart';

import 'main.dart';
import 'providers/app.dart';
import 'routes/router.gr.dart';
import 'screens/mainscreen.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(
    //   LifecycleEventHandler(
    //     detachedCallBack: () => UserService().setUserStatus(false),
    //     resumeCallBack: () => UserService().setUserStatus(true),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeController).theme;
    // final router = ref.watch(routerProvider);

    final appRouter = AppRouter(authGuard: AuthGuard(ref: ref));
    // final authState = ref.watch(authStateNotifierProvider.notifier);

    // try {
    //   authState.initialize;
    // } catch (e) {
    //   print(e);
    // }

    return MaterialApp.router(
      title: Constants.appName,
      theme: (mode == 'dark') ? Constants.darkTheme : Constants.lightTheme,
      routeInformationParser: appRouter.defaultRouteParser(),
      routeInformationProvider: appRouter.routeInfoProvider(),
      routerDelegate: appRouter.delegate(),
      // home:
    );
  }
}

// class InitialView extends ConsumerWidget {
//   const InitialView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authState = ref.watch(authStateNotifierProvider.notifier);
//     authState.initialize;
//     return authState.isSignedIn ? const TabScreenView() : const LoginView();
//   }
// }
