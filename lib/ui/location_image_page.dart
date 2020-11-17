import 'package:flutter/material.dart';

class LocationImage extends StatelessWidget {
  const LocationImage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      // 향후 PhotoView활용하여 확대 축소 Pan 기능 구현 필요
      child: Card(child: Image.asset('asset/Plan2.png')),
    );
  }
}
