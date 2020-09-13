import 'package:flutter/material.dart';
import 'package:schooly/models/typeToWidget.dart';

class LinkBox extends StatelessWidget {
  var item;

  LinkBox({this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Image.network(item['image']),
            Text(
              item['text'],
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}
