import 'package:flutter/material.dart';
import 'package:schooly/components/homework/ChildrenList.dart';
import 'package:schooly/components/homework/HomeWork.dart';
import 'package:schooly/providers/classes.provider.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:provider/provider.dart';

class TabedPupils extends StatefulWidget {
  final String currentID;

  TabedPupils({this.currentID});

  @override
  _TabedPupilsState createState() => _TabedPupilsState();
}

class _TabedPupilsState extends State<TabedPupils> {
  var currentDayInfo;

  @override
  Widget build(BuildContext context) {
    var classProviderHolder = context.watch<ClassProvider>();

    currentDayInfo = classProviderHolder.dayInfo.data
        .firstWhere((i) => i.id == widget.currentID);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text('אירועים בשיעור'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text('שיעורי בית'),
              ),
              /*Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text('תכנון שבועי'),
              ),*/
            ],
          ),
          title: Text(currentDayInfo.name),
        ),
        body: TabBarView(
          children: [
            ChildrenList(currentId: currentDayInfo.id),
            HomeWork(currentId: currentDayInfo.id),
            /*Icon(Icons.directions_bike),*/
          ],
        ),
      ),
    );
  }
}
