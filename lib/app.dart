import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/routes/guards.dart';
import 'package:tbd/utils/constants.dart';
import 'package:tbd/utils/device_info.dart';

import 'providers/app.dart';
import 'routes/router.gr.dart';

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
    final appRouter = ref.watch(routerProvider);

    return MaterialApp.router(
      title: Constants.appName,
      theme: (mode == 'dark') ? Constants.darkTheme : Constants.lightTheme,
      routeInformationParser: appRouter.defaultRouteParser(),
      routeInformationProvider: appRouter.routeInfoProvider(),
      routerDelegate: appRouter.delegate(),
    );
  }
}
