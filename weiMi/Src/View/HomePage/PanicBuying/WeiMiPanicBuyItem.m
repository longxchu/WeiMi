//
//  WeiMiPanicBuyItem.m
//  weiMi
//
//  Created by 梁宪松 on 2016/12/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPanicBuyItem.h"
#import <UIImageView+WebCache.h>

@interface WeiMiPanicBuyItem()
{
    WeiMiHPProductListDTO *_dto;
}

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *maskBtn;

@end

@implementation WeiMiPanicBuyItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubview:self.backImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.maskBtn];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiHPProductListDTO *)dto
{
    if (_dto && [_dto isEqualToDto:dto]) {
        return;
    }
    _dto = dto;
    [_backImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.faceImgPath)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.brandName;
    _subTitleLabel.text = dto.productName;
}


#pragma mark - Getter
- (UIButton *)maskBtn
{
    if (!_maskBtn) {
        
        _maskBtn = [[UIButton alloc] init];
        [_maskBtn addTarget:self action:@selector(onButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _maskBtn;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _backImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:kFontSizeWithpx(22)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"商品暂缺";
    }
    return _titleLabel;
}



- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.numberOfLines = 1;
        _subTitleLabel.textColor = kGrayColor;
        _subTitleLabel.text = @"商品暂缺";
    }
    return _subTitleLabel;
}

#pragma mark - Actions
- (void)onButton
{
    OnItemHandler handler = self.onItemHandler;
    if (handler) {
        handler(_dto.productId);
    }
}

- (void)updateConstraints
{
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(_backImageView.mas_width);
        make.width.mas_equalTo(self).multipliedBy(0.5);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(_subTitleLabel.mas_top);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(_backImageView.mas_top).offset(-10);
        make.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    [_maskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}

@end
