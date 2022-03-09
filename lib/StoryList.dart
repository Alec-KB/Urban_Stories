import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'StoryViewer.dart';

class StoryList extends StatefulWidget{
  const StoryList({Key? key}) : super(key: key);

  @override
  _StoryList createState() => _StoryList();

}

class _StoryList extends State<StoryList>{

  List<String>? stories = [];
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<Widget> tiles = [];
  bool tilesUpdated = true;


  // Gets the list of story names, and builds a list that allows the user to see them
  void buildTiles(){
    if(tilesUpdated) {
      tiles = [const Divider(thickness: 2,)];
      _prefs.then((prefs) {
        try {
          stories = prefs.getStringList("stories");
        } catch (e) {
          stories = [];
        }

        for (String story in stories!) {
          tiles.add(
              ListTile(
                title: Text(story),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => {deleteFile(story)},),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => StoryView(storyName: story))),));
          tiles.add(const Divider(thickness: 2,));
        }
        tilesUpdated = false;
        setState(() {});
      });
    }
  }

  // Deletes a saved story from device and key/value storage, then rebuilds the list
  void deleteFile(String name){
    getApplicationDocumentsDirectory().then((documents) {
      File("${documents.path}/stories/$name");
      _prefs.then((value) {
        List<String>? keys = value.getStringList("stories");
        keys?.remove(name);
        tilesUpdated = true;
        value.setStringList("stories", keys!).then((value) => {
          setState(() {})
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    buildTiles();
    return Scaffold(
      appBar: AppBar(
          title: const Text("Story List"),),
      body: SingleChildScrollView(
        child: Column(
          children: tiles,),),);
  }
}