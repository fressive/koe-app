import 'package:flutter/material.dart';
import 'package:koe/common/api.dart';

import 'package:koe/common/global.dart';
import 'package:get/get.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  _input(BuildContext context, config) {
    var text = config.value;

    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text("输入"),
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(28.0),
                    child: TextField(
                        maxLines: 1,
                        controller: TextEditingController(text: config.value),
                        decoration: InputDecoration(
                          hintText: config.key,
                          labelText: config.key,
                        ),
                        onChanged: (c) => {text = c}),
                  ),
                  Row(
                    children: [
                      SimpleDialogOption(
                          child: Text("返回"),
                          onPressed: () => {Navigator.pop(context)}),
                      SimpleDialogOption(
                          child: Text("确认"),
                          onPressed: () => {
                                setState(() {
                                  config.value = text;
                                  Navigator.pop(context);
                                })
                              }),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ],
              )
            ],
          );
        }).then((value) => null);
  }

  _checkConn(BuildContext context) async {
    var text = "";
    try {
      await Api.getBackendVersion();

      text = "测试成功";
    } catch (e) {
      text = e.toString();
    }

    Get.rawSnackbar(
        title: "结果", message: text, snackPosition: SnackPosition.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("设置"),
              bottom: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                labelPadding: EdgeInsets.all(12),
                tabs: [Text('程序设置'), Text('服务器设置')],
              ),
            ),
            body: Builder(
              builder: (context) => TabBarView(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '这里是关于 Koe APP 的一些本地设置，如服务器地址、代理、保存路径等，不会影响到后端设置。',
                                style: Theme.of(context).textTheme.caption),
                          ),
                          Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text("登录和网络",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: InkWell(
                                      onTap: () {
                                        _input(context, AppConfig.serverUrl);
                                      },
                                      child: Row(
                                        children: [
                                          Text("登录凭据",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2)
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      )),
                                ),
                                InkWell(
                                    onTap: () {
                                      _input(context, AppConfig.serverUrl);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Row(
                                        children: [
                                          Text("服务器地址",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2),
                                          Text(
                                              AppConfig.serverUrl.value
                                                  .toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption)
                                        ],
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Text("代理",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Text("无",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    await _checkConn(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Row(
                                      children: [
                                        Text("测试连接",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        Text("点击测试",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption)
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 0, left: 15),
                                  child: Row(
                                    children: [
                                      Text("使用移动网络播放",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Switch(value: false, onChanged: (d) => {})
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4, left: 15),
                                  child: Row(
                                    children: [
                                      Text("使用移动网络下载",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Switch(value: false, onChanged: (d) => {})
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Card(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("播放和下载",
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("播放音质",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text("高（320kbps)",
                                        style:
                                            Theme.of(context).textTheme.caption)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("下载音质",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text("无损",
                                        style:
                                            Theme.of(context).textTheme.caption)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("设置下载/缓存目录",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text("内部存储",
                                        style:
                                            Theme.of(context).textTheme.caption)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("缓存设置",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4, left: 15),
                                child: Row(
                                  children: [
                                    Text("与其它应用同时播放",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Switch(value: false, onChanged: (d) => {})
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                          Card(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("外观",
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("程序主题",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("状态栏主题",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text(
                                      "默认",
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                          Card(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("其它",
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Text("关于 Koe",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/about'),
                              ),
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Text("开放源代码许可",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                onTap: () =>
                                    Navigator.pushNamed(context, '/osl'),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                '这里是 Koe 后端服务器的一些设置，所有的改动将会同步到云端。\n需要在程序设置中设置登录凭据与服务器地址后修改。',
                                style: Theme.of(context).textTheme.caption),
                          ),
                          Card(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text("数据存储",
                                      style:
                                          Theme.of(context).textTheme.caption),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Text("数据保存地址",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Text("/mnt/onedrive/koe",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Text("代理",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Text("无",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Row(
                                    children: [
                                      Text("测试连接",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Text("点击测试",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption)
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 0, left: 15),
                                  child: Row(
                                    children: [
                                      Text("使用移动网络播放",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Switch(value: false, onChanged: (d) => {})
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 4, left: 15),
                                  child: Row(
                                    children: [
                                      Text("使用移动网络下载",
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2),
                                      Switch(value: false, onChanged: (d) => {})
                                    ],
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                  ),
                                )
                              ],
                              crossAxisAlignment: CrossAxisAlignment.start,
                            ),
                          ),
                          Card(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("音频",
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("保存压缩后的音频文件",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text("高（320kbps)",
                                        style:
                                            Theme.of(context).textTheme.caption)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("下载音质",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text("无损",
                                        style:
                                            Theme.of(context).textTheme.caption)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("设置下载/缓存目录",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text("内部存储",
                                        style:
                                            Theme.of(context).textTheme.caption)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("缓存设置",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 4, left: 15),
                                child: Row(
                                  children: [
                                    Text("与其它应用同时播放",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Switch(value: false, onChanged: (d) => {})
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                          Card(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("外观",
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("程序主题",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("状态栏主题",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2),
                                    Text(
                                      "默认",
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    )
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                          Card(
                              child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text("其它",
                                    style: Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("帮助",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  children: [
                                    Text("重置所有服务器设置",
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2)
                                  ],
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                ),
                              ),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          )),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
