import 'package:flutter/material.dart';
import 'package:ez_memo/auth.dart';
import '../widget_tree.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class add extends StatefulWidget {
  add({super.key});

  final User? user = Auth().currentUser;

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  final DatabaseReference data = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          data.child('notes').push().child(title.text).set({
            "content": content.text,
          }).asStream();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => WidgetTree()));
        },
        child: Icon(
          Icons.save,
          color: Colors.orange,
        ),
      ),
      appBar: AppBar(
        title: Text("Your new memo..."),
      ),
      body: Column(children: [
        TextField(
          controller: title,
          decoration: InputDecoration(
            hintText: "Name of Memo",
          ),
        ),
        TextField(
          controller: content,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            hintText: "Contents...",
          ),
        ),
      ]),
    );
  }
}
