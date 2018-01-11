//
//  KsyunTableViewCell.m
//  KSCAdvertiseDemo
//
//  Created by charvel on 2017/12/28.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KsyunTableViewCell.h"

@interface KsyunTableViewCell()
{
    UIColor *_hignLightColor;
    UIColor *_normalColor;
}
@property (nonatomic, strong, readwrite) KsyunCellModel *cellModel;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UIButton *loadBtn;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *initialBtn;
@property (nonatomic, weak) id<KsyunDemoEventProtocol> eventDelegate;
@end
@implementation KsyunTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _hignLightColor = [UIColor colorWithRed:41/255.0f green:176/255.0f blue:123/255.0f alpha:1];
        _normalColor = [UIColor colorWithRed:159/255.0 green:198/255.0 blue:225/255.0 alpha:1];
        [self commonUI];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    if (!_backView) {
        
    }
}

#pragma mark - Interface
- (void)setAppId:(NSString *)appID
{
    if (appID.length == 0) {
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.titleLabel.text = [NSString stringWithFormat:@"App ID : %@", appID];
    });

}

- (void)showErrorMessage:(NSString *)errMsg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (errMsg.length == 0) {
            self.detailLabel.text = @"";
        } else {
            self.detailLabel.text = errMsg;
        }
    });
}

- (void)setDelegate:(id<KsyunDemoEventProtocol>)delegate
{
    if (_eventDelegate != delegate) {
        _eventDelegate = delegate;
    }
}
- (void)configModel:(KsyunCellModel *)cellModel
{
    _cellModel = cellModel;
    
    CGRect rect = self.frame;
    rect.size.height = cellModel.height;
    self.frame = rect;
    
    CGRect contentRect = self.contentView.bounds;
    // back view
    self.backView.frame = CGRectInset(contentRect, 10, 10);
    self.titleLabel.frame = CGRectMake(10, 10, CGRectGetWidth(contentRect) - 30, 30);
    self.detailLabel.frame = CGRectMake(10, 45, CGRectGetWidth(contentRect) - 30, 60);
    self.stepLabel.frame = CGRectMake(8, 5, 100, 30);
    
    CGRect backRect = self.backView.bounds;
    CGFloat centerY = CGRectGetHeight(backRect) - 30;
    CGFloat centerX = CGRectGetMidX(backRect);
    
//    CGPoint leftCenter  = CGPointMake(centerX - 60, centerY);
//    CGPoint rightCenter = CGPointMake(centerX + 60, centerY);
    CGPoint centerPoint = CGPointMake(centerX, centerY);
    
    
    // reset
    self.loadBtn.hidden = YES;
    self.playBtn.hidden = YES;
    self.initialBtn.hidden = YES;
    self.detailLabel.hidden = YES;
    self.stepLabel.textColor = [UIColor colorWithRed:72/255.f green:209/255.f blue:204/255.f alpha:1.f];//72,209,204
    
    if (cellModel.cellType == KsyunCellType_ErrorInfo) {
        self.detailLabel.text = cellModel.errMsg;
        self.detailLabel.hidden = NO;
        self.stepLabel.textColor = [UIColor colorWithRed:220/255.f green:20/255.f blue:60/255.f alpha:1.f];//72,209,204
        self.stepLabel.text = @"Error";
        self.titleLabel.text = @"";
    } else if (cellModel.cellType == KsyunCellType_InitializingSDK) {
        // sdk init
        self.initialBtn.hidden = NO;
        self.initialBtn.center = centerPoint;
        self.titleLabel.text = [NSString stringWithFormat:@"AppID: %@", cellModel.appId];
        self.stepLabel.text = @"Step 1";
    } else if (cellModel.cellType == KsyunCellType_PreloadADs) {
        // preload
        self.loadBtn.hidden = NO;
        self.loadBtn.center = centerPoint;
        self.stepLabel.text = @"Step 2";
        self.titleLabel.text = @"Preload ads";
    } else if (cellModel.cellType == KsyunCellType_PlayAD) {
        // play
        self.playBtn.hidden = NO;
        self.playBtn.center = centerPoint;
        self.titleLabel.text = [NSString stringWithFormat:@"AdSlot: %@", cellModel.adSlotId];
        self.stepLabel.text = [NSString stringWithFormat:@"type %@",[@(cellModel.adType) stringValue]];
    }
    
    if (cellModel.isSuccess) {
        [self setSuccess];
    } else {
        [self setDefault];
    }
}
- (void)setSuccess
{
    KsyunCellModel *cellModel = _cellModel;
    if (cellModel.cellType == KsyunCellType_InitializingSDK) {
        // sdk init
        [self.initialBtn setTitle:@"Init Success" forState:UIControlStateNormal];
        self.initialBtn.backgroundColor = _normalColor;
    } else if (cellModel.cellType == KsyunCellType_PreloadADs) {
        // preload
        [self.loadBtn setTitle:@"Load Succ" forState:UIControlStateNormal];
        self.loadBtn.backgroundColor = _normalColor;
    } else if (cellModel.cellType == KsyunCellType_PlayAD) {
        // play
        [self.playBtn setTitle:@"PlayAD Cached" forState:UIControlStateNormal];
        self.playBtn.backgroundColor = _hignLightColor;
    }
}

