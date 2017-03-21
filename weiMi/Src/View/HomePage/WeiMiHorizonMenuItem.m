//
//  WeiMiHorizonMenuItem.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHorizonMenuItem.h"
#import "UIImageView+WebCache.h"

//#define LAYERHEIGHT  (CGRectGetHeight(self.frame) * 47.0 / 200.0)
@interface WeiMiHorizonMenuItem()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) CALayer *transparentLayer;

@property (nonatomic, strong) UIView *shadowView;

@end

@implementation WeiMiHorizonMenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
   
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        
//        [self.layer addSublayer:self.transparentLayer];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.shadowView];
        [self.shadowView addSubview:self.label];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithTitle:(NSString *)title img:(NSString *)img
{
    _label.text = title;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(img)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
}

#pragma mark - Getter
- (UIView *)shadowView
{
    if (!_shadowView) {
        
        _shadowView = [[UIView alloc] init];
        _shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _shadowView;
}
//- (CALayer *)transparentLayer
//{
//    if (!_transparentLayer) {
//        
//        _transparentLayer = [CALayer layer];
//        _transparentLayer.backgroundColor = kBlackColor.CGColor;
//        _transparentLayer.bounds = CGRectMake(0, 0, self.width, LAYERHEIGHT);
//        _transparentLayer.position = CGPointMake(0, self.height - LAYERHEIGHT);
//        _transparentLayer.opacity = 0.5;
//    }
//    return _transparentLayer;
//}

- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
//        _imageView.image =[UIImage imageNamed: @"followus_bg480x800"];
        _imageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _imageView;
}

- (UILabel *)label
{
    if (!_label) {
        
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = kWhiteColor;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"磨人的小妖精";
    }
    return _label;
}

- (void)updateConstraints
{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
    
    [_shadowView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(self).multipliedBy(0.25);
    }];

    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(_shadowView);
    }];
    
    [super updateConstraints];
}
@end
