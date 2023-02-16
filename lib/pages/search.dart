import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../utils/constants.dart';
import '../widgets/indicators.dart';

class Search extends StatefulHookWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin {
  // User? user;
  // TextEditingController searchController = TextEditingController();
  // FirebaseAuth auth = FirebaseAuth.instance;
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // List<DocumentSnapshot> users = [];
  List filteredUsers = [];
  bool loading = true;

  // currentUserId() {
  //   return firebaseAuth.currentUser!.uid;
  // }

  // getUsers() async {
  //   QuerySnapshot snap = await usersRef.get();
  //   List<DocumentSnapshot> doc = snap.docs;
  //   users = doc;
  //   filteredUsers = doc;
  //   setState(() {
  //     loading = false;
  //   });
  // }

  // search(String query) {
  //   if (query == "") {
  //     filteredUsers = users;
  //   } else {
  //     List userSearch = users.where((userSnap) {
  //       Map user = userSnap.data() as Map<String, dynamic>;
  //       String userName = user['username'];
  //       return userName.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //     setState(() {
  //       filteredUsers = userSearch as List<DocumentSnapshot<Object?>>;
  //     });
  //   }
  // }

  // removeFromList(index) {
  //   filteredUsers.removeAt(index);
  // }

  @override
  void initState() {
    // getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fn = useFocusNode();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Constants.appName,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.secondary,
        // onRefresh: () => getUsers(),
        onRefresh: () => throw UnimplementedError(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: buildSearch(fn),
            ),
            const SizedBox(height: 16),
            buildUsers(),
          ],
        ),
      ),
    );
  }

  buildSearch(fn) {
    return Row(
      children: [
        Container(
          height: 36.0,
          width: MediaQuery.of(context).size.width - 50,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: TextFormField(
              // controller: searchController,
              focusNode: fn,
              textAlignVertical: TextAlignVertical.center,
              maxLength: 20,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
              ],
              textCapitalization: TextCapitalization.sentences,
              onChanged: (query) {
                // search(query);
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                suffixIcon: GestureDetector(
                  //TODO: Add check to see if textfield is not empty before showing clear button
                  onTap: () {
                    // searchController.clear();
                  },
                  child: Icon(
                    Ionicons.close_outline,
                    // size: 12.0,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),

                // contentPadding: EdgeInsets.only(bottom: 10.0, left: 10.0),

                border: InputBorder.none,
                counterText: '',
                hintText: 'Search...',
                hintStyle: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  buildUsers() {
    if (!loading) {
      if (filteredUsers.isEmpty) {
        return const Center(
          child: Text(
            "No User Found",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      } else {
        return Expanded(
          child: Container(
            child: ListView.builder(
              // itemCount: filteredUsers.length,
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                // DocumentSnapshot doc = filteredUsers[index];
                // UserModel user =
                //     UserModel.fromJson(doc.data() as Map<String, dynamic>);
                // if (doc.id == currentUserId()) {
                //   Timer(Duration(milliseconds: 500), () {
                //     setState(() {
                //       removeFromList(index);
                //     });
                //   });
                // }
                return ListTile(
                  // onTap: () => showProfile(context, profileId: user.id!),
                  onTap: () => throw UnimplementedError(),
                  // leading: user.photoUrl!.isEmpty
                  //     ? CircleAvatar(
                  //         radius: 20.0,
                  //         backgroundColor:
                  //             Theme.of(context).colorScheme.secondary,
                  //         child: Center(
                  //           child: Text(
                  //             '${user.username![0].toUpperCase()}',
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 15.0,
                  //               fontWeight: FontWeight.w900,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : CircleAvatar(
                  //         radius: 20.0,
                  //         backgroundImage: CachedNetworkImageProvider(
                  //           '${user.photoUrl}',
                  //         ),
                  //       ),
                  title: Text(
                    '@Username',
                    // user.username!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'First name Last Name' //TODO: Swap username and name around depending on @ search prefix
                      // user.email!,
                      ),
                  // trailing: GestureDetector(
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       CupertinoPageRoute(
                  //         builder: (_) => throw UnimplementedError(),
                  // StreamBuilder(
                  //   stream: chatIdRef
                  //       .where(
                  //         "users",
                  //         isEqualTo: getUser(
                  //           firebaseAuth.currentUser!.uid,
                  //           doc.id,
                  //         ),
                  //       )
                  //       .snapshots(),
                  //   builder: (context,
                  //       AsyncSnapshot<QuerySnapshot> snapshot) {
                  //     if (snapshot.hasData) {
                  //       var snap = snapshot.data;
                  //       List docs = snap!.docs;
                  //       print(snapshot.data!.docs.toString());
                  //       return docs.isEmpty
                  //           ? Conversation(
                  //               userId: doc.id,
                  //               chatId: 'newChat',
                  //             )
                  //           : Conversation(
                  //               userId: doc.id,
                  //               chatId:
                  //                   docs[0].get('chatId').toString(),
                  //             );
                  //     }
                  //     return Conversation(
                  //       userId: doc.id,
                  //       chatId: 'newChat',
                  //     );
                  //   },
                  // ),
                  //     ),
                  //   );
                  // },
                  // child: Container(
                  //   height: 30.0,
                  //   width: 62.0,
                  //   decoration: BoxDecoration(
                  //     color: Theme.of(context).colorScheme.secondary,
                  //     borderRadius: BorderRadius.circular(3.0),
                  //   ),
                  //   child: Center(
                  //     child: Padding(
                  //       padding: const EdgeInsets.all(5.0),
                  //       child: Text(
                  //         'Message',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 12.0,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // ),
                );
              },
            ),
          ),
        );
      }
    } else {
      return Center(
        child: circularProgress(context),
      );
    }
  }

  showProfile(BuildContext context, {String? profileId}) {
    throw UnimplementedError();
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(
    //     builder: (_) => Profile(profileId: profileId),
    //   ),
    // );
  }

  //get concatenated list of users
  //this will help us query the chat id reference in other
  // to get the correct user id

  String getUser(String user1, String user2) {
    user1 = user1.substring(0, 5);
    user2 = user2.substring(0, 5);
    List<String> list = [user1, user2];
    list.sort();
    var chatId = "${list[0]}-${list[1]}";
    return chatId;
  }

  @override
  bool get wantKeepAlive => true;
}
