import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:transparent_image/transparent_image.dart';

class FileViewer extends StatelessWidget {
  String fileName;
  FileViewer(this.fileName);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(fileName.split("/").last)),
      ),
      body: Container(
        child: FileBuilder(fileName),
      ),
    );
  }
}

class FileBuilder extends StatelessWidget {
  String fileName;
  FileBuilder(this.fileName);

  Future<PDFDocument> loadDocument() async {
    return await PDFDocument.fromURL(fileName);
  }

  @override
  Widget build(BuildContext context) {
    switch (path.extension(fileName)) {
      case ".jpg":
        {
          if (FileSystemEntity.typeSync(fileName) !=
              FileSystemEntityType.notFound) {
            return Center(child: Image.asset(fileName));
          } else {
            return Stack(children: <Widget>[
              Center(child: CircularProgressIndicator()),
              Center(
                child: FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage, image: fileName),
              ),
            ]);
          }
        }
        break;
      case ".pdf":
        {
          return FutureBuilder<PDFDocument>(
            future:
                loadDocument(), // a previously-obtained Future<String> or null
            builder:
                (BuildContext context, AsyncSnapshot<PDFDocument> snapshot) {
              Widget children;
              if (snapshot.hasData) {
                children = PDFViewer(document: snapshot.data);
              } else if (snapshot.hasError) {
                children = Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                children = Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting result...'),
                );
              }
              return Container(
                child: children,
              );
            },
          );
        }
        break;
    }
  }
}