- (void)setDefault
{
    KsyunCellModel *cellModel = _cellModel;
    if (cellModel.cellType == KsyunCellType_PlayAD) {
        // play
        [self.playBtn setTitle:@"Play AD" forState:UIControlStateNormal];
        self.playBtn.backgroundColor = _normalColor;
    }
}

#pragma Init
- (void)commonUI
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    [self makeContentBackView];
    [self makeTitleLabel];
    [self makeButtons];
}

- (void)makeContentBackView
{
    self.backView = [[UIView alloc] init];
    self.backView.layer.cornerRadius = 6;
    self.backView.layer.masksToBounds = YES;
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.backView];
}

- (void)makeTitleLabel
{
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont fontWithName:@"Menlo-Bold" size:16];
    self.titleLabel.text = @"Placement ID";
    self.titleLabel.textColor = [UIColor colorWithRed:130/255.f green:130/255.f blue:130/255.f alpha:1.f];
    [self.backView addSubview:self.titleLabel];
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.textColor = [UIColor lightGrayColor];
    self.detailLabel.font = [UIFont systemFontOfSize:12.f];
    self.detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.detailLabel.numberOfLines = 0;
    [self.backView addSubview:self.detailLabel];
    
    self.stepLabel = [[UILabel alloc] init];
    self.stepLabel.textAlignment = NSTextAlignmentLeft;
    UIFont *font = [UIFont fontWithName:@"Copperplate-Bold" size:16];
    self.stepLabel.font = font;
    [self.backView addSubview:self.stepLabel];
}

- (void)makeButtons
{
    self.loadBtn = [self createBtnWithTitle:@"PRELOAD"];
    [self.backView addSubview:self.loadBtn];
    
    self.playBtn = [self createBtnWithTitle:@"PLAY AD"];
    self.playBtn.backgroundColor = _normalColor;
    [self.backView addSubview:self.playBtn];
    
    self.initialBtn = [self createBtnWithTitle:@"INITIAL SDK"];
    self.initialBtn.backgroundColor = _hignLightColor;
    [self.backView addSubview:self.initialBtn];
}


- (UIButton *)createBtnWithTitle:(NSString *)title
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 120, 30);
    btn.layer.cornerRadius = 4.f;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = _hignLightColor;
    btn.titleLabel.font = [UIFont fontWithName:@"Menlo-Regular" size:14];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)buttonEvent:(UIButton *)sender
{
    //
    id<KsyunDemoEventProtocol> delegate = _eventDelegate;
    if (delegate == nil) {
        return;
    }
    if (sender == _initialBtn) {
        if ([delegate respondsToSelector:@selector(sdkInitButtonClicked:)]) {
            [delegate sdkInitButtonClicked:self];
        }
    } else if (sender == _loadBtn) {
        if ([delegate respondsToSelector:@selector(preloadAdButtonClicked:)]) {
            [delegate preloadAdButtonClicked:self];
        }
    } else if (sender == _playBtn) {
        if ([delegate respondsToSelector:@selector(playAdButtonClicked:)]) {
            [delegate playAdButtonClicked:self];
        }
    }
}

@end


@implementation KsyunCellModel
- (CGFloat)height {
    if (self.cellType == KsyunCellType_ErrorInfo) {
        return 180;
    } else {
        return 120;
    }
    
}
@end

