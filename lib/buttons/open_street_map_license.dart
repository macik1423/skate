import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class OSMLicense extends StatelessWidget {
  const OSMLicense({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("© "),
            GestureDetector(
              child: Text(
                "OpenStreetMap",
                style: TextStyle(
                    decoration: TextDecoration.underline, color: Colors.blue),
              ),
              onTap: () {
                launch("https://www.openstreetmap.org/copyright");
              },
            ),
            Text(" contributors"),
          ],
        ),
      ],
    );
  }
}
