//
//  WeiMiHomePageGoodsCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomePageGoodsCell.h"
#import "UIImageView+WebCache.h"

@interface WeiMiHomePageGoodsCell()
{
    NSUInteger _buyNum;
    NSUInteger _applyNum;
    
}

@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *infoLB;
@property (nonatomic, strong) UILabel *priceLB;

@end

@implementation WeiMiHomePageGoodsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {

        [self addSubview:self.cellImage];
        [self addSubview:self.titleLB];
        [self addSubview:self.infoLB];
        [self addSubview:self.priceLB];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiHPProductListDTO *)dto;
{
    [_cellImage sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.faceImgPath)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
    _titleLB.text = dto.productName;
    _infoLB.text = [NSString stringWithFormat:@"销量：%@", dto.salesVolume];
    _priceLB.text = [NSString stringWithFormat:@"¥%@", dto.price];

}

#pragma mark - Getter
- (UIImageView *)cellImage
{     
    if (!_cellImage) {
        
        _cellImage = [[UIImageView alloc] init];
//        _cellImage.image = [UIImage imageNamed:@"followus_bg480x800"];
    }
    return _cellImage;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        
        _titleLB = [[UILabel alloc] init];
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLB.numberOfLines = 2;
//        _titleLB.text = @"秘籍 夜魅精灵女用萨达是发顺丰";
//        [_titleLB sizeToFit];
    }
    return _titleLB;
}

- (UILabel *)infoLB
{
    if (!_infoLB) {
        
        _infoLB = [[UILabel alloc] init];
        _infoLB.textAlignment = NSTextAlignmentRight;
        _infoLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _infoLB.textColor = kGrayColor;
//        _infoLB.text = @"销量：1200";
        [_infoLB sizeToFit];
    }
    return _infoLB;
}

- (UILabel *)priceLB
{
    if (!_priceLB) {
        
        _priceLB = [[UILabel alloc] init];
        _priceLB.textAlignment = NSTextAlignmentLeft;
        _priceLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _priceLB.textColor = kRedColor;
//        _priceLB.text = @"¥35.00";
        [_priceLB sizeToFit];
    }
    return _priceLB;
}
#pragma mark - Layout
- (void)updateConstraints
{
    [_cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(_cellImage.mas_width);
    }];
    
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_cellImage);
        make.top.mas_equalTo(_cellImage.mas_bottom).offset(10);
    }];
    
    [@[_priceLB,_infoLB] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [@[_priceLB,_infoLB] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self).offset(-10);
    }];
    [super updateConstraints];
}


@end
