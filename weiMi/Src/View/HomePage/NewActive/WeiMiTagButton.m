//
//  WeiMiTagButton.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTagButton.h"

@implementation WeiMiTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        [self addSubview:self.tagLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setImage:(NSString *)image title:(NSString *)title
{
    _imageView.image = [UIImage imageNamed:image];
    _tagLabel.text = title;
    [_imageView sizeToFit];
    [_tagLabel sizeToFit];
}
#pragma mark - Getter
- (UIImageView *)imageView
{
    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.image = [UIImage imageNamed:@"icon_zan"];
    }
    return _imageView;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _tagLabel.textAlignment = NSTextAlignmentRight;
        _tagLabel.text= @"12";
        [_tagLabel sizeToFit];
    }
    return _tagLabel;
}

- (void)updateConstraints
{
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(24, 24));
//        make.top.mas_equalTo(self.mas_centerY).offset(-5);
    }];
    
    [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_imageView.mas_right).offset(-5);
        make.bottom.mas_equalTo(_imageView.mas_top).offset(5);
    }];
    
    [super updateConstraints];
}

@end
