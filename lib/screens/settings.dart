import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app.dart';

class Setting extends ConsumerWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeController).theme;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.keyboard_backspace),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        elevation: 0.0,
        title: const Text(
          "Settings",
          style: TextStyle(),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            const ListTile(
              title: Text(
                "About",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              subtitle: Text(
                "Insert About Description Made by Dunccan de Weerdt & Menno van Leeuwen",
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text(
                'Dark Theme',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                ),
              ),
              subtitle: const Text("Use the dark mode"),
              value: (mode == 'dark') ? true : false,
              onChanged: (value) =>
                  ref.watch(themeController.notifier).toggle(value),
            ),
          ],
        ),
      ),
    );
  }
}
