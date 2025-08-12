
import 'package:flutter/services.dart';

import 'flutter_kuaishou_share_platform_interface.dart';

class FlutterKuaishouShare {
  static const MethodChannel _channel = MethodChannel('flutter_kuaishou_share');
  Future<String?> getPlatformVersion() {
    return FlutterKuaishouSharePlatform.instance.getPlatformVersion();
  }

  /// 注册快手 APP
  /// [appId] 你的快手 App ID
  /// [universalLink] 你的 Universal Link（快手开放平台配置）
  static Future<bool> registerApp({
    required String appId,
    required String universalLink,
  }) async {
    final bool success = await _channel.invokeMethod(
      'registerApp',
      {
        'appId': appId,
        'universalLink': universalLink,
      },
    );
    return success;
  }

  /// 分享多媒体到快手
  ///
  /// [coverPath] 封面图片路径
  /// [mediaPaths] 素材路径数组（图片/视频混合）
  /// [feature] 快手分享功能枚举值（例如 KSShareMediaFeature_VideoEdit = 1）
  /// [tags] 可选标签
  /// [miniProgram] 可选关联小程序信息
  static Future<bool> shareMedia({
    required String coverPath,
    required List<String> mediaPaths,
    required int feature,
    List<String>? tags,
    Map<String, String>? miniProgram,
  }) async {
    final result = await _channel.invokeMethod<bool>('shareMedia', {
      'coverPath': coverPath,
      'mediaPaths': mediaPaths,
      'feature': feature,
      'tags': tags ?? [],
      'miniProgram': miniProgram,
    });
    return result ?? false;
  }



}
