//
//  WeiMiDownTimeView.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/28.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiDownTimeView.h"
#import "WeiMiCountDownItem.h"
#import "UIImage+WeiMiUIImage.h"

@interface WeiMiDownTimeView()

@property (nonatomic, strong) WeiMiCountDownItem *hourView;
@property (nonatomic, strong) WeiMiCountDownItem *minuteView;
@property (nonatomic, strong) WeiMiCountDownItem *secondView;

@property (nonatomic, strong) UILabel *lcolonLB;
@property (nonatomic, strong) UILabel *rcolonLB;

@end
@implementation WeiMiDownTimeView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.hourView];
        [self addSubview:self.minuteView];
        [self addSubview:self.secondView];
        [self addSubview:self.lcolonLB];
        [self addSubview:self.rcolonLB];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setTimeLabel:(NSString *)hour minute:(NSString *)minute second:(NSString *)second
{
    [_hourView setTitleWithCount:hour];
    [_minuteView setTitleWithCount:minute];
    [_secondView setTitleWithCount:second];
}

#pragma mark - Getter
- (UILabel *)lcolonLB
{
    if (!_lcolonLB) {
        _lcolonLB = [[UILabel alloc] init];
        _lcolonLB.font = WeiMiSystemFontWithpx(22);
        _lcolonLB.textAlignment = NSTextAlignmentCenter;
        _lcolonLB.text = @":";
        [_lcolonLB sizeToFit];
    }
    return _lcolonLB;
}

- (UILabel *)rcolonLB
{
    if (!_rcolonLB) {
        _rcolonLB = [[UILabel alloc] init];
        _rcolonLB.font = WeiMiSystemFontWithpx(22);
        _rcolonLB.textAlignment = NSTextAlignmentCenter;
        _rcolonLB.text = @":";
        [_rcolonLB sizeToFit];

    }
    return _rcolonLB;
}

- (WeiMiCountDownItem *)hourView
{
    if (!_hourView) {
        _hourView = [[WeiMiCountDownItem alloc] init];
        _hourView.bgView.image = [UIImage imageWithColor:kBlackColor];
        _hourView.label.textColor = kWhiteColor;
        [_hourView setTitleWithCount:@"00"];
    }
    return _hourView;
}

- (WeiMiCountDownItem *)minuteView
{
    if (!_minuteView) {
        _minuteView = [[WeiMiCountDownItem alloc] init];
        _minuteView.bgView.image = [UIImage imageWithColor:kBlackColor];
        _minuteView.label.textColor = kWhiteColor;
        [_minuteView setTitleWithCount:@"59"];
    }
    return _minuteView;
}

- (WeiMiCountDownItem *)secondView
{
    if (!_secondView) {
        _secondView = [[WeiMiCountDownItem alloc] init];
        _secondView.bgView.image = [UIImage imageWithColor:kBlackColor];
        _secondView.label.textColor = kWhiteColor;
        [_secondView setTitleWithCount:@"00"];
    }
    return _secondView;
}

- (void)updateConstraints
{

    [_hourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_minuteView.mas_left).offset(-10);
        make.bottom.mas_equalTo(_minuteView);
        make.size.mas_equalTo(_minuteView);
        
    }];
    
    [_lcolonLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_hourView);
        make.left.mas_equalTo(_hourView.mas_right);
        make.right.mas_equalTo(_minuteView.mas_left);
    }];
    
    [_minuteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    
    [_rcolonLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_hourView);
        make.left.mas_equalTo(_minuteView.mas_right);
        make.right.mas_equalTo(_secondView.mas_left);
    }];
    
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_minuteView.mas_right).offset(10);
        make.bottom.mas_equalTo(_minuteView);
        make.size.mas_equalTo(_minuteView);
        
    }];
    
    [super updateConstraints];
}

@end
