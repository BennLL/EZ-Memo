import 'package:flutter/material.dart';
import 'package:ez_memo/auth.dart';
import '../widget_tree.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class add extends StatefulWidget {
  add({super.key});

  @override
  State<add> createState() => _addState();
}

class _addState extends State<add> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  final DatabaseReference data = FirebaseDatabase.instance.ref();
  User? user;

  @override
  void initState() {
    super.initState();
    user = Auth().currentUser;
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    // final appBarHeight = AppBar().preferredSize.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          data.child(user!.uid).push().child(title.text).set({
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
      body: Column(
        children: [
          TextField(
            controller: title,
            decoration: InputDecoration(
              hintText: "Name of Memo",
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            ),
          ),
          SizedBox(
            // height: screenHeight - appBarHeight - kToolbarHeight,
            height: MediaQuery.of(context).size.height - 170,
            child: SingleChildScrollView(
              child: TextField(
                controller: content,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                scrollPhysics: ClampingScrollPhysics(),
                decoration: InputDecoration(
                  hintText: "Contents...",
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
