//
//  KsyunDemoViewController.m
//  KSCAdvertiseDemo
//
//  Created by charvel on 2017/12/26.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KsyunDemoViewController.h"
#import "KsyunTableViewCell.h"
#import "KsyunSenceViewController.h"
#import <KsyunAdSDK/KsyunAdSDK.h>


//#define adslotid    @"k4lkcwyv"


@interface KsyunDemoViewController ()<UITableViewDelegate, UITableViewDataSource, KsyunDemoEventProtocol, KsyunADDelegate, KsyunPreloadADDelegate, KsyunRewardVideoAdDelegate>
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *ads;
@end


@implementation KsyunDemoViewController

- (void)appendModel:(KsyunCellModel *)model
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        KsyunCellModel *errModel = nil;
        for(KsyunCellModel *mode in self.ads) {
            if (mode.cellType == KsyunCellType_ErrorInfo) {
                errModel = mode;
            }
        }
        // only one error display at the end of cells
        NSMutableArray *ads = [self.ads mutableCopy];
        if (errModel) {
            [ads removeObject:errModel];
        }
        [ads addObject:model];
        self.ads = [ads copy];
        [self.tableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KsyunCellModel *model = [KsyunCellModel.alloc init];
    model.appId = [self.class getPreferenceAppid];
    model.cellType = KsyunCellType_InitializingSDK;
    
    self.ads = @[model];
    
    //
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds) - 80, 60.f)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Baskerville-Bold" size:22];
    label.textColor = [UIColor colorWithRed:30/255.f green:30/255.f blue:30/255.f alpha:1.f];
    label.text = @"KSYUN AD DEMO";
    self.navigationItem.titleView = label;

    
    // Step 1: 初始化 SDK
    [self setupDemoTableView];
    
}

- (void)setupDemoTableView {
    [self.tableView registerClass:KsyunTableViewCell.class forCellReuseIdentifier:NSStringFromClass(KsyunTableViewCell.class)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//Interface的方向是否会跟随设备方向自动旋转，如果返回NO,后两个方法不会再调用
- (BOOL)shouldAutorotate {
    return YES;
}
//返回直接支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
//返回最优先显示的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma TableView
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    KsyunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(KsyunTableViewCell.class) forIndexPath:indexPath];
    KsyunCellModel *model = self.ads[indexPath.row];
    [cell configModel:model];
    [cell setDelegate:self];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ads.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KsyunCellModel *model = self.ads[indexPath.row];
    return model.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}


#pragma mark - KsyunDemoEventProtocol
- (void)sdkInitButtonClicked:(KsyunTableViewCell *)cell
{
    
    __weak typeof(self) weakSelf = self;
    
    // Step 1: 初始化 SDK
    KsyunAdSDKConfig *config = [self.class getPreferenceConfig];
    
    NSString *appId = cell.cellModel.appId;
    
    [KsyunAdSDK initializeWithAppid:appId sdkConfig:config successBlock:^(NSDictionary * _Nullable info) {
        // 预加载
        KsyunCellModel *model = [KsyunCellModel.alloc init];
        model.appId = appId;
        model.cellType = KsyunCellType_PreloadADs;
        [weakSelf appendModel:model];
        NSArray *adSlots = info[@"adSlots"];
        for (NSDictionary *dict in adSlots) {
            // 广告位
            KsyunCellModel *model = [KsyunCellModel.alloc init];
//            NSString *status = dict[@"adslot_status"];
            NSString *type = dict[@"adslot_type"];
            NSString *slotId = dict[@"adslot_id"];
            model.adType = [type integerValue];
            model.adSlotId = slotId;
            model.cellType = KsyunCellType_PlayAD;
            [self appendModel:model];
        }
        [cell setSuccess];
    } failureBlock:^(KsyunAdErrCode errCode, NSString * _Nullable errMsg) {
        KsyunCellModel *model = [KsyunCellModel.alloc init];
        model.appId = appId;
        model.errMsg = [NSString stringWithFormat:@"Error Occurd : %@ [%@]", @(errCode), errMsg];
        model.cellType = KsyunCellType_ErrorInfo;
        [weakSelf appendModel:model];
    }];
}

