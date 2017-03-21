//
//  WeiMiOrderGoodInfoCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOrderGoodInfoCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiOrderGoodInfoCell()
{
   
}

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *offPriceLabel;
@property (nonatomic, strong) UILabel *numLaebl;

@end

@implementation WeiMiOrderGoodInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.offPriceLabel];
        [self addSubview:self.numLaebl];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark -Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = [UIImage imageNamed:@"followus_bg480x800"];
    }
    return _cellImageView;
}

- (UILabel *)offPriceLabel
{
    if (!_offPriceLabel) {
        
        _offPriceLabel = [[UILabel alloc] init];
        _offPriceLabel.font = [UIFont systemFontOfSize:14];
        _offPriceLabel.textAlignment = NSTextAlignmentRight;
        _offPriceLabel.textColor = kGrayColor;
        _offPriceLabel.attributedText = [self configOffPrice: @"￥99.01"];
    }
    return _offPriceLabel;
}

- (UILabel *)numLaebl
{
    if (!_numLaebl) {
        
        _numLaebl = [[UILabel alloc] init];
        _numLaebl.font = [UIFont systemFontOfSize:14];
        _numLaebl.textAlignment = NSTextAlignmentRight;
        _numLaebl.textColor = kGrayColor;
        _numLaebl.text = @"x3";
    }
    return _numLaebl;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        //        _priceLabel.textColor = kGrayColor;
        _priceLabel.text = @"￥99.01";
    }
    return _priceLabel;
}
- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel  = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = kGrayColor;
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.text = @"规格:白色睡裙M码";
    }
    return _subTitleLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
    }
    return _titleLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)configOffPrice:(NSString *)str
{
    return [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}];
}


#pragma mark - Layout
- (void)updateConstraints
{

    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(_cellImageView.mas_width);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(_priceLabel.mas_left).offset(-10);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_titleLabel);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_offPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_priceLabel.mas_bottom).offset(5);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_numLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_offPriceLabel.mas_bottom).offset(5);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
    }];

    [super updateConstraints];
}


@end
