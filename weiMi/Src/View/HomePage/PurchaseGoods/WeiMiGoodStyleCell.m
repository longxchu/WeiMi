//
//  WeiMiGoodStyleCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodStyleCell.h"

@interface WeiMiGoodStyleCell()


@end

@implementation WeiMiGoodStyleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.btn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _btn.layer.borderColor = HEX_RGB(0xFA601A).CGColor;
        _btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btn.layer.borderWidth = 1.0f;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 5.0f;
//        [_btn setTitle:safeObjectAtIndex(_dataSource, indexPath.row) forState:UIControlStateNormal];
        [_btn setTitleColor:kBlackColor forState:UIControlStateNormal];
        _btn.titleLabel.font= WeiMiSystemFontWithpx(20);
        [_btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        [_btn setTitleColor:HEX_RGB(0xFA601A) forState:UIControlStateSelected];
        [_btn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _btn.userInteractionEnabled = NO;

    }
    return _btn;
}

- (void)onButton:(UIButton *)btn
{
    
}

- (void)setSelected:(BOOL)selected
{
    if (_btn) {
        _btn.selected = selected;
        if (selected) {
            _btn.layer.borderColor = HEX_RGB(0xFA601A).CGColor;
        }else
        {
            _btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        }
    }
}

- (void)updateConstraints
{
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}

@end
