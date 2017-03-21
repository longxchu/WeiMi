//
//  WeiMiGoodsDetailTagItem.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodsDetailTagItem.h"

@implementation WeiMiGoodsDetailTagItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.imageView];
        [self addSubview:self.label];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setCellWithTitle:(NSString *)title image:(NSString *)image
{
    _label.text = title;
    _imageView.image = [UIImage imageNamed:image];
}

#pragma mark - Getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _label.textColor = kGrayColor;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

-(void)updateConstraints
{
//    [@[_imageView, _label] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:5 leadSpacing:10 tailSpacing:0];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.mas_equalTo(10);
        make.height.mas_equalTo(self).multipliedBy(0.5);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_imageView.mas_bottom).offset(5);
    }];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_imageView.mas_height);
        make.centerX.mas_equalTo(self);
    }];
    
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
    }];
    [super updateConstraints];
}


@end
