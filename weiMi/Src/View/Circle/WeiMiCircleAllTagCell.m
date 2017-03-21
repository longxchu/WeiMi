//
//  WeiMiCircleAllTagCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleAllTagCell.h"

@interface WeiMiCircleAllTagCell()

@property (nonatomic, strong) UIView *lineView;

@end

@implementation WeiMiCircleAllTagCell

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.frame = CGRectMake(0, 0, 4, self.height);
        _lineView.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    if (selected) {
        [self addSubview:self.lineView];
        self.backgroundColor = kWhiteColor;

    }
    else {
        [self.lineView removeFromSuperview];
        self.backgroundColor = HEX_RGB(0xF1F1F1);

    }
}



@end
