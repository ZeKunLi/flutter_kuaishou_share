import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_kuaishou_share_method_channel.dart';

abstract class FlutterKuaishouSharePlatform extends PlatformInterface {
  /// Constructs a FlutterKuaishouSharePlatform.
  FlutterKuaishouSharePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterKuaishouSharePlatform _instance = MethodChannelFlutterKuaishouShare();

  /// The default instance of [FlutterKuaishouSharePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterKuaishouShare].
  static FlutterKuaishouSharePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterKuaishouSharePlatform] when
  /// they register themselves.
  static set instance(FlutterKuaishouSharePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
