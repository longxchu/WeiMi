//
//  WeiMiPurchaseGoodsHeader.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPurchaseGoodsHeader.h"

@implementation WeiMiPurchaseGoodsHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
//        _textLabel.textColor = [UIColor colorWithWhite:0.294 alpha:1.000];
        _textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _textLabel.text= @"规格";
    }
    return _textLabel;
}

- (void)updateConstraints
{
    [_textLabel mas_updateConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
    }];
    [super updateConstraints];
}

@end
