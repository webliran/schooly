import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/rendering.dart';

import 'package:schooly/providers/classes.provider.dart';

class Messages extends StatefulWidget {
  final String currentId;

  Messages({this.currentId});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  ScrollController scrollController;
  bool dialVisible = true;

  void initState() {
    super.initState();

    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection ==
            ScrollDirection.forward);
      });
  }

  void setDialVisible(bool value) {
    setState(() {
      dialVisible = value;
    });
  }

  @override
  SafeArea buildSpeedDial(classProviderHolder) {
    Map<String, String> filesPaths;

    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: SpeedDial(
          marginRight: 40,
          animatedIcon: AnimatedIcons.add_event,
          animatedIconTheme: IconThemeData(size: 30.0),
          // child: Icon(Icons.add),
          onOpen: () => print('OPENING DIAL'),
          onClose: () => print('DIAL CLOSED'),
          visible: dialVisible,
          curve: Curves.bounceIn,
          children: [
            SpeedDialChild(
              child: Icon(Icons.camera_alt),
              backgroundColor: Colors.deepOrange,
              onTap: () => print('FIRST CHILD'),
            ),
            SpeedDialChild(
              child: Icon(Icons.file_upload),
              backgroundColor: Colors.green,
              onTap: () async {},
            )
          ],
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    var classProviderHolder = context.watch<ClassProvider>();

    return Scaffold(
        body: Container(
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: Column(
              children: [],
            ),
          ),
        ),
        floatingActionButton: buildSpeedDial(classProviderHolder));
  }
}
