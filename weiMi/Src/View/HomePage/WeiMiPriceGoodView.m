//
//  WeiMiPriceGoodView.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPriceGoodView.h"
#import "WeiMiPriceTagView.h"
#import <UIImageView+WebCache.h>
@interface WeiMiPriceGoodView()

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, strong) WeiMiPriceTagView *tagView;

@end

@implementation WeiMiPriceGoodView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.tagView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithPrice:(NSString *)price img:(NSString *)img
{
    [_bgImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(img)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _tagView.tagPrice = price ? price : @"0";
}

#pragma mark - Getter
- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.frame = self.frame;
        _bgImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _bgImageView;
}

- (WeiMiPriceTagView *)tagView
{
    if (!_tagView) {
        
        _tagView = [[WeiMiPriceTagView alloc] init];
//        _tagView.transform = CGAffineTransformMakeRotation(- M_PI/4);
        
    }
    return _tagView;
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    _tagView.frame = CGRectMake(10, 40, 40, 40);
}
- (void)updateConstraints
{
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.mas_equalTo(self);
    }];
    
    [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.centerY.mas_equalTo(self).offset(-10);
    }];

    [super updateConstraints];
}

@end
