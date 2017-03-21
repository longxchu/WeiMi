//
//  WeiMiHPTopIMGReusableView.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHPTopIMGReusableView.h"
#import <UIButton+WebCache.h>

@interface WeiMiHPTopIMGReusableView()

@property (nonatomic, strong) UIButton *leftBTN;
@property (nonatomic, strong) UIButton *rightBTN;

@end

@implementation WeiMiHPTopIMGReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.leftBTN];
        [self addSubview:self.rightBTN];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UIButton *)leftBTN
{
    if (!_leftBTN) {
        _leftBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_leftBTN setBackgroundImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        [_leftBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] forState:UIControlStateNormal];

    }
    return _leftBTN;
}

- (UIButton *)rightBTN
{
    if (!_rightBTN) {
        _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightBTN setBackgroundImage:[UIImage imageNamed:@"icon_zan"] forState:UIControlStateNormal];
        [_rightBTN sd_setBackgroundImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] forState:UIControlStateNormal];
    }
    return _rightBTN;
}

- (void)updateConstraints
{
    [@[_leftBTN , _rightBTN] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    [@[_leftBTN , _rightBTN] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(0);
    }];
    [super updateConstraints];
}
@end
