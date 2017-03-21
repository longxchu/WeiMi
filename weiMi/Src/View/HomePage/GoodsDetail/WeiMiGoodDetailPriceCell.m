//
//  WeiMiGoodDetailPriceCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodDetailPriceCell.h"
#import <NSMutableAttributedString+OHAdditions.h>
@implementation WeiMiGoodDetailPriceModel
@end

@interface WeiMiGoodDetailPriceCell()
{
    
}

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numLaebl;

@end

@implementation WeiMiGoodDetailPriceCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.numLaebl];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWith:(WeiMiGoodDetailPriceModel *)model
{
    _titleLabel.text = model.productName;
    _numLaebl.text = [NSString stringWithFormat:@"%@人已购买",model.salesVolume ? model.salesVolume:@"0"];
    _priceLabel.attributedText = [self configPrice:model.price OffPrice:[NSString stringWithFormat:@"%.2f", (model.price.floatValue * 1.2)]];

}

#pragma mark -Getter
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

- (UILabel *)numLaebl
{
    if (!_numLaebl) {
        
        _numLaebl = [[UILabel alloc] init];
        _numLaebl.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _numLaebl.textAlignment = NSTextAlignmentRight;
        _numLaebl.textColor = kGrayColor;
        _numLaebl.text = @"538人已购买";
    }
    return _numLaebl;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        //        _priceLabel.textColor = kGrayColor;
        _priceLabel.attributedText = [self configPrice:@"69.00" OffPrice:@"169.00"];
    }
    return _priceLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)configPrice:(NSString *)price OffPrice:(NSString *)offPrice
{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@ ", price] attributes:@{NSFontAttributeName:WeiMiSystemFontWithpx(22), NSForegroundColorAttributeName:kRedColor}];
    NSMutableAttributedString *suf = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"市场价:¥%@", offPrice] attributes:@{
                            NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle),
                            NSFontAttributeName:WeiMiSystemFontWithpx(18),
                            NSForegroundColorAttributeName:kGrayColor}];
    [att appendAttributedString:suf];
    return att;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(5);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.mas_equalTo(10);
        make.bottom.mas_equalTo(-5);
    }];
    
    [_numLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_priceLabel);
    }];
    [super updateConstraints];
}

@end
