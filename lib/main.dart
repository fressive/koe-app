import 'dart:async';
import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:koe/views/cloud_music.dart';
import 'package:koe/views/download_manager_view.dart';
import 'package:koe/views/home.dart';
import 'package:koe/views/open_source_licenses.dart';
import 'package:koe/views/playing_view.dart';
import 'package:koe/views/song_upload.dart';
import 'package:koe/widgets/bottom_player_bar.dart';

import 'package:koe/common/global.dart';
import 'package:koe/views/local_music.dart';
import 'package:koe/views/settings.dart';

import 'controller/SongInformationController.dart';
import 'models/model.dart';
import 'views/about.dart';

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
    Get.changeTheme(ThemeData.dark());
    return ScreenUtilInit(
        designSize: Size(360, 690),
        builder: () => GetMaterialApp(
              debugShowCheckedModeBanner: false,
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
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late StreamSubscription _songChangedEvent;

  bool isHome = true;
  bool inited = false;

  late BuildContext naviCtx;

  @override
  dispose() {
    super.dispose();
    _songChangedEvent.cancel();
  }

  final SongInformationController c = Get.put(SongInformationController());

  _MyHomePageState() {
    Global.audioHandler.playbackState.listen((PlaybackState state) {
      if (state.playing) {
        c.playing.value = true;
        return;
      }

      switch (state.processingState) {
        case AudioProcessingState.idle:
        case AudioProcessingState.loading:
        case AudioProcessingState.buffering:
        case AudioProcessingState.ready:
        case AudioProcessingState.completed:
        case AudioProcessingState.error:
          c.playing.value = false;
          break;
      }
    });

    Global.audioHandler.mediaItem.listen((value) {
      c.title.value = value?.title ?? "歌曲";
      c.artist.value = value?.artist ?? "艺术家";
      c.artUri.value = value?.artUri?.toString() ??
          "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3761843179,3646757056&fm=26&gp=0.jpg";
      c.model.value = Song.fromJson(value?.extras?["model"]);
    });

    Global.audioHandler.positionStream.listen((event) {
      c.position.value = event.inMicroseconds.toDouble();
    });

    Global.audioHandler.durationStream.listen((event) {
      c.duration.value = event?.inMicroseconds.toDouble() ?? 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) => {inited = true});
    return Scaffold(
      body: Navigator(
        initialRoute: '/home',
        onGenerateRoute: (val) {
          late WidgetBuilder builder;

          switch (val.name) {
            case '/about':
              builder = (ctx) => About();
              break;
            case '/settings':
              builder = (ctx) => SettingsView();
              break;
            case '/cloud_music':
              builder = (ctx) => CloudMusicView();
              break;
            case '/download_manager':
              builder = (ctx) => DownloadManagerView();
              break;
            case '/local_music':
              builder = (ctx) => LocalMusicView();
              break;
            case '/song_upload':
              builder = (ctx) => SongUploadView();
              break;
            case '/osl':
              builder = (ctx) => OpenSourceLicensesView();
              break;
            case '/playing_view':
              builder = (ctx) => PlayingView();
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
        width: 65,
        height: 65,
        child: FloatingActionButton(
          child: Obx(() => CircleAvatar(
                radius: 65,
                backgroundImage: NetworkImage(
                  c.artUri.value,
                ),
              )),
          onPressed: () => Get.to(() => PlayingView()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
      bottomNavigationBar: BottomPlayerBarWidget(),
    );
  }
}
