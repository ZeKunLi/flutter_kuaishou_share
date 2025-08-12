import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_kuaishou_share/flutter_kuaishou_share.dart';
import 'package:flutter_kuaishou_share/flutter_kuaishou_share_platform_interface.dart';
import 'package:flutter_kuaishou_share/flutter_kuaishou_share_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterKuaishouSharePlatform
    with MockPlatformInterfaceMixin
    implements FlutterKuaishouSharePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterKuaishouSharePlatform initialPlatform = FlutterKuaishouSharePlatform.instance;

  test('$MethodChannelFlutterKuaishouShare is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterKuaishouShare>());
  });

  test('getPlatformVersion', () async {
    FlutterKuaishouShare flutterKuaishouSharePlugin = FlutterKuaishouShare();
    MockFlutterKuaishouSharePlatform fakePlatform = MockFlutterKuaishouSharePlatform();
    FlutterKuaishouSharePlatform.instance = fakePlatform;

    expect(await flutterKuaishouSharePlugin.getPlatformVersion(), '42');
  });
}
