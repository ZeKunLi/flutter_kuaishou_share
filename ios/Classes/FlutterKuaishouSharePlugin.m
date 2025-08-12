//
//  FlutterKuaishouSharePlugin .m
//  Pods
//
//  Created by 李泽昆 on 2025/8/10.
//


#import "FlutterKuaishouSharePlugin.h"
#import <KwaiSDK/KSApi.h>
#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
//#import <KwaiSDK/KSShareMessageRequest.h>
//#import <KwaiSDK/KSShareWebPageObject.h>
@implementation FlutterKuaishouSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_kuaishou_share"
            binaryMessenger:[registrar messenger]];
  FlutterKuaishouSharePlugin* instance = [[FlutterKuaishouSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"registerApp" isEqualToString:call.method]) {
    NSString *appId = call.arguments[@"appId"];
    NSString *universalLink = call.arguments[@"universalLink"];
              
    // 向快手注册 App
    BOOL success = [KSApi registerApp:appId universalLink:universalLink delegate:self];
              
              result(@(success)); // 返回给 Flutter true/false
  } else if ([@"shareMedia" isEqualToString:call.method]) {
      NSDictionary *args = call.arguments;
              [self shareMediaWithArgs:args completion:^(BOOL success) {
                  result(@(success));
              }];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

// 多媒体分享实现
- (void)shareMediaWithArgs:(NSDictionary *)args completion:(void (^)(BOOL success))completion {

    NSArray *mediaPaths = args[@"mediaPaths"];
    KSShareMediaObject *mediaItem = [[KSShareMediaObject alloc] init];
    //建议为NO, 即执行兜底逻辑，无相关发布权限时进入预裁剪页
    mediaItem.disableFallback = NO;
    mediaItem.extraEntity = nil;
    mediaItem.tags = @[];

    NSMutableArray<KSShareMediaAsset *> *shareItems = [NSMutableArray arrayWithCapacity:mediaPaths.count];
    for (NSString* asset in mediaPaths) {

        [shareItems addObject:[KSShareMediaAsset assetForPhotoLibrary:asset isImage:YES]];
    }

    mediaItem.multipartAssets = shareItems;
    mediaItem.associateType = KSMediaAssociateNone;
    KSShareMediaRequest *request = [[KSShareMediaRequest alloc] init];
    request.applicationList = @[@(KSApiApplication_Kwai), @(KSApiApplication_KwaiLite)];
    request.mediaFeature = KSShareMediaFeature_PictureEdit;
    request.mediaObject = mediaItem;
    __weak __typeof(self) ws = self;
    [KSApi sendRequest:request completion:^(BOOL success) {
        
        __strong __typeof(ws) ss = ws;
//        [ss logFormat:@"%s success: %@", __func__, success ? @"YES" : @"NO"];
        completion ? completion(success) : nil;
    }];
    
}
@end
