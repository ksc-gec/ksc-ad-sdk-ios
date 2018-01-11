//
//  KsyunTableViewCell.h
//  KSCAdvertiseDemo
//
//  Created by charvel on 2017/12/28.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KsyunCellType) {
    KsyunCellType_ErrorInfo = 0,
    KsyunCellType_InitializingSDK = 1,
    KsyunCellType_PreloadADs = 2,
    KsyunCellType_PlayAD = 3,
};

@class KsyunTableViewCell;

@protocol KsyunDemoEventProtocol <NSObject>
- (void)sdkInitButtonClicked:(KsyunTableViewCell *)cell;
- (void)preloadAdButtonClicked:(KsyunTableViewCell *)cell;
- (void)playAdButtonClicked:(KsyunTableViewCell *)cell;
@end


@interface KsyunCellModel : NSObject
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *errMsg;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *adSlotId;
@property (nonatomic, assign) BOOL isSuccess;
@property (nonatomic, assign) NSUInteger adType;
@property (nonatomic, assign) KsyunCellType cellType;
@property (nonatomic, assign) CGFloat height;
@end

@interface KsyunTableViewCell : UITableViewCell
@property (nonatomic, strong, readonly) KsyunCellModel *cellModel;
- (void)setDelegate:(id<KsyunDemoEventProtocol>)delegate;
- (void)configModel:(KsyunCellModel *)cellModel;
- (void)setSuccess;

// sdk init
- (void)setAppId:(NSString *)appID;
// detail
- (void)showErrorMessage:(NSString *)errMsg;
@end


