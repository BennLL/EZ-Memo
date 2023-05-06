import 'package:firebase_auth/firebase_auth.dart';
import 'package:ez_memo/auth.dart';
import 'package:flutter/material.dart';
import 'addMemo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget _title() {
    return const Text('EZ Memo');
  }

  Widget _userUid() {
    return Text(
      user?.email ?? 'User email',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
        fontStyle: FontStyle.italic,
        decoration: TextDecoration.underline,
      ),
    );
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  final DatabaseReference DATA = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _userUid(),
            _signOutButton(),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => add(),
                ));
              },
              child: const Text('Add'),
            ),

            // Container(
            //   child: StreamBuilder(
            //     stream: DATA.onValue,
            //     builder: (BuildContext context, AsyncSnapshot snapshot) {
            //       if (snapshot.hasData &&
            //           snapshot.data.snapshot.value != null) {
            //         Map<dynamic, dynamic> notesData =
            //             snapshot.data.snapshot.value;
            //         List noteKeys = notesData.keys.toList();
            //         return Container(
            //           child: ListView.builder(
            //             itemCount: noteKeys.length,
            //             itemBuilder: ((context, index) {
            //               String noteKey = noteKeys[index];
            //               String title = notesData[noteKey]['title'];
            //               String content = notesData[noteKey]['content'];

            //               return ListTile(
            //                   title: Text(title),
            //                   subtitle: Text(content),
            //                   trailing: IconButton(
            //                       icon: Icon(Icons.delete),
            //                       onPressed: () {
            //                         DATA.child(noteKey).remove();
            //                       }));
            //             }),
            //           ),
            //         );
            //       } else {
            //         return Center(child: Text('There are currently no memos.'));
            //       }
            //     },
            //   ),
            // )

            // Container(
            //   child: Padding(
            //     padding: const EdgeInsets.all(8.0),
            //     child: ListTile(
            //       trailing: IconButton(
            //         icon: Icon(
            //           Icons.delete,
            //           color: Color.fromARGB(255, 255, 0, 0),
            //         ),
            //         onPressed: () {
            //           DATA.child("notes").remove();
            //         },
            //       ),
            //     ),
            //   ),
            // ),

            // Flexible(
            //   child: new FirebaseAnimatedList(
            //     shrinkWrap: true,
            //     query: DATA,
            //     itemBuilder: (BuildContext context, DataSnapshot snapshot,
            //         Animation<double> animation, int index) {
            //       return new ListTile(
            //         trailing: IconButton(
            //             icon: Icon(Icons.delete),
            //             onPressed: () => DATA.child(snapshot.key).remove()),
            //         title: new Text(snapshot.value['notes']),
            //       );
            //     },
            //   ),
            // ),

            Flexible(
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: DATA.child('notes'),
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  String noteId = snapshot.key ?? '';
                  String title = '';
                  String content = '';

                  if (snapshot.value != null) {
                    Map<dynamic, dynamic> noteMap =
                        snapshot.value as Map<dynamic, dynamic>;
                    if (noteMap.isNotEmpty) {
                      MapEntry<dynamic, dynamic> entry = noteMap.entries.first;
                      title = entry.key.toString();
                      content = entry.value['content'].toString();
                    }
                  }

                  return ListTile(
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () =>
                          DATA.child('notes').child(noteId).remove(),
                    ),
                    title: Text(title),
                    subtitle: Text(content),
                  );
                },
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}
