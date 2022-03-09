import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'StoryList.dart';
import 'main.dart';


class StoryCreator extends StatefulWidget {
  const StoryCreator({Key? key}) : super(key: key);
  @override
  _StoryCreatorState createState() => _StoryCreatorState();
}

class _StoryCreatorState extends State<StoryCreator> {
  String story = '';
  Queue<String> words = Queue();
  Timer? timer;
  Timer? addWord;
  bool buttonVis = true;
  List<Widget> display = [];
  late File storyFile;
  late IOSink file;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String nextColor = "black";

  void nextWord() async {
    await Future.delayed(Duration(milliseconds: randomTime()));
    if(words.isEmpty){return;}
    setState(() {
      story += "${words.removeFirst()} ";
    });
  }

  int randomTime(){
    return Random().nextInt(300);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  display = [
            Expanded(
              child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Text(story, style: const TextStyle(fontSize: 15),)),),
            SizedBox(
                height: 90,
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: buttonVis ? IconButton(
                        onPressed: buttonPress,
                        padding: EdgeInsets.zero,
                        iconSize: 70,
                        icon: Icon(Icons.circle, color: Theme.of(context).accentColor))
                        :
                    SpinKitWave(
                      color: Theme.of(context).accentColor,),),)),],),),
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Urban Stories"),
        centerTitle: true,
        leading: IconButton(
          iconSize: 30,
          icon: const Icon(Icons.folder),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StoryList())),),),
      floatingActionButton: Visibility(
        child:FloatingActionButton(
          onPressed: stopCreation,
          child: const Icon(Icons.stop, size: 50),
          backgroundColor: Theme.of(context).accentColor,),
        visible: !buttonVis,),);
  }

  void pollLocation() async {
    Position position = await _getGeoLocationPosition();
    var response = await http.get(Uri.parse('https://young-reef-65444.herokuapp.com/?lat=${position.latitude}&lon=${position.longitude}'));
    setState(() {
      words.addAll(response.body.split(" "));
      file.write(response.body);
    });
  }

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // Test if we have permission to use the location service
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }

  void stopCreation(){
    timer?.cancel();
    setState(() {
      buttonVis = true;
    });
    file.close();
  }

  void changeColor(){
      switch(nextColor){
        case "purple":
          colorTheme("purple");
          nextColor = "black";
          break;
        case "black":
          colorTheme("black");
          nextColor = "purple";
          break;
      }
      setState(() {});
  }

  // Called when the Begin Tracking button is pressed
  void buttonPress() async{
    setState(() {
      story = "";
      // Every time this goes off a new location is polled
      timer = Timer.periodic(
                  const Duration(seconds: 15),
                  (Timer t) => pollLocation());
      // Every time this goes off a new word is shown
      addWord = Timer.periodic(
                  const Duration(milliseconds: 100),
                  (Timer t) => nextWord());
      buttonVis = false;
    });
    pollLocation();

    // This finds the applications documents directory for the device
    getApplicationDocumentsDirectory().then((documents) {
      DateTime now = DateTime.now();
      String name = "${now.day}-${now.month}-${now.year} ${now.hour}:";
      if(now.minute < 10){
        name += "0${now.minute}";
      } else{
        name += "${now.minute}";
      }
      String filename = "${documents.path}/stories/$name";
      File(filename)
          .create(recursive: true)
          .then((result) {
            storyFile = result;
            file = storyFile.openWrite();
            _prefs.then((prefs){
              try{
                List<String>? fs = prefs.getStringList("stories");
                fs?.add(name);
                prefs.setStringList("stories", fs!);
              } catch(e){
                prefs.setStringList("stories", [name]);
              }
            });
          });

    });

  }

}