import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tbd/screens/settings.dart';

import '../utils/constants.dart';

class ProfileContainer extends StatelessWidget {
  const ProfileContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO: add StatusViewModel Provider
    return IconButton(
      onPressed: () => showProfileMenu(context),
      icon: const Icon(
        Icons.menu,
      ),
    );
  }
}

showProfileMenu(
  BuildContext context,
) {
  return showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    builder: (BuildContext context) {
      return FractionallySizedBox(
        heightFactor: .4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16.0),
            Center(
              child: Container(
                height: 5,
                width: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),

            ListTile(
              leading: Icon(
                Ionicons.settings_outline,
                size: 24.0,
                color: Theme.of(context).colorScheme.secondary,
              ),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (_) => Setting(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Icon(
            //     CupertinoIcons.camera_on_rectangle,
            //     size: 25.0,
            //   ),
            //   title: Text('Add to story'),
            //   onTap: () async {
            //     // Navigator.pop(context);
            //     // await viewModel.pickImage(context: context);
            //   },
            // ),
          ],
        ),
      );
    },
  );
}
