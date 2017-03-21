//
//  WeiMiHomePageChoiceTagCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomePageChoiceTagCell.h"

@interface WeiMiHomePageChoiceTagCell()



@end

@implementation WeiMiHomePageChoiceTagCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.button];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _button.titleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _button.layer.borderWidth = 1.0f;
        _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _button.layer.cornerRadius = 3.0f;
    }
    return _button;
}


- (void)updateConstraints
{
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}
@end
