//
//  WeiMiCountDownItem.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCountDownItem.h"

@interface WeiMiCountDownItem()

@end

@implementation WeiMiCountDownItem

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.bgView];
        [self addSubview:self.label];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setTitleWithCount:(NSString *)num
{
    self.label.text = num;
}

#pragma mark -Getter
- (UIImageView *)bgView
{
    if (!_bgView) {
        
        _bgView = [[UIImageView alloc] init];
        _bgView.image = [UIImage imageNamed:@"yellow_rectangle"];
    }
    return _bgView;
}

- (UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"00";
    }
    return _label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}

- (void)updateConstraints
{
    [@[_bgView, _label] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
    
    [super updateConstraints];
}

@end
