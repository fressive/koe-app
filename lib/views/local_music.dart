import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LocalMusicView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("本地音乐"),
      ),
      body: Center(
          child: kIsWeb ? Text("不支持 Web 端本地音乐") : Text("nothing here owo")),
    );
  }
}
