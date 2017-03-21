//
//  WeiMiPanicBuyCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPanicBuyCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiPanicBuyCell()
{
    
}

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *offPriceLabel;
@property (nonatomic, strong) UIButton *offRateBTN;
@property (nonatomic, strong) UIButton *rightBTN;
@property (nonatomic, strong) UIButton *finishBTN;

@end

@implementation WeiMiPanicBuyCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.offPriceLabel];
        [self addSubview:self.offRateBTN];
        [self addSubview:self.rightBTN];
        [self addSubview:self.finishBTN];

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
        [_offPriceLabel sizeToFit];
    }
    return _offPriceLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        _priceLabel.textColor = kRedColor;
        _priceLabel.text = @"￥99.01";
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
    }
    return _titleLabel;
}

- (UIButton *)offRateBTN
{
    if (!_offRateBTN) {
        
        _offRateBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_offRateBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_offRateBTN setTitle:@"2.5折" forState:UIControlStateNormal];
        _offRateBTN.titleLabel.font = WeiMiSystemFontWithpx(18);
        [_offRateBTN setBackgroundImage:[UIImage imageNamed:@"orange_btn"] forState:UIControlStateNormal];
        
    }
    return _offRateBTN;
}

- (UIButton *)rightBTN
{
    if (!_rightBTN) {
        
        _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_rightBTN setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateSelected];
        [_rightBTN setTitle:@"立即抢购" forState:UIControlStateNormal];
        [_rightBTN setTitle:@"找相似" forState:UIControlStateSelected];
        [_rightBTN setBackgroundImage:[UIImage imageNamed:@"purple_btn_pre"] forState:UIControlStateNormal];
        [_rightBTN setBackgroundImage:[UIImage imageNamed:@"purple_btn_box_pre"] forState:UIControlStateSelected];
        _rightBTN.titleLabel.font = WeiMiSystemFontWithpx(20);
        _rightBTN.layer.borderColor = HEX_RGB(BASE_COLOR_HEX).CGColor;
        _rightBTN.layer.borderWidth = 1.0f;
        _rightBTN.layer.cornerRadius = 3.0f;
        _rightBTN.layer.masksToBounds = YES;
        
        _rightBTN.selected = YES;
    }
    return _rightBTN;
}

- (UIButton *)finishBTN
{
    if (!_finishBTN) {
        _finishBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_finishBTN setTitle:@"抢完啦" forState:UIControlStateNormal];
        [_finishBTN setBackgroundImage:[UIImage imageNamed:@"circle_bg"] forState:UIControlStateNormal];
    }
    return _finishBTN;
}

#pragma mark - Util
- (NSMutableAttributedString *)configOffPrice:(NSString *)str
{
    return [[NSMutableAttributedString alloc] initWithString:str attributes:@{
                    NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                    NSFontAttributeName:WeiMiSystemFontWithpx(18)
                    }];
}


#pragma mark - Layout
- (void)updateConstraints
{
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(_cellImageView.mas_width);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_finishBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(_cellImageView).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(-10);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(_cellImageView);
//        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_offPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_priceLabel.mas_right).offset(5);
        make.bottom.mas_equalTo(_priceLabel);
//        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_offRateBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
        make.bottom.mas_equalTo(_offPriceLabel.mas_top).offset(-10);
    }];
    
    [_rightBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(_cellImageView);
        make.height.mas_equalTo(GetAdapterHeight(28));
        make.width.mas_equalTo(_rightBTN.mas_height).multipliedBy(2.62).offset(10);
    }];
    
    [super updateConstraints];
}

@end
