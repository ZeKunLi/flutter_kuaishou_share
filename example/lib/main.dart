import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_kuaishou_share/flutter_kuaishou_share.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterKuaishouSharePlugin = FlutterKuaishouShare();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _flutterKuaishouSharePlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('Running on: $_platformVersion\n'),
              TextButton(onPressed: () {
                FlutterKuaishouShare.registerApp(appId: "ks670191923743758638", universalLink: "https://app.xiaoxingyun.xin/");
              }, child: Text("初始化SDK")),
              TextButton(onPressed: () async {
                print("object");
                fetchLastAssetId().then((localIdentifier) async {
                  print("hhhhhhhhhh${localIdentifier}");
                  final success = await FlutterKuaishouShare.shareMedia(
                    coverPath: '/path/to/cover.jpg',
                    mediaPaths: [
                      localIdentifier!
                    ],
                    feature: 1, // KSShareMediaFeature_VideoEdit
                    tags: ['旅行', '风景'],
                    miniProgram: {
                      'title': '我的小程序',
                      'appId': 'wx1234567890',
                      'path': '/pages/home',
                    },
                  );
                  print('快手分享结果: $success');
                });

              }, child: Text("分享"))
            ],
          ),
        ),
      ),
    );
  }

  static Future<String?> fetchLastAssetId() async {

    // // 请求相册权限
    final PermissionState ps = await PhotoManager.requestPermissionExtend();

    if (!ps.isAuth) {
      print('用户未授权访问相册');
      return null;
    }

    // 获取相册列表（最新的排在前面）
    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.common, // 图片 + 视频
      onlyAll: true,            // 只获取 "所有资源" 相册
    );

    if (albums.isEmpty) {
      return null;
    }

    // 获取最新一个资源（按时间倒序）
    List<AssetEntity> assets = await albums.first.getAssetListPaged(
      page: 0,
      size: 1, // 只取 1 个
    );

    if (assets.isEmpty) {
      return null;
    }

    // iOS 下 asset.id 就是 PHAsset.localIdentifier
    return assets.first.id;
  }
}
