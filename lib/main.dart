import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbd/log.dart';
import 'package:tbd/providers/auth.dart';
import 'package:tbd/routes/router.dart';

import 'app.dart';
import 'providers/app.dart';

final dbService = DatabaseService();

void main() async {
  final container = ProviderContainer(
    overrides: [
      databaseService.overrideWith((_) => dbService),
    ],
    observers: [
      ProvidersLogger(),
    ],
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await dbService.initTheme();
  await container.read(authStateNotifierProvider.notifier).initialize();
  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const App(),
    ),
  );
}
