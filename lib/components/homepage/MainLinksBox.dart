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
        width: double.infinity,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          children: loginProviderHolder['resources']['secondary_menu_buttons']
              .map<Widget>((item) {
            //print(item);
            return LinkBox(item: item);
          }).toList(),
        ),
      ),
    );
  }
}
