import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_kuaishou_share_platform_interface.dart';

/// An implementation of [FlutterKuaishouSharePlatform] that uses method channels.
class MethodChannelFlutterKuaishouShare extends FlutterKuaishouSharePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_kuaishou_share');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
