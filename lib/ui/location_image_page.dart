import 'package:flutter/material.dart';

class LocationImage extends StatelessWidget {
  const LocationImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(child: Image.asset('asset/photos/A01-001.png')),
    );
  }
}
