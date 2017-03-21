//
//  WeiMiSureOrderGoodsInfoCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSureOrderGoodsInfoCell.h"

@interface WeiMiSureOrderGoodsInfoCell()
{
    
}

@property (nonatomic, strong) UILabel *billGoodsPriceLB;
@property (nonatomic, strong) UILabel *billInfo;
@property (nonatomic, strong) UILabel *billHeadLB;
@property (nonatomic, strong) UILabel *billContentLB;

@property (nonatomic, strong) UILabel *billGoodsValueLB;
@property (nonatomic, strong) UILabel *billInfoValueLB;
@property (nonatomic, strong) UILabel *billHeadValueLB;
@property (nonatomic, strong) UILabel *billContentValueLB;
@end

@implementation WeiMiSureOrderGoodsInfoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.billGoodsPriceLB];
        [self addSubview:self.billInfo];
        [self addSubview:self.billHeadLB];
        [self addSubview:self.billContentLB];
        [self setNeedsUpdateConstraints];
        
        [self addSubview:self.billGoodsValueLB];
        [self addSubview:self.billInfoValueLB];
        [self addSubview:self.billHeadValueLB];
        [self addSubview:self.billContentValueLB];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark -Getter
- (UILabel *)billGoodsPriceLB
{
    if (!_billGoodsPriceLB) {
        
        _billGoodsPriceLB = [[UILabel alloc] init];
        _billGoodsPriceLB.font = WeiMiSystemFontWithpx(22);
        _billGoodsPriceLB.textAlignment = NSTextAlignmentLeft;
        _billGoodsPriceLB.textColor = kGrayColor;
        _billGoodsPriceLB.text = @"商品总价：";
    }
    return _billGoodsPriceLB;
}

- (UILabel *)billInfo
{
    if (!_billInfo) {
        
        _billInfo = [[UILabel alloc] init];
        _billInfo.font = WeiMiSystemFontWithpx(22);
        _billInfo.textAlignment = NSTextAlignmentLeft;
        _billInfo.textColor = kGrayColor;
        _billInfo.text = @"运费：";
    }
    return _billInfo;
}
- (UILabel *)billHeadLB
{
    if (!_billHeadLB) {
        
        _billHeadLB  = [[UILabel alloc] init];
        _billHeadLB.font = WeiMiSystemFontWithpx(22);
        _billHeadLB.textAlignment = NSTextAlignmentLeft;
        _billHeadLB.textColor = kGrayColor;
        _billHeadLB.text = @"运费减免：";
    }
    return _billHeadLB;
}

- (UILabel *)billContentLB
{
    if (!_billContentLB) {
        
        _billContentLB = [[UILabel alloc] init];
        _billContentLB.font = WeiMiSystemFontWithpx(22);
        _billContentLB.textAlignment = NSTextAlignmentLeft;
        _billContentLB.textColor = kGrayColor;
        _billContentLB.text = @"优惠减免：";
    }
    return _billContentLB;
}

- (UILabel *)billGoodsValueLB
{
    if (!_billGoodsValueLB) {
        
        _billGoodsValueLB = [[UILabel alloc] init];
        _billGoodsValueLB.font = WeiMiSystemFontWithpx(22);
        _billGoodsValueLB.textAlignment = NSTextAlignmentRight;
        _billGoodsValueLB.textColor = kRedColor;
        _billGoodsValueLB.text = @"¥296.80";
    }
    return _billGoodsValueLB;
}


- (UILabel *)billInfoValueLB
{
    if (!_billInfoValueLB) {
        
        _billInfoValueLB = [[UILabel alloc] init];
        _billInfoValueLB.font = WeiMiSystemFontWithpx(22);
        _billInfoValueLB.textAlignment = NSTextAlignmentRight;
        _billInfoValueLB.textColor = kRedColor;
        _billInfoValueLB.text = @"¥296.80";
    }
    return _billInfoValueLB;
}

- (UILabel *)billHeadValueLB
{
    if (!_billHeadValueLB) {
        
        _billHeadValueLB  = [[UILabel alloc] init];
        _billHeadValueLB.font = WeiMiSystemFontWithpx(22);
        _billHeadValueLB.textAlignment = NSTextAlignmentRight;
        _billHeadValueLB.textColor = kRedColor;
        _billHeadValueLB.text = @"¥0.00";
    }
    return _billHeadValueLB;
}

- (UILabel *)billContentValueLB
{
    if (!_billContentValueLB) {
        
        _billContentValueLB = [[UILabel alloc] init];
        _billContentValueLB.font = WeiMiSystemFontWithpx(22);
        _billContentValueLB.textAlignment = NSTextAlignmentRight;
        _billContentValueLB.textColor = kRedColor;
        _billContentValueLB.text = @"¥0.00";
    }
    return _billContentValueLB;
}

#pragma mark - Util
- (NSMutableAttributedString *)attStrWithTilte:(NSString *)title gray:(BOOL)isGray detailTitle:(NSString *)detailTitle;
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentLeft;
    //    style.headIndent = 10;//左缩进
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,title.length)];
    [attrStr addAttribute:NSFontAttributeName value:WeiMiSystemFontWithpx(22) range:NSMakeRange(0,title.length)];
    if (isGray) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:kGrayColor range:NSMakeRange(0,title.length)];
    }
    
    NSMutableParagraphStyle *rightStyle = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentRight;
    NSMutableAttributedString *rightAttStr = [[NSMutableAttributedString alloc] initWithString:detailTitle];
    [rightAttStr addAttribute:NSParagraphStyleAttributeName value:rightStyle range:NSMakeRange(0,detailTitle.length)];
    [rightAttStr addAttribute:NSFontAttributeName value:WeiMiSystemFontWithpx(22) range:NSMakeRange(0,detailTitle.length)];
    [rightAttStr addAttribute:NSForegroundColorAttributeName value:kRedColor range:NSMakeRange(0,detailTitle.length)];
    
    [attrStr appendAttributedString:rightAttStr];
    return attrStr;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [@[_billGoodsPriceLB ,_billInfo, _billHeadLB, _billContentLB] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
    [@[_billGoodsPriceLB, _billInfo, _billHeadLB, _billContentLB] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.width/2);
    }];
    
    [@[_billGoodsValueLB,_billInfoValueLB, _billHeadValueLB, _billContentValueLB] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
    [@[_billGoodsValueLB,_billInfoValueLB, _billHeadValueLB, _billContentValueLB] mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(-self.width/2);
        make.right.mas_equalTo(-15);
    }];
    
    [super updateConstraints];
}


@end
