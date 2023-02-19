import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tbd/pages/debug.dart';
import 'package:tbd/routes/guards.dart';

import '../app.dart';
import '../auth/login/login.dart';
import '../auth/register/register.dart';
import '../auth/verification/verification.dart';
import '../pages/feeds.dart';
import '../pages/search.dart';
import '../providers/auth.dart';
import '../screens/mainscreen.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'View,Route',
  preferRelativeImports: true,
  routes: <AutoRoute>[
    AutoRoute(
      path: '/auth',
      name: 'auth',
      page: EmptyRouterPage,
      children: <AutoRoute>[
        AutoRoute(
          path: '',
          page: LoginView,
        ),
        AutoRoute(
          path: 'register',
          page: RegisterView,
        ),
        AutoRoute(
          path: 'verification',
          page: EmailVerificationView,
        ),
      ],
    ),
    AutoRoute(
      initial: true,
      guards: [AuthGuard],
      path: '/wrapper',
      page: TabScreenView,
      children: <AutoRoute>[
        AutoRoute(
          guards: [AuthGuard],
          path: 'feed',
          name: 'FeedRouter',
          page: EmptyRouterPage,
          children: <AutoRoute>[
            AutoRoute(
              path: '',
              page: FeedsView,
            ),
          ],
        ),
        AutoRoute(
          guards: [AuthGuard],
          path: 'notifications',
          name: 'NotificationsRouter',
          page: EmptyRouterPage,
          children: <AutoRoute>[
            AutoRoute(
              path: '',
              page: DebugPage, //TODO: Add page
            ),
          ],
        ),
        AutoRoute(
          guards: [AuthGuard],
          path: 'myProfile',
          name: 'MyProfileRouter',
          page: EmptyRouterPage,
          children: <AutoRoute>[
            AutoRoute(
              path: '',
              page: DebugPage, //TODO: add page
            ),
          ],
        ),
        AutoRoute(
          guards: [AuthGuard],
          path: 'search',
          name: 'searchRouter',
          page: EmptyRouterPage,
          children: <AutoRoute>[
            AutoRoute(
              path: '',
              page: SearchView,
            ),
          ],
        ),
      ],
    ),
  ],
)
class $AppRouter {}
