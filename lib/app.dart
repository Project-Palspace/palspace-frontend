import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/landing/landing_page.dart';
import 'package:tbd/providers/auth.dart';
import 'package:tbd/utils/constants.dart';

import 'components/life_cycle_event_handler.dart';
import 'providers/app.dart';
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
    final authState = ref.watch(authStateNotifierProvider.notifier);
    ref.watch(authStateNotifierProvider.notifier).initialize();

    return MaterialApp(
      title: Constants.appName,
      theme: (mode == 'dark') ? Constants.darkTheme : Constants.lightTheme,
      home: !authState.isSignedIn ? TabScreen() : const Landing(),
    );
  }
}
