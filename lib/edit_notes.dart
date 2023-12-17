import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesApp/home.dart';
import 'package:notesApp/sql%20DB.dart';

class EditNotes extends StatefulWidget {
  final note;
  final title;
  final color;
  final id;

  const EditNotes({super.key, this.note, this.title, this.id, this.color});

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  SqlDb sqlDb = SqlDb();

  GlobalKey<FormState> formstate = GlobalKey();
  TextEditingController noteController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  @override
  void initState() {
    noteController.text = widget.note;
    titleController.text = widget.title;
    colorController.text = widget.color;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Notes")),
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
                      decoration: InputDecoration(
                        labelText: "note",
                      ),
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
                        //         int resp = await sqlDb.updateData(
                        //             ''' UPDATE notes SET note = "${noteController.text}",
                        // title = "${titleController.text}",
                        // color = "${colorController.text}" WHERE id =${widget.id}
                        // ''');
                        int resp = await sqlDb.update(
                            "notes",
                            {
                              "note": "${noteController.text}",
                              "title": "${titleController.text}",
                              "color": "${colorController.text}"
                            },
                            'id=${widget.id}');
                        print(resp);
                        if (resp > 0) {
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => Home()),
                              (route) => false);
                        }
                      },
                      child: Text("Edit note"),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
