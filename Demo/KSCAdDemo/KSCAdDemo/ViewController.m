//
//  ViewController.m
//  KSCAdDemo
//
//  Created by charvel on 2018/1/11.
//  Copyright © 2018年 Ksyun. All rights reserved.
//

#import "ViewController.h"
#import <KsyunADSDK/KsyunAdSDK.h>

@interface ViewController ()<KsyunPreloadADDelegate, KsyunADDelegate, KsyunRewardVideoAdDelegate>
@property(weak, nonatomic) IBOutlet UIButton *enterGameBtn;
@property(weak, nonatomic) IBOutlet UIButton *endGameBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Step 1 : 在使用奖励视频之前进行初始化
    // 设置配置项目
    KsyunAdSDKConfig *config = [KsyunAdSDKConfig sdkConfigWith:YES
                                             adEnvironment:KsyunAdEnvironment_Test
                                 isShowRewardVideoCloseBtn:YES
                                    enableObtainPremission:NO rewardVideoCloseBtnShowTime:10];
    // 初始化 sdk
    [KsyunAdSDK initializeWithAppid:@"xxxx" sdkConfig:config successBlock:^(NSDictionary * _Nullable info) {
        // 初始化完成， info 字典中带有在后台配置的广告位信息
        // 初始化完成后可以考虑进行广告资源预先加载，这是一个可选项
        [KsyunAdSDK preloadAd:self];
        [KsyunAdSDK setRewardVideoDelegate:self];
    } failureBlock:^(KsyunAdErrCode errCode, NSString * _Nullable errMsg) {
        // 初始化失败
    }];
}


- (void)extracted {
    
}

- (IBAction)enterGame:(id)sender
{
    // 用户即将进入游戏场景，提示是否通过观看奖励视频获取额外奖励
    
    // 判断该广告位是否已经有缓存好的资源，已缓存的广告可以直接播放，未缓存的广告需要使用网络在线播放
    __weak typeof(self) weakSelf = self;
    [KsyunAdSDK hasAd:@"xxxx" callback:^(BOOL hasAd, KsyunAdErrCode errCode, NSString * _Nullable errMsg) {
        if (hasAd) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"需要获取额外奖励吗？" message:@"观看视频后可以获得额外的道具，帮助你更容易通关哦" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"获取免费道具" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 展示广告
                [KsyunAdSDK showAdWithAdSlotId:@"xxx" viewController:self adDelegate:self];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"放弃奖励" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf enterGameImmediately];
            }]];
        }
    }];
    [self extracted];
}

- (void)enterGameImmediately
{
    
}

- (IBAction)simulateGameTerminal:(id)sender
{
    
}

#pragma mark - KsyunADDelegate
// 广告展示成功
- (void)onShowSuccess:(NSString *_Nonnull)adSlotId
{
    
}

// 广告展示失败
- (void)onShowFailed:(NSString *_Nonnull)adSlotId errCode:(int)errCode errMsg:(NSString *_Nullable)errMsg
{
    
}

// 广告播放完成
- (void)onADComplete:(NSString *_Nonnull)adSlotId
{
    
}

// 广告点击的回调
- (void)onADClick:(NSString *_Nonnull)adSlotId
{
    
}

// 广告被关闭的回调
- (void)onADClose:(NSString *_Nonnull)adSlotId
{
    
}

#pragma mark - KsyunRewardVideoAdDelegate
/// 奖励视频获得奖励的回调
- (void)onADAwardSuccess:(NSString *_Nonnull)adSlotId
{
    if ([adSlotId isEqualToString:@"xxx"]) {
        // 给用户增加道具奖励，并立刻进入游戏
        [self enterGameImmediately];
    }
}

// 奖励视频获取奖励失败的回调
- (void)onADAwardFailed:(NSString *_Nonnull)adSlotId errCode:(KsyunRewardVideoAdErrCode)errCode errMsg:(NSString *_Nullable)errMsg
{
    if ([adSlotId isEqualToString:@"xxx"]) {
        // 立刻进入游戏, 用户没有奖励
        [self enterGameImmediately];
    }
}

@end
