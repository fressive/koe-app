import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'local_music.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    Key key,
  });

  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主页"),
        actions: [IconButton(icon: Icon(Icons.search))],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Koe',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text(''),
            ),
            ListTile(
              leading: Icon(Icons.upload_file),
              title: Text('上传'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('设置'),
              onTap: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Container(
              child: Container(
                height: 140,
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                      childAspectRatio: 0.007.sw),
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        clipBehavior: Clip.antiAlias,
                        child: FlatButton(
                            child: Row(
                              children: [
                                Icon(Icons.music_note_outlined),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Text(
                                    "本地音乐",
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, '/local_music');
                            })),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      clipBehavior: Clip.antiAlias,
                      child: FlatButton(
                          child: Row(
                            children: [
                              Icon(Icons.cloud_outlined),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "云端音乐",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/cloud_music');
                          }),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      clipBehavior: Clip.antiAlias,
                      child: FlatButton(
                          child: Row(
                            children: [
                              Icon(Icons.download_outlined),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "下载管理",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/local_music');
                          }),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      clipBehavior: Clip.antiAlias,
                      child: FlatButton(
                          child: Row(
                            children: [
                              Icon(Icons.featured_play_list_outlined),
                              Padding(
                                padding: const EdgeInsets.only(left: 16.0),
                                child: Text(
                                  "最近播放",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              )
                            ],
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LocalMusicView()));
                          }),
                    )
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(children: [
                  Row(children: [
                    IconButton(icon: Icon(Icons.expand_more)),
                    Text("创建的歌单", style: Theme.of(context).textTheme.subtitle1),
                    Text("  (1)", style: Theme.of(context).textTheme.caption)
                  ])
                ])),
          ),
        ]),
      ),
    );
  }
}
