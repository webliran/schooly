import 'package:flutter/material.dart';
import 'package:schooly/components/homepage/LinkBox.dart';
import 'package:schooly/providers/login.provider.dart';
import 'package:provider/provider.dart';

class MainLinksBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loginProviderHolder =
        context.select((LoginProvider login) => login.selectedUser);
    return Material(
      elevation: 4,
      child: Container(
        height: 90,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: loginProviderHolder['resources']['secondary_menu_buttons']
              .where((item) => [
                    "events",
                    "messages",
                    "homework_management",
                    "galleries"
                  ].contains(item["type_data"]))
              .map<Widget>((item) {
            return Expanded(child: LinkBox(item: item));
          }).toList(),
        ),
      ),
    );
  }
}
