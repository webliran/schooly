import 'package:flutter/material.dart';
import 'package:schooly/components/fileviewer/FileViewer.dart';

class FileAtt extends StatelessWidget {
  final file;
  FileAtt({this.file});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: ListTile(
        leading: Icon(Icons.file_present),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FileViewer(file),
            ),
          );
        },
        title: Text(file.split("/").last),
      ),
    );
  }
}
