import 'package:flutter/material.dart';

Drawer buildDrawer(BuildContext context, String currentRoute) {
  return Drawer(
    child: ListView(
      children: <Widget>[
        const DrawerHeader(
          child: Center(
            child: Text('Location Examples'),
          ),
        ),
      ],
    ),
  );
}
