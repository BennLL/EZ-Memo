import 'dart:math';
import 'package:ez_memo/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class add extends StatefulWidget {
  const add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  final data = FirebaseDatabase.instance;

  @override
  Widget build(BuildContext context) {
    //for IDing the memos
    var random = Random();
    var id = random.nextInt(100000);

    final reference = data.ref().child('Memos/$id');

    return Scaffold(
      appBar: AppBar(
        title: Text("Add a memo"),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              child: TextField(
                controller: title,
                decoration: InputDecoration(
                  hintText: "Title of Memo",
                ),
              ),
            ),
            Container(
              // add decoration stuff
              child: TextField(
                controller: content,
                decoration: InputDecoration(
                  hintText: "contents...",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                reference.set({
                  "Title": title.text,
                  "content": content.text,
                }).asStream();
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => HomePage()));
              },
              child: Text('save'),
            ),
          ],
        ),
      ),
    );
  }
}
