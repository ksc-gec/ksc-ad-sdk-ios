//
//  KsyunAdSDK.h
//  KsyunAdSDK
//
//  Created by wanzhaoyang on 2017/12/14.
//  Copyright © 2017年 ksyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KsyunAdEnvironment) {
    // 线上生产环境
    KsyunAdEnvironment_Release  = 0,
    // 开发环境
    KsyunAdEnvironment_Develop  = 1,
};

typedef NS_ENUM(NSUInteger, KsyunAdInitStatus) {
    // 未初始化
    KsyunAdInitStatus_NOT_INIT      = 0,
    // 初始化过程中
    KsyunAdInitStatus_INITIALIZING  = 1,
    // 初始化完成
    KsyunAdInitStatus_INITIALIZED   = 2,
    // 初始化失败
    KsyunAdInitStatus_INIT_FAILED   = 3,
};

typedef NS_ENUM(NSUInteger, KsyunAdErrCode) {
    // 初始化参数错误
    KsyunAdErrCode_INIT_PARAM_INVALID           = 1000,
    // 初始化插件加载失败
    KsyunAdErrCode_INIT_PLUGIN_LOAD_FAILURE     = 1001,
    // SDK未初始化
    KsyunAdErrCode_SDK_NOT_INITIALIZED          = 1002,
    // SDK内部请求失败
    KsyunAdErrCode_INSIDE_REQUEST_ERROR         = 1003,
    // SDK不支持的广告位
    KsyunAdErrCode_NOT_SUPPORT_AD_SLOT          = 1004,
    // SDK没有获取到任何广告位信息
    KsyunAdErrCode_NO_AD_SLOT                   = 1005,
    // 该广告位没有对应的广告
    KsyunAdErrCode_NO_AD_INFO_IN_THIS_SLOT      = 1006,
    // 代理对象未找到
    KsyunAdErrCode_DELEGATE_NOT_FOUND           = 1007,
    // SDK服务端系统繁忙
    KsyunAdErrCode_SERVER_BUSY                  = 1008,
    // AppId无效
    KsyunAdErrCode_APPID_INVALID                = 1009,
    // 广告位Id无效
    KsyunAdErrCode_APP_SLOT_ID_INVALID          = 1010,
    // 当前AppId没有任何广告位
    KsyunAdErrCode_APPID_NO_ADSLOT              = 1011,
    // 展示广告的Controller不可用
    KsyunAdErrCode_SHOW_AD_CONTROLLER_INVALID   = 1012,
    // SDK重复初始化
    KsyunAdErrCode_SDK_ALREADY_INIT             = 1013,
    // SDK服务端内部错误
    KsyunAdErrCode_SERVER_INTERNAL_ERROR        = 1100,
    // 服务端系统错误
    KsyunAdErrCode_SERVER_ERR_SYSTEM            = 1200,
    // 未知错误
    KsyunAdErrCode_UNKNOWN                      = 2000,
};

typedef NS_ENUM(NSUInteger, KsyunRewardVideoAdErrCode) {
    // 提前退出
    KsyunRewardVideoAdErrCode_FORCE_CLOSE       = 10000,
    // 播放器初始化失败
    KsyunRewardVideoAdErrCode_PLAYER_FAILED     = 10001,
};

@protocol KsyunPreloadADDelegate <NSObject>
@optional

// 广告信息加载成功
- (void)onAdInfoSuccess;

// 广告信息加载失败
- (void)onAdInfoFailed:(NSArray<NSString *> *_Nullable)adSlotIds errCode:(NSInteger)errCode errMsg:(NSString *_Nullable)errMsg;

// 广告预加载成功
- (void)onAdLoaded:(NSString *_Nonnull)adSlotId;

@end

@protocol KsyunADDelegate <NSObject>
@optional

// 广告展示成功
- (void)onShowSuccess:(NSString *_Nonnull)adSlotId;

// 广告展示失败
- (void)onShowFailed:(NSString *_Nonnull)adSlotId errCode:(int)errCode errMsg:(NSString *_Nullable)errMsg;

