//
//  WeiMiBillInfoCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBillInfoCell.h"
@interface WeiMiBillInfoCell()
{
    
}

@property (nonatomic, strong) UILabel *billInfo;
@property (nonatomic, strong) UILabel *billHeadLB;
@property (nonatomic, strong) UILabel *billContentLB;
@property (nonatomic, strong) UILabel *billTypeLB;

@end

@implementation WeiMiBillInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addSubview:self.billInfo];
        [self addSubview:self.billHeadLB];
        [self addSubview:self.billContentLB];
        [self addSubview:self.billTypeLB];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark -Getter


- (UILabel *)billInfo
{
    if (!_billInfo) {
        
        _billInfo = [[UILabel alloc] init];
        _billInfo.font = WeiMiSystemFontWithpx(22);
        _billInfo.textAlignment = NSTextAlignmentLeft;
        //        _priceLabel.textColor = kGrayColor;
        _billInfo.text = @"发票信息";
    }
    return _billInfo;
}
- (UILabel *)billHeadLB
{
    if (!_billHeadLB) {
        
        _billHeadLB  = [[UILabel alloc] init];
        _billHeadLB.font = WeiMiSystemFontWithpx(20);
        _billHeadLB.textAlignment = NSTextAlignmentLeft;
        _billHeadLB.textColor = kGrayColor;
        _billHeadLB.text = @"发票抬头：个人";
    }
    return _billHeadLB;
}

- (UILabel *)billContentLB
{
    if (!_billContentLB) {
        
        _billContentLB = [[UILabel alloc] init];
        _billContentLB.font = WeiMiSystemFontWithpx(20);
        _billContentLB.textAlignment = NSTextAlignmentLeft;
        _billContentLB.textColor = kGrayColor;
        _billContentLB.text = @"发票内容：明细";
    }
    return _billContentLB;
}

- (UILabel *)billTypeLB
{
    if (!_billTypeLB) {
        
        _billTypeLB = [[UILabel alloc] init];
        _billTypeLB.font = WeiMiSystemFontWithpx(22);
        _billTypeLB.textColor = kGrayColor;
        _billTypeLB.textAlignment = NSTextAlignmentLeft;
        _billTypeLB.text = @"纸质发票";
    }
    return _billTypeLB;
}

#pragma mark - Util



#pragma mark - Layout
- (void)updateConstraints
{
    [_billInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(_billTypeLB.mas_left).offset(-10);
    }];
    
    [_billTypeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_billInfo);
    }];
    
    [_billHeadLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_billInfo);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_billContentLB.mas_top).offset(-5);
    }];
    
    [_billContentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_billInfo);
        make.right.mas_equalTo(_billTypeLB);
        make.bottom.mas_equalTo(-15);
    }];
    
  
    
    
    [super updateConstraints];
}


@end
