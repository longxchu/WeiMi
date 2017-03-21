//
//  WeiMiSignCollectionViewCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSignCollectionViewCell.h"

@interface WeiMiSignCollectionViewCell()

@end

@implementation WeiMiSignCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
//        [self addSubview:self.numLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image =[UIImage imageNamed: @"followus_bg480x800"];
    }
    return _cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"口爱打卡";
    }
    return _titleLabel;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.font = [UIFont systemFontOfSize:10];
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _numLabel.text = @"4124人参与";
    }
    return _numLabel;
}

- (void)updateConstraints
{
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(_cellImageView.mas_height);
        make.height.mas_equalTo(self).multipliedBy(0.69);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_cellImageView);
        make.height.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(_cellImageView.mas_right).offset(5);
    }];
    
//    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(_cellImageView.mas_right).offset(5);
//        make.bottom.mas_equalTo(_cellImageView);
//        make.right.mas_equalTo(_titleLabel);
//    }];
    
    [super updateConstraints];
}
@end
