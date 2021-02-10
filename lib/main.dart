import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:koe/views/cloud_music.dart';
import 'package:koe/views/home.dart';
import 'package:koe/widgets/bottom_player_bar.dart';

import 'package:koe/common/global.dart';
import 'package:koe/views/local_music.dart';
import 'package:koe/views/settings.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Global.init().then((e) {
    runApp(MyApp());
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
          SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }).catchError((e) => print(e));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        allowFontScaling: true,
        builder: () => GetMaterialApp(
              title: 'Koe',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              darkTheme: ThemeData.dark(),
              home: MyHomePage(title: '主页'),
            ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isHome = true;
  bool inited = false;

  BuildContext naviCtx;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => {inited = true});
    return Scaffold(
      body: Navigator(
        initialRoute: '/home',
        onGenerateRoute: (val) {
          WidgetBuilder builder;
          switch (val.name) {
            case '/settings':
              builder = (ctx) => SettingsView();
              break;
            case '/cloud_music':
              builder = (ctx) => CloudMusicView();
              break;
            case '/local_music':
              builder = (ctx) => LocalMusicView();
              break;
            case '/':
            case '/home':
              builder = (ctx) => HomeView();
              break;
          }

          return MaterialPageRoute(builder: builder, settings: val);
        },
        onPopPage: (route, result) => route.didPop(result),
      ),
      floatingActionButton: Container(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          tooltip: 'Increment',
          child: CircleAvatar(
            radius: 60,
            backgroundImage: NetworkImage(
              'https://p2.music.126.net/0ti0zrM-yQd0crfk4mfv_Q==/109951163298379277.jpg?imageView=1&type=webp&thumbnail=378x0',
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      bottomNavigationBar: BottomPlayerBarWidget(),
    );
  }
}
