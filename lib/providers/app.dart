//** THEME CONTROLLER */
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tbd/routes/guards.dart';
import 'package:tbd/routes/router.dart';

import '../main.dart';
import '../routes/router.gr.dart';

final themeController = ChangeNotifierProvider<ThemeController>((ref) {
  final database = ref.watch(databaseService);

  return ThemeController(database);
});

class ThemeController with ChangeNotifier {
  ThemeController(this._database);

  late final DatabaseService _database;

  String get theme => _database.savedTheme;

  void toggle(bool mode) {
    (mode)
        ? _database.toggleSaveTheme("dark")
        : _database.toggleSaveTheme("light");

    notifyListeners();
  }
}

// final routerProvider = Provider<AppRouter>((ref) {
//   return AppRouter(authGuard: AuthGuard(container: container));
// });

//** DATABASE CLASS */
final databaseService = Provider<DatabaseService>((_) => DatabaseService());

class DatabaseService {
  late final Box<String> themeBox;

  String get savedTheme => themeBox.values.first;

  Future<void> initTheme() async {
    await Hive.openBox<String>('theme').then((value) => themeBox = value);

    //first time loading
    if (themeBox.values.isEmpty) {
      themeBox.add('light');
    }
  }

  Future<void> toggleSaveTheme(String mode) async =>
      await themeBox.put(0, mode);
}
