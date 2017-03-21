//
//  WeiMiCountDownView.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCountDownView.h"
#import "WeiMiCountDownItem.h"

@interface WeiMiCountDownView()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) WeiMiCountDownItem *hourView;
@property (nonatomic, strong) WeiMiCountDownItem *minuteView;
@property (nonatomic, strong) WeiMiCountDownItem *secondView;

@end

@implementation WeiMiCountDownView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];

        [self addSubview:self.hourView];
        [self addSubview:self.minuteView];
        [self addSubview:self.secondView];
        
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
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Arial-Bold" size:kFontSizeWithpx(20)];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"限时抢购";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(16)];
        _subTitleLabel.textColor = HEX_RGB(0xb5b5b5);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = @"距离本场结束";
    }
    return _subTitleLabel;
}

- (WeiMiCountDownItem *)hourView
{
    if (!_hourView) {
        _hourView = [[WeiMiCountDownItem alloc] init];
        [_hourView setTitleWithCount:@"00"];
    }
    return _hourView;
}

- (WeiMiCountDownItem *)minuteView
{
    if (!_minuteView) {
        _minuteView = [[WeiMiCountDownItem alloc] init];
        [_minuteView setTitleWithCount:@"59"];
    }
    return _minuteView;
}

- (WeiMiCountDownItem *)secondView
{
    if (!_secondView) {
        _secondView = [[WeiMiCountDownItem alloc] init];
        [_secondView setTitleWithCount:@"00"];
    }
    return _secondView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)updateConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
        make.bottom.mas_lessThanOrEqualTo(0).offset(-5);
    }];
    
    
    [@[_titleLabel, _subTitleLabel] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
    }];
    
    [_hourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_minuteView.mas_left).offset(-10);
        make.bottom.mas_equalTo(_minuteView);
        make.size.mas_equalTo(CGSizeMake(25, 25));

    }];
    
    [_minuteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_minuteView.mas_right).offset(10);
        make.bottom.mas_equalTo(_minuteView);
        make.size.mas_equalTo(CGSizeMake(25, 25));

    }];
    
    [super updateConstraints];
}
@end
