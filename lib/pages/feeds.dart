import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tbd/pages/debug.dart';

import '../utils/constants.dart';

class FeedsView extends StatefulWidget {
  const FeedsView({super.key});

  @override
  FeedsViewState createState() => FeedsViewState();
}

class FeedsViewState extends State<FeedsView>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int page = 5;
  bool loadingMore = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          page = page + 5;
          loadingMore = true;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Constants.appName,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Ionicons.chatbubble_ellipses,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  // builder: (_) => Chats(),
                  builder: (_) => const DebugView(),
                ),
              );
            },
          ),
          const SizedBox(width: 20.0),
        ],
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        onRefresh: () => throw UnimplementedError(),
        // postRef.orderBy('timestamp', descending: true).limit(page).get(),
        child: SingleChildScrollView(
          // controller: scrollController,
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // StoryWidget(),
              Container(
                height: MediaQuery.of(context).size.height,
                // child: FutureBuilder(
                //   future: postRef
                //       .orderBy('timestamp', descending: true)
                //       .limit(page)
                //       .get(),
                //   builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                //     if (snapshot.hasData) {
                //       var snap = snapshot.data;
                //       List docs = snap!.docs;
                //       return ListView.builder(
                //         controller: scrollController,
                //         itemCount: docs.length,
                //         shrinkWrap: true,
                //         itemBuilder: (context, index) {
                //           PostModel posts =
                //               PostModel.fromJson(docs[index].data());
                //           return Padding(
                //             padding: const EdgeInsets.all(10.0),
                //             child: UserPost(post: posts),
                //           );
                //         },
                //       );
                //     } else if (snapshot.connectionState ==
                //         ConnectionState.waiting) {
                //       return circularProgress(context);
                //     } else
                //       return Center(
                //         child: Text(
                //           'No Feeds',
                //           style: TextStyle(
                //             fontSize: 26.0,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       );
                //   },
                // ),

                child: Center(
                  child: Text(
                    'No Feeds',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
