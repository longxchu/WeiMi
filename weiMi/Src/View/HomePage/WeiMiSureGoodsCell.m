//
//  WeiMiSureGoodsCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSureGoodsCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiSureGoodsCell()
{
    
}

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *numLaebl;
@property (nonatomic, strong) UILabel *tagLB;
@end


@implementation WeiMiSureGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.numLaebl];
        [self addSubview:self.tagLB];
        
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

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _tagLB.textAlignment = NSTextAlignmentCenter;
        _tagLB.text = @"限时抢购";
        _tagLB.backgroundColor = HEX_RGB(0xFFED00);
        _tagLB.layer.masksToBounds = YES;
        _tagLB.layer.cornerRadius = 3.0f;
        [_tagLB sizeToFit];
    }
    return _tagLB;
}

- (UILabel *)numLaebl
{
    if (!_numLaebl) {
        
        _numLaebl = [[UILabel alloc] init];
        _numLaebl.font = [UIFont systemFontOfSize:kFontSizeWithpx(18)];
        _numLaebl.textAlignment = NSTextAlignmentLeft;
        _numLaebl.textColor = kGrayColor;
        _numLaebl.numberOfLines = 2;
        _numLaebl.text = @"规格：爽滑冰感\n数量:1";
        [_numLaebl sizeToFit];
    }
    return _numLaebl;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        //        _priceLabel.textColor = kGrayColor;
        _priceLabel.text = @"￥9.01";
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

#pragma mark - Util
- (NSMutableAttributedString *)configOffPrice:(NSString *)str
{
    return [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}];
}


#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_priceLabel sizeToFit];
}
- (void)updateConstraints
{
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(13);
        make.height.mas_equalTo(_cellImageView.mas_width);
        make.top.mas_equalTo(13);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(_priceLabel.mas_left).offset(-10);
    }];
    
    [_priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10).priorityHigh();
        make.top.mas_equalTo(_titleLabel);
        make.width.mas_greaterThanOrEqualTo([_priceLabel size].width);
    }];
    
    
    [_numLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(_cellImageView.mas_bottom);
    }];
    
    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_priceLabel.mas_bottom).offset(5);
        make.right.mas_equalTo(_priceLabel);
        make.height.mas_equalTo(GetAdapterHeight(24));
        make.width.mas_equalTo(_tagLB.mas_height).multipliedBy(3.4);
    }];
    
    [super updateConstraints];
}
@end
