import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notesApp/edit_notes.dart';
import 'package:notesApp/sql%20DB.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SqlDb sqlDb = SqlDb();
  List notes = []; //add data from DB in this array
  bool load = true;

  Future<List<Map>> readData() async {
    //List<Map> response = await sqlDb.readData("SELECT * FROM notes");
    List<Map> response = await sqlDb.read("notes");
    notes.addAll(response);
    load = false;
    if (this.mounted) {
      setState(() {});
    }
    return response;
  }

  @override
  void initState() {
    readData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Home Page"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addnotes");
          },
          child: Icon(Icons.add),
        ),
        body: load
            ? Center(child: CircularProgressIndicator())
            : Container(
                child: ListView(
                  children: [
                    Center(
                        child: ElevatedButton(
                            onPressed: () {
                              sqlDb.deleteDb();
                            },
                            child: Text("Delete DB"))),
                    ListView.builder(
                        itemCount: notes.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Card(
                              child: ListTile(
                            title: Text("title: ${notes[i]['title']}"),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("note: ${notes[i]['note']}"),
                                Text("color: ${notes[i]['color']}"),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    // int resp = await sqlDb.deleteData(
                                    //     "DELETE FROM notes WHERE id =${notes[i]['id']}"); //delete from DB
                                    int resp = await sqlDb.delete(
                                        "notes", "id =${notes[i]['id']}");
                                    if (resp > 0) //delete from UI
                                    {
                                      //refresh page
                                      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> Home()));
                                      notes.removeWhere((element) =>
                                          element['id'] == notes[i]['id']);
                                      setState(() {});
                                    }
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => EditNotes(
                                                  color: notes[i]['color'],
                                                  note: notes[i]['note'],
                                                  title: notes[i]['title'],
                                                  id: notes[i]['id'],
                                                )));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ));
                        })
                  ],
                ),
              ));
  }
}
