import 'package:flutter/material.dart';
import 'package:schooly/models/typeToWidget.dart';

class LinkBox extends StatelessWidget {
  var item;

  LinkBox({this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            if (item['type'] == 'screen') {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TypeToWidget().translations[item['type_data']]),
              );
            }
          },
          child: Column(
            children: <Widget>[
              TopMenuIcon(item['type_data']),
              Text(
                item['text'],
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TopMenuIcon extends StatelessWidget {
  final String type;
  TopMenuIcon(this.type);
  @override
  Widget build(BuildContext context) {
    switch (type) {
      case "events":
        {
          return Icon(Icons.event);
        }
        break;

      case "messages":
        {
          return Icon(Icons.message);
        }
        break;
      case "homework_management":
        {
          return Icon(Icons.book);
        }
        break;
      case "galleries":
        {
          return Icon(Icons.image);
        }
        break;
    }
  }
}