// 广告播放完成
- (void)onADComplete:(NSString *_Nonnull)adSlotId;

// 广告点击的回调
- (void)onADClick:(NSString *_Nonnull)adSlotId;

// 广告被关闭的回调
- (void)onADClose:(NSString *_Nonnull)adSlotId;

@end

@protocol KsyunRewardVideoAdDelegate <NSObject>
@optional

// 奖励视频获得奖励的回调
- (void)onADAwardSuccess:(NSString *_Nonnull)adSlotId;

// 奖励视频获取奖励失败的回调
- (void)onADAwardFailed:(NSString *_Nonnull)adSlotId errCode:(KsyunRewardVideoAdErrCode)errCode errMsg:(NSString *_Nullable)errMsg;

@end

@interface KsyunAdSDKConfig : NSObject

// 当前SDK运行环境
@property(nonatomic, assign, readonly) KsyunAdEnvironment adEnvironment;

// 是否在调试模式，debugMode能够查看更多log日志，关闭此模式可以过滤控制台的日志信息
@property(nonatomic, assign, readonly) BOOL isDebugMode;

// 播放奖励视频是否展示关闭按钮
@property(nonatomic, assign, readonly) BOOL isShowRewardVideoCloseBtn;

// 播放奖励视频从第几秒开始展示关闭按钮
@property(nonatomic, assign, readonly) NSUInteger rewardVideoCloseBtnShowTime;

// 是否允许SDK主动获取权限，网络、定位、多媒体
@property(nonatomic, assign, readonly) BOOL enableObtainPremission;

+ (KsyunAdSDKConfig *_Nonnull)sdkConfigWithDebugMode:(BOOL)isDebugMode
                                       adEnvironment:(KsyunAdEnvironment)environment
                           isShowRewardVideoCloseBtn:(BOOL)isShowRewardVideoCloseBtn
                              enableObtainPremission:(BOOL)enableObtainPremission
                         rewardVideoCloseBtnShowTime:(NSUInteger)showTime;

@end

@interface KsyunAdSDK : NSObject

+ (KsyunAdSDK * _Nonnull)sharedInstance;

// 初始化方法
+ (void)initializeWithAppid:(NSString * _Nonnull)appid
                  sdkConfig:(KsyunAdSDKConfig *_Nullable)sdkConfig
               successBlock:(void(^_Nonnull)(NSDictionary * _Nullable info))successBlock
               failureBlock:(void(^_Nonnull)(KsyunAdErrCode errCode, NSString * _Nullable errMsg))failureBlock;

// SDK配置项
+ (KsyunAdSDKConfig * _Nullable)sdkConfig;

// SDK初始化状态
+ (KsyunAdInitStatus)sdkInitStatus;

// 获取SDK版本号
+ (NSString * _Nonnull)version;

// 获取当前运行环境
+ (BOOL)isDebugMode;

// 预加载
+ (void)preloadAd:(id<KsyunPreloadADDelegate> _Nullable)delegate;

// 预加载单个广告位
+ (void)preloadAd:(NSString * _Nonnull)adSlotId delegate:(id<KsyunPreloadADDelegate> _Nullable)delegate;

// 判断当前广告位是否有广告
+ (BOOL)hasAd:(NSString * _Nonnull)adSlotId;

// 判断当前广告位是否有加载完资源的广告
+ (BOOL)hasLocalAd:(NSString * _Nonnull)adSlotId;

// 展示广告
+ (void)showAdWithAdSlotId:(NSString * _Nonnull)adSlotId
            viewController:(UIViewController * _Nonnull)viewController
                adDelegate:(id<KsyunADDelegate> _Nullable)adDelegate;

// 设置奖励视频回调，单独提供，方便调用方统一处理
+ (void)setRewardVideoDelegate:(id<KsyunRewardVideoAdDelegate> _Nullable)delegate;

// 移除SDK的监听
+ (void)removeListeners;

// 清理缓存
+ (void)clearCache;

@end
