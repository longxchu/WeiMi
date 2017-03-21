//
//  WeiMiBaseCommonHeader.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommonHeader.h"
#import "UIButton+CenterImageAndTitle.h"

@interface WeiMiCommonHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *button;

@end
@implementation WeiMiCommonHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self =[super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.titleLabel];
        [self addSubview:self.button];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UIButton *)button
{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_button setTitle:@"换一换" forState:UIControlStateNormal];
        [_button setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"icon_change"] forState:UIControlStateNormal];
        [_button setImage:[UIImage imageNamed:@"icon_change"] forState:UIControlStateSelected];
        [_button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"热帖推荐";
    }
    return _titleLabel;
}

- (void)setTitle:(NSString *)title
{
    self.titleLabel.text = title;
}


#pragma mark - Acitons
- (void)onButton:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(didSelectedBtn)]) {
        [self.delegate didSelectedBtn];
    }
    
    OnChangeBtnHandler block = self.onChangeBtnHandler;
    if (block) {
        block();
    }
    
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.button horizontalCenterImageAndTitle];
}

- (void)updateConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
    }];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    [super updateConstraints];
}

@end
