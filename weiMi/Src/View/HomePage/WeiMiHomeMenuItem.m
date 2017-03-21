//
//  WeiMiHomeMenuItem.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomeMenuItem.h"
#import <UIImageView+WebCache.h>
@interface WeiMiHomeMenuItem()



@end
@implementation WeiMiHomeMenuItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setCellWithTitle:(NSString *)title image:(NSString *)image
{
    _label.text = title;
//    _imageView.image = [UIImage imageNamed:image];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(image)]placeholderImage:WEIMI_PLACEHOLDER_RECT];
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
        _label.font = [UIFont systemFontOfSize:kFontSizeWithpx(21)];
        _label.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

-(void)updateConstraints
{
    [@[_imageView, _label] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:5 leadSpacing:10 tailSpacing:10];
    
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