- (void)preloadAdButtonClicked:(KsyunTableViewCell *)cell
{
    // Step 2: 初始化成功后预加载广告
    [KsyunAdSDK preloadAd:self];
}
- (void)playAdButtonClicked:(KsyunTableViewCell *)cell
{
    // Step 3: 使用完成加载的广告 id 进行广告展示
    [KsyunAdSDK setRewardVideoDelegate:self];

    // push new view controller
    KsyunSenceViewController *sence = [[KsyunSenceViewController alloc] init];
    sence.slotId = cell.cellModel.adSlotId;
    [self.navigationController pushViewController:sence animated:YES];

}

#pragma mark - KsyunPreload
// 广告信息加载成功
- (void)onAdInfoSuccess
{
    KsyunTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if (cell.cellModel && cell.cellModel.cellType == KsyunCellType_PreloadADs) {
        [cell setSuccess];
    }
}

// 广告信息加载失败
- (void)onAdInfoFailed:(NSArray<NSString *> *_Nullable)adSlotIds errCode:(NSInteger)errCode errMsg:(NSString *_Nullable)errMsg
{
    KsyunCellModel *model = [KsyunCellModel.alloc init];
    model.errMsg = [NSString stringWithFormat:@"Error Occurd : %@ [%@]", @(errCode), errMsg];
    model.appId = @"";
    model.cellType = KsyunCellType_ErrorInfo;
    [self appendModel:model];
}

// 广告预加载成功
- (void)onAdLoaded:(NSString *_Nonnull)adSlotId
{
    for (NSUInteger idx = 0; idx < self.ads.count; ++idx) {
        KsyunCellModel *model = self.ads[idx];
        if (model.cellType == KsyunCellType_PlayAD
            && [model.adSlotId isEqualToString:adSlotId]) {
            model.isSuccess = YES;
        }
    }
    [self.tableView reloadData];
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
- (void)onADClose:(NSString *_Nonnull)adSlotId{
    
}

// 奖励视频获得奖励的回调
- (void)onADAwardSuccess:(NSString *_Nonnull)adSlotId
{
    
}

// 奖励视频获取奖励失败的回调
- (void)onADAwardFailed:(NSString *)adSlotId errCode:(KsyunRewardVideoAdErrCode)errCode errMsg:(NSString *)errMsg
{
    
}

#pragma
+ (NSString *)getPreferenceAppid
{
    NSString *appID = [[NSUserDefaults standardUserDefaults] objectForKey:@"appID"];
    if (!appID) {
        appID = @"d86d3e47";
    }
    return appID;
}
+ (KsyunAdSDKConfig *)getPreferenceConfig
{
    // environment
    KsyunAdEnvironment envir = [self getPreferEnvironment];
    
    // debug mode
    BOOL debugMode = YES;
    NSNumber *res = [[NSUserDefaults standardUserDefaults] objectForKey:@"debugMode"];
    if (res) {
        debugMode = res.boolValue;
    }
    
    // seekSec
    NSInteger seekSec = 5;
    res = [[NSUserDefaults standardUserDefaults] objectForKey:@"seekSec"];
    if (res) {
        seekSec = res.integerValue;
    }
    
    // showCloseBtn
    BOOL showCloseBtn = YES;
    res = [[NSUserDefaults standardUserDefaults] objectForKey:@"showCloseBtn"];
    if (res) {
        showCloseBtn = res.boolValue;
    }
    
    // premissionStatus
    BOOL premissionStatus = YES;
    res = [[NSUserDefaults standardUserDefaults] objectForKey:@"premissionStatus"];
    if (res) {
        premissionStatus = res.boolValue;
    }

    
    // Step 1: 初始化 SDK
    KsyunAdSDKConfig *config = [KsyunAdSDKConfig sdkConfigWith:debugMode
                                                 adEnvironment:envir
                                     isShowRewardVideoCloseBtn:showCloseBtn
                                        enableObtainPremission:premissionStatus
                                   rewardVideoCloseBtnShowTime:seekSec];

    return config;

}
+ (KsyunAdEnvironment)getPreferEnvironment
{
    NSInteger env = [[NSUserDefaults standardUserDefaults] integerForKey:@"getPreferEnvironment"];
    
    if (env == 1) {
        return KsyunAdEnvironment_Test;
    } else if (env == 2) {
        return KsyunAdEnvironment_Production;
    }
    // default
    return KsyunAdEnvironment_Develop;
}

#pragma mark - Orientation
- (void)orientationChanged:(NSNotification *)notification{
    [self.tableView reloadData];
}


@end

