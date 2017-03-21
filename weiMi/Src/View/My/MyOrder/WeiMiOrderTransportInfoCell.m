//
//  WeiMiOrderTransportInfoCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOrderTransportInfoCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiOrderTransportInfoCell()
{
    
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *offPriceLabel;
@property (nonatomic, strong) UILabel *numLaebl;

@end

@implementation WeiMiOrderTransportInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
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

- (UILabel *)numLaebl
{
    if (!_numLaebl) {
        
        _numLaebl = [[UILabel alloc] init];
        _numLaebl.font = WeiMiSystemFontWithpx(18);
        _numLaebl.textAlignment = NSTextAlignmentRight;
        _numLaebl.textColor = kGrayColor;
        _numLaebl.attributedText = [self configTransortPrice:@"22.8"];
    }
    return _numLaebl;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = WeiMiSystemFontWithpx(18);
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
        _subTitleLabel.font = WeiMiSystemFontWithpx(20);
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = kGrayColor;
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.text = @"实付款";
    }
    return _subTitleLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = WeiMiSystemFontWithpx(18);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"运费";
    }
    return _titleLabel;
}

- (UILabel *)offPriceLabel
{
    if (!_offPriceLabel) {
        
        _offPriceLabel = [[UILabel alloc] init];
        [_offPriceLabel sizeToFit];
        _offPriceLabel.font = WeiMiSystemFontWithpx(18);
        _offPriceLabel.textAlignment = NSTextAlignmentRight;
        _offPriceLabel.text = @"全场包邮";
    }
    return _offPriceLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)configTransortPrice:(NSString *)str
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"¥" attributes:@{NSFontAttributeName:WeiMiSystemFontWithpx(18),
        NSForegroundColorAttributeName:HEX_RGB(0xFC3900)}];
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:WeiMiSystemFontWithpx(22),
        NSForegroundColorAttributeName:HEX_RGB(0xFC3900)}]];
    NSRange range = [str rangeOfString:@"."];
    [attStr setAttributes:@{NSFontAttributeName:WeiMiSystemFontWithpx(18),
                            NSForegroundColorAttributeName:HEX_RGB(0xFC3900)} range:NSMakeRange(range.location + 1, str.length - range.location)];
    return attStr;
}


#pragma mark - Layout
- (void)updateConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(_priceLabel.mas_left).offset(-10);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(5);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_offPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_priceLabel.mas_bottom);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_numLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_lessThanOrEqualTo(_offPriceLabel.mas_bottom);
        make.bottom.mas_equalTo(-5);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(self).offset(-10);
    }];
    
    [super updateConstraints];
}

@end
