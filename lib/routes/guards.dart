import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/routes/router.gr.dart';

import '../providers/auth.dart';

class AuthGuard extends AutoRouteGuard {
  AuthGuard({required ProviderRef ref}) : _ref = ref;

  final ProviderRef _ref;

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    var isSignedIn = _ref.watch(authStateNotifierProvider.notifier).isSignedIn;
    if (isSignedIn) {
      resolver.next(true);
    } else {
      router.root.push(const Auth());
    }
  }
}
