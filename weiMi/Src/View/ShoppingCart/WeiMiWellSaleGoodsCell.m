//
//  WeiMiHotGoodsCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/18.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWellSaleGoodsCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiWellSaleGoodsCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation WeiMiWellSaleGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.priceLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiHPProductListDTO *)dto
{
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.faceImgPath)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.productName;
    _priceLabel.attributedText = [self attrStringWithSuff:dto.price.floatValue];
}

- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kGrayColor;
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"加载中";
    }
    return _titleLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
            
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.attributedText = [self attrStringWithSuff:0.0f];
    }
    return _priceLabel;
}

#pragma mark - CommonMethods
- (NSMutableAttributedString *)attrStringWithSuff:(double)suff
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] init];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", suff] attributes:@{
                                                                                                                                    NSFontAttributeName:[UIFont systemFontOfSize:15], NSForegroundColorAttributeName:HEX_RGB(0xF25008)}];
    [attString appendAttributedString:sufStr];
    return attString;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(_cellImageView.mas_width);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_cellImageView.mas_bottom);
        make.left.right.mas_equalTo(0);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_titleLabel.mas_bottom);
    }];
    [super updateConstraints];
}

@end
