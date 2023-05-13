import 'package:flutter/material.dart';
import 'package:ez_memo/auth.dart';
import '../widget_tree.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class edit extends StatefulWidget {
  final String noteId;
  final String title;
  final String content;

  edit({
    required this.noteId,
    required this.title,
    required this.content,
  });

  @override
  State<edit> createState() => _editState();
}

class _editState extends State<edit> {
  late TextEditingController title = TextEditingController();
  late TextEditingController content = TextEditingController();
  final DatabaseReference data = FirebaseDatabase.instance.ref();
  User? user;

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.title);
    content = TextEditingController(text: widget.content);
    user = Auth().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            String updatedTitle = title.text.isNotEmpty ? title.text : "Unititled";
            String updatedContent = content.text.isNotEmpty ? title.text : "";
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => WidgetTree()));
          },
          child: Icon(
            Icons.save,
            color: Colors.orange,
          ),
        ),
        appBar: AppBar(
          title: Text("Edit this memo"),
        ),
        body: Column(children: [
          TextField(
            controller: title,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 170,
            child: SingleChildScrollView(
              child: TextField(
                controller: content,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                scrollPhysics: ClampingScrollPhysics(),
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
              ),
            ),
          ),
        ]));
  }
}
