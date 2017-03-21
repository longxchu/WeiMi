//
//  WeiMiOrderInfoCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOrderInfoCell.h"

@interface WeiMiOrderInfoCell()
{
    
}

@property (nonatomic, strong) UILabel *orderCodeLB;
@property (nonatomic, strong) UILabel *createTimeLB;
@property (nonatomic, strong) UILabel *payTimeLB;
@property (nonatomic, strong) UILabel *deliverTimeLB;

@property (nonatomic, strong) UIButton *cpBtn;

@end

@implementation WeiMiOrderInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addSubview:self.orderCodeLB];
        [self addSubview:self.createTimeLB];
        [self addSubview:self.payTimeLB];
        [self addSubview:self.deliverTimeLB];
        [self addSubview:self.cpBtn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark -Getter
- (UIButton *)cpBtn
{
    if (!_cpBtn) {
        _cpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cpBtn setTitle:@"复制" forState:UIControlStateNormal];
        [_cpBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _cpBtn.titleLabel.font = WeiMiSystemFontWithpx(20);
        [_cpBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateNormal];
        [_cpBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateHighlighted];
    }
    return _cpBtn;
    
}

- (UILabel *)orderCodeLB
{
    if (!_orderCodeLB) {
        
        _orderCodeLB = [[UILabel alloc] init];
        _orderCodeLB.font = WeiMiSystemFontWithpx(20);
        _orderCodeLB.textAlignment = NSTextAlignmentLeft;
        _orderCodeLB.numberOfLines = 2;
        //        _priceLabel.textColor = kGrayColor;
        _orderCodeLB.text = @"订单编号：1616612361236123";
    }
    return _orderCodeLB;
}
- (UILabel *)createTimeLB
{
    if (!_createTimeLB) {
        
        _createTimeLB  = [[UILabel alloc] init];
        _createTimeLB.font = WeiMiSystemFontWithpx(20);
        _createTimeLB.textAlignment = NSTextAlignmentLeft;
        _createTimeLB.textColor = kGrayColor;
        _createTimeLB.numberOfLines = 2;
        _createTimeLB.text = @"创建时间：2016-6-6 09:57:55";
    }
    return _createTimeLB;
}

- (UILabel *)payTimeLB
{
    if (!_payTimeLB) {
        
        _payTimeLB = [[UILabel alloc] init];
        _payTimeLB.font = WeiMiSystemFontWithpx(20);
        _payTimeLB.textAlignment = NSTextAlignmentLeft;
        _payTimeLB.textColor = kGrayColor;
        _payTimeLB.numberOfLines = 2;
        _payTimeLB.text = @"付款时间：2016-6-6 09:57:55";
    }
    return _payTimeLB;
}

- (UILabel *)deliverTimeLB
{
    if (!_deliverTimeLB) {
        
        _deliverTimeLB = [[UILabel alloc] init];
        _deliverTimeLB.font = WeiMiSystemFontWithpx(20);
        _deliverTimeLB.textColor = kGrayColor;
        _deliverTimeLB.textAlignment = NSTextAlignmentLeft;
        _deliverTimeLB.text = @"发货时间：2016-6-6 09:57:55";
    }
    return _deliverTimeLB;
}

#pragma mark - Util



#pragma mark - Layout
- (void)updateConstraints
{
    [_orderCodeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(_cpBtn.mas_left).offset(-10);
    }];
    
    [_cpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_orderCodeLB);
        make.right.mas_equalTo(-10);
        make.width.mas_equalTo(70);
        make.height.mas_equalTo(25);
    }];
    
    [_createTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_orderCodeLB);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_payTimeLB.mas_top).offset(-5);
    }];
    
    [_payTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_orderCodeLB);
        make.right.mas_equalTo(_createTimeLB);
        make.bottom.mas_equalTo(_deliverTimeLB.mas_top).offset(-5);

    }];
    
    [_deliverTimeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_orderCodeLB);
        make.right.mas_equalTo(_createTimeLB);
        make.bottom.mas_equalTo(-10);
    }];
    
    
    [super updateConstraints];
}


@end
