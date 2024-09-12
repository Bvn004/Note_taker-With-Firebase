import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertodo/firestore.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  firestoreservice firestore = firestoreservice();
  String? docidd;
  final TextEditingController _Notecontroller = TextEditingController();

  final List<String> _addednotes = [];
  @override
  Widget build(BuildContext context) {
    void showdialogg(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            autocorrect: true,
            decoration: InputDecoration(hintText: "Add Note"),
            controller: _Notecontroller,
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  // setState(() {
                  //  _addednotes.add(_Notecontroller.text);

                  // });
                  firestore.addnote(_Notecontroller.text);
                  print(_Notecontroller.text);
                  _addednotes.add(_Notecontroller.text);
                  _Notecontroller.clear();

                  Navigator.pop(context);
                },
                child: Text("add")),
          ],
        ),
      );
    }

    void showEditDialog(BuildContext context, String? Docid) {
      //  _addednotes[index] = _Notecontroller.text;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            autocorrect: true,
            decoration: InputDecoration(hintText: "Edit Note"),
            controller: _Notecontroller,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                /* setState(() {
                  _addednotes[index] = _Notecontroller.text;
                });*/

                firestore.updatenotes(Docid!, _Notecontroller.text);
                _Notecontroller.clear();
                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        ),
      );
    }

    /* void _deletenote(int index) {
      setState(() {
        _addednotes.removeAt(index);
      });
    } */

    Widget _addnoteUI() {
      return Align(
        alignment: Alignment.bottomRight,
        child: ElevatedButton(
            iconAlignment: IconAlignment.end,
            onPressed: () {
              return showdialogg(context);
            },
            child: Text("Add note")),
      );
    }

    Widget _textcontainer(int index, String notetext, String Docid) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Color.fromARGB(255, 242, 216, 255),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 4,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.only(left: 10), child: Text(notetext)),
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        showEditDialog(context, docidd);
                      },
                      icon: Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        firestore.deletenote(Docid);
                      },
                      icon: Icon(Icons.delete))
                ],
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("notes app"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestore.getnotesstream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List notesList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = notesList[index];
                      String Docid = document.id;
                      docidd = Docid;

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String noteText = data['note'];

                      return _textcontainer(index, noteText, Docid);
                    },
                  );
                } else {
                  return Text("No notes!!");
                }
              },
            ),
          ),
          _addnoteUI(),
          const SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}
