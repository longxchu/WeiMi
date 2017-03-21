//
//  WeiMiOrderDetailHeaderView.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOrderDetailHeaderView.h"

@interface WeiMiOrderDetailHeaderView()

@property (nonatomic, strong) UILabel *notiLabel;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WeiMiOrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"orderBanner"]];
        [self addSubview:self.imageView];
        [self addSubview:self.notiLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Setter
- (void)setTitle:(NSString *)str
{
    _notiLabel.text = str;
}

- (void)setBGImage:(NSString *)img
{
    _imageView.image = [UIImage imageNamed:img];
}

#pragma mark - Getter
- (UILabel *)notiLabel
{
    if (!_notiLabel) {
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        _notiLabel.textColor = kWhiteColor;
        _notiLabel.textAlignment = NSTextAlignmentLeft;
        _notiLabel.numberOfLines= 0;
        [_notiLabel sizeToFit];
    }
    return _notiLabel;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"banner_succeed"];
    }
    return _imageView;
}

#pragma Layout
- (void)updateConstraints
{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(35);
    }];
    [super updateConstraints];
    
}

@end
