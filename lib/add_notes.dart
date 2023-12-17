import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesApp/home.dart';
import 'package:notesApp/sql%20DB.dart';

class AddNotes extends StatefulWidget {
  const AddNotes({super.key});

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> {
  SqlDb sqlDb = SqlDb();

  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Notes")),
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Form(
                key: formstate,
                child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(labelText: "title"),
                    ),
                    TextFormField(
                      controller: noteController,
                      decoration: InputDecoration(labelText: "note"),
                    ),
                    TextFormField(
                      controller: colorController,
                      decoration: InputDecoration(labelText: "color"),
                    ),
                    Container(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        // int resp = await sqlDb.insertData(''' INSERT INTO notes ('note','title','color')
                        // VALUES ("${noteController.text}","${titleController.text}","${colorController.text}") ''');
                        int resp = await sqlDb.insert("notes", {
                          'note': "${noteController.text}",
                          'title': "${titleController.text}",
                          'color': "${colorController.text}",
                        });
                        print(resp);
                        if (resp > 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (route) => false);
                        }
                      },
                      child: Text("Add note"),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
