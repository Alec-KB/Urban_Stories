import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class StoryView extends StatefulWidget{

  final String storyName;
  const StoryView ({ Key? key, required this.storyName }): super(key: key);

  @override
  _StoryViewer createState() => _StoryViewer();

}

class _StoryViewer extends State<StoryView>{
  String text = "";

  @override
  void initState(){
    super.initState();
    getText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storyName),
        centerTitle: true,),
      body: Text(text,
        style: Theme.of(context).textTheme.bodyText1,));
  }

  void getText(){
    getApplicationDocumentsDirectory().then((documents) {
      String filename = "${documents.path}/stories/${widget.storyName}";
      File(filename).readAsString().then((value) {
        setState(() {
          text = value;
        });
      });
    });
  }

}