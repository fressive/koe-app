import 'package:flutter/material.dart';
import 'package:koe/common/global.dart';

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("关于"),
        ),
        body: Center(
          child: Column(
            children: [
              Text(
                "Koe (Flutter Client)",
                style: Theme.of(context).textTheme.headline5,
              ),
              Text("v${Global.version}",
                  style: Theme.of(context).textTheme.subtitle1),
              SizedBox(
                height: 8,
              ),
              Text("Koe 是一个开源的、跨平台的音乐库解决方案。",
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(
                height: 8,
              ),
              Text("Github - fressive/koe-flutter",
                  style: Theme.of(context).textTheme.caption)
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ));
  }
}
