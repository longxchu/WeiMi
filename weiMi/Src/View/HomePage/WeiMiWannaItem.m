//
//  WeiMiWannaItem.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWannaItem.h"
#import <UIImageView+WebCache.h>
@interface WeiMiWannaItem()


@property (nonatomic, strong) UIImageView *backImageView;


@end

@implementation WeiMiWannaItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.foreImageView];
        [self addSubview:self.remarkLB];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setItemWithTitle:(NSString *)title img:(NSString *)img
{
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(img)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
//    _remarkLB.text = title;
////    NSLog(@"%@",_remarkLB.text);
}

#pragma mark - Getter
- (UIImageView *)foreImageView
{
    if (!_foreImageView) {
        
        _foreImageView = [[UIImageView alloc] init];
//        _foreImageView.image = [UIImage imageNamed:@"icon_gotohead"];
    }
    return _foreImageView;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _backImageView;
}

- (UILabel *)remarkLB
{
    if (!_remarkLB) {
        _remarkLB = [[UILabel alloc] init];
        _remarkLB.font = [UIFont fontWithName:@"Arial-BoldMT" size:kFontSizeWithpx(24)];
        _remarkLB.textAlignment = NSTextAlignmentCenter;
        _remarkLB.numberOfLines = 3;
//        _remarkLB.text = @"商品暂缺";
    }
    return _remarkLB;
}

- (void)updateConstraints
{
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [_foreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(13);
        make.centerY.mas_equalTo(_backImageView).multipliedBy(1.6);
    }];
    
    [_remarkLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(_foreImageView.mas_top).offset(-5);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    [super updateConstraints];
}

@end
