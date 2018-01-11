//
//  KsyunDemoViewController.h
//  KSCAdvertiseDemo
//
//  Created by charvel on 2017/12/26.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KsyunAdSDKConfig;

@interface KsyunDemoViewController : UITableViewController
+ (NSString *)getPreferenceAppid;
+ (KsyunAdSDKConfig *)getPreferenceConfig;
@end

