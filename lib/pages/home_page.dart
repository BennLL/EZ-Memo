import 'package:firebase_auth/firebase_auth.dart';
import 'package:ez_memo/auth.dart';
import 'package:flutter/material.dart';
import 'addMemo.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:math';

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
    return Container(
      padding: EdgeInsets.fromLTRB(5, 6, 0, 10),
      height: 37.5,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
        ),
        borderRadius: BorderRadius.circular(2),
      ),
      width: 230,
      child: Text(
        user?.email ?? 'User email',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontStyle: FontStyle.italic,
          decoration: TextDecoration.underline,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
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
            Row(
              children: [
                _userUid(),
                _signOutButton(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => add(),
                    ));
                  },
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ), // Adjust the padding values to change the button size
                  ),
                ),
              ],
            ),
            Text('Your Notes:'),
            Flexible(
              child: FirebaseAnimatedList(
                shrinkWrap: true,
                query: DATA.child(user!.uid),
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
                  return Container(
                    height: 90,
                    color: Color(Random().nextInt(0xffffffff)),
                    child: ListTile(
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () =>
                            DATA.child(user!.uid).child(noteId).remove(),
                      ),
                      title: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
