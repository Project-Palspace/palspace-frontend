import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FabContainer extends StatelessWidget {
  final Widget? page;
  final IconData icon;
  final bool mini;

  const FabContainer(
      {super.key, this.page, required this.icon, this.mini = false});

  @override
  Widget build(BuildContext context) {
    //TODO: add StatusViewModel Provider
    return OpenContainer(
      transitionType: ContainerTransitionType.fade,
      openBuilder: (BuildContext context, VoidCallback _) {
        return page!;
      },
      closedElevation: 4.0,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(56 / 2),
        ),
      ),
      closedColor: Theme.of(context).scaffoldBackgroundColor,
      closedBuilder: (BuildContext context, VoidCallback openContainer) {
        return FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            chooseUpload(
              context,
            );
          },
          mini: mini,
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      },
    );
  }
}

chooseUpload(
  BuildContext context,
) {
  //TODO: add StatusViewModel viewModel getter

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
            const SizedBox(height: 20.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Center(
                child: Text(
                  'Choose Upload',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(
                CupertinoIcons.camera_on_rectangle,
                size: 25.0,
              ),
              title: const Text('Make a post'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    // builder: (_) => CreatePost(),
                    builder: (_) => throw UnimplementedError(),
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
