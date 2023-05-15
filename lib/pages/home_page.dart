import 'package:firebase_auth/firebase_auth.dart';
import 'package:ez_memo/auth.dart';
import 'package:flutter/material.dart';
import 'addMemo.dart';
import 'edit_page.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:math';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final User? user = Auth().currentUser;

  Color getRandomShade() {
    Random random = Random();
    int num = random.nextInt(6);
    if (num == 0) {
      return Color.fromARGB(255, 185, 243, 252);
    }
    if (num == 1) {
      return Color.fromARGB(255, 174, 226, 255);
    }
    if (num == 2) {
      return Color.fromARGB(255, 147, 198, 231);
    }
    if (num == 3) {
      return Color.fromARGB(255, 254, 222, 255);
    }
    if (num == 4) {
      return Color.fromARGB(255, 236, 242, 255);
    }
    if (num == 5) {
      return Color.fromARGB(255, 227, 223, 253);
    }

    return Color.fromARGB(255, 256, 256, 256);
  }

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
        border: Border.all(width: 2, color: Color.fromARGB(255, 94, 90, 90)),
        borderRadius: BorderRadius.circular(8),
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
                reverse: true,
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
                    margin: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(
                            255, 126, 121, 121), // Set the border color
                        width: 2.0, // Set the border width
                      ),
                      borderRadius: BorderRadius.circular(
                          8.0), // Set border radius if desired
                      color: getRandomShade(), // Set the background color here
                    ),
                    height: 90,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => edit(
                            noteId: noteId,
                            title: title,
                            content: content,
                          ),
                        ));
                      },
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
