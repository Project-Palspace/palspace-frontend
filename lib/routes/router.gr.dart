// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i9;
import 'package:auto_route/empty_router_widgets.dart' as _i1;
import 'package:flutter/material.dart' as _i10;

import '../auth/login/login.dart' as _i3;
import '../auth/register/register.dart' as _i4;
import '../auth/verification/verification.dart' as _i5;
import '../pages/debug.dart' as _i7;
import '../pages/feeds.dart' as _i6;
import '../pages/search.dart' as _i8;
import '../screens/mainscreen.dart' as _i2;
import 'guards.dart' as _i11;

class AppRouter extends _i9.RootStackRouter {
  AppRouter({
    _i10.GlobalKey<_i10.NavigatorState>? navigatorKey,
    required this.authGuard,
  }) : super(navigatorKey);

  final _i11.AuthGuard authGuard;

  @override
  final Map<String, _i9.PageFactory> pagesMap = {
    Auth.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.EmptyRouterPage(),
      );
    },
    TabScreenRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.TabScreenView(),
      );
    },
    LoginRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.LoginView(),
      );
    },
    RegisterRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.RegisterView(),
      );
    },
    EmailVerificationRoute.name: (routeData) {
      final pathParams = routeData.inheritedPathParams;
      final args = routeData.argsAs<EmailVerificationRouteArgs>(
          orElse: () =>
              EmailVerificationRouteArgs(code: pathParams.optString('code')));
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.EmailVerificationView(
          code: args.code,
          key: args.key,
        ),
      );
    },
    FeedRouter.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.EmptyRouterPage(),
      );
    },
    NotificationsRouter.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.EmptyRouterPage(),
      );
    },
    MyProfileRouter.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.EmptyRouterPage(),
      );
    },
    SearchRouter.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.EmptyRouterPage(),
      );
    },
    FeedsRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i6.FeedsView(),
      );
    },
    DebugRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.DebugView(),
      );
    },
    SearchRoute.name: (routeData) {
      return _i9.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.SearchView(),
      );
    },
  };

  @override
  List<_i9.RouteConfig> get routes => [
        _i9.RouteConfig(
          '/#redirect',
          path: '/',
          redirectTo: '/wrapper',
          fullMatch: true,
        ),
        _i9.RouteConfig(
          Auth.name,
          path: '/auth',
          children: [
            _i9.RouteConfig(
              LoginRoute.name,
              path: '',
              parent: Auth.name,
            ),
            _i9.RouteConfig(
              RegisterRoute.name,
              path: 'register',
              parent: Auth.name,
            ),
            _i9.RouteConfig(
              EmailVerificationRoute.name,
              path: 'verification/:code',
              parent: Auth.name,
            ),
          ],
        ),
        _i9.RouteConfig(
          TabScreenRoute.name,
          path: '/wrapper',
          guards: [authGuard],
          children: [
            _i9.RouteConfig(
              FeedRouter.name,
              path: 'feed',
              parent: TabScreenRoute.name,
              guards: [authGuard],
              children: [
                _i9.RouteConfig(
                  FeedsRoute.name,
                  path: '',
                  parent: FeedRouter.name,
                )
              ],
            ),
            _i9.RouteConfig(
              NotificationsRouter.name,
              path: 'notifications',
              parent: TabScreenRoute.name,
              guards: [authGuard],
              children: [
                _i9.RouteConfig(
                  DebugRoute.name,
                  path: '',
                  parent: NotificationsRouter.name,
                )
              ],
            ),
            _i9.RouteConfig(
              MyProfileRouter.name,
              path: 'myProfile',
              parent: TabScreenRoute.name,
              guards: [authGuard],
              children: [
                _i9.RouteConfig(
                  DebugRoute.name,
                  path: '',
                  parent: MyProfileRouter.name,
                )
              ],
            ),
            _i9.RouteConfig(
              SearchRouter.name,
              path: 'search',
              parent: TabScreenRoute.name,
              guards: [authGuard],
              children: [
                _i9.RouteConfig(
                  SearchRoute.name,
                  path: '',
                  parent: SearchRouter.name,
                )
              ],
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.EmptyRouterPage]
class Auth extends _i9.PageRouteInfo<void> {
  const Auth({List<_i9.PageRouteInfo>? children})
      : super(
          Auth.name,
          path: '/auth',
          initialChildren: children,
        );

  static const String name = 'Auth';
}

/// generated route for
/// [_i2.TabScreenView]
class TabScreenRoute extends _i9.PageRouteInfo<void> {
  const TabScreenRoute({List<_i9.PageRouteInfo>? children})
      : super(
          TabScreenRoute.name,
          path: '/wrapper',
          initialChildren: children,
        );

  static const String name = 'TabScreenRoute';
}

/// generated route for
/// [_i3.LoginView]
class LoginRoute extends _i9.PageRouteInfo<void> {
  const LoginRoute()
      : super(
          LoginRoute.name,
          path: '',
        );

  static const String name = 'LoginRoute';
}

/// generated route for
/// [_i4.RegisterView]
class RegisterRoute extends _i9.PageRouteInfo<void> {
  const RegisterRoute()
      : super(
          RegisterRoute.name,
          path: 'register',
        );

  static const String name = 'RegisterRoute';
}

/// generated route for
/// [_i5.EmailVerificationView]
class EmailVerificationRoute
    extends _i9.PageRouteInfo<EmailVerificationRouteArgs> {
  EmailVerificationRoute({
    String? code,
    _i10.Key? key,
  }) : super(
          EmailVerificationRoute.name,
          path: 'verification/:code',
          args: EmailVerificationRouteArgs(
            code: code,
            key: key,
          ),
          rawPathParams: {'code': code},
        );

  static const String name = 'EmailVerificationRoute';
}

class EmailVerificationRouteArgs {
  const EmailVerificationRouteArgs({
    this.code,
    this.key,
  });

  final String? code;

  final _i10.Key? key;

  @override
  String toString() {
    return 'EmailVerificationRouteArgs{code: $code, key: $key}';
  }
}

/// generated route for
/// [_i1.EmptyRouterPage]
class FeedRouter extends _i9.PageRouteInfo<void> {
  const FeedRouter({List<_i9.PageRouteInfo>? children})
      : super(
          FeedRouter.name,
          path: 'feed',
          initialChildren: children,
        );

  static const String name = 'FeedRouter';
}

/// generated route for
/// [_i1.EmptyRouterPage]
class NotificationsRouter extends _i9.PageRouteInfo<void> {
  const NotificationsRouter({List<_i9.PageRouteInfo>? children})
      : super(
          NotificationsRouter.name,
          path: 'notifications',
          initialChildren: children,
        );

  static const String name = 'NotificationsRouter';
}

/// generated route for
/// [_i1.EmptyRouterPage]
class MyProfileRouter extends _i9.PageRouteInfo<void> {
  const MyProfileRouter({List<_i9.PageRouteInfo>? children})
      : super(
          MyProfileRouter.name,
          path: 'myProfile',
          initialChildren: children,
        );

  static const String name = 'MyProfileRouter';
}

/// generated route for
/// [_i1.EmptyRouterPage]
class SearchRouter extends _i9.PageRouteInfo<void> {
  const SearchRouter({List<_i9.PageRouteInfo>? children})
      : super(
          SearchRouter.name,
          path: 'search',
          initialChildren: children,
        );

  static const String name = 'SearchRouter';
}

/// generated route for
/// [_i6.FeedsView]
class FeedsRoute extends _i9.PageRouteInfo<void> {
  const FeedsRoute()
      : super(
          FeedsRoute.name,
          path: '',
        );

  static const String name = 'FeedsRoute';
}

/// generated route for
/// [_i7.DebugView]
class DebugRoute extends _i9.PageRouteInfo<void> {
  const DebugRoute()
      : super(
          DebugRoute.name,
          path: '',
        );

  static const String name = 'DebugRoute';
}

/// generated route for
/// [_i8.SearchView]
class SearchRoute extends _i9.PageRouteInfo<void> {
  const SearchRoute()
      : super(
          SearchRoute.name,
          path: '',
        );

  static const String name = 'SearchRoute';
}
