//
//  WeiMiShopBottomBar.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiShopBottomBar.h"
#import "UIButton+CenterImageAndTitle.h"

@interface WeiMiShopBottomBar()

@property (nonatomic, strong) UIButton *checkBoxBtn;
@property (nonatomic, strong) UILabel *totalFeeLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UIButton *accountsButton;

@end

@implementation WeiMiShopBottomBar

- (instancetype)init
{
    if (self = [super init]) {
        [self addSubview:self.checkBoxBtn];
        [self addSubview:self.totalFeeLabel];
        [self addSubview:self.typeLabel];
        [self addSubview:self.accountsButton];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithPrice:(double)price num:(NSUInteger)num
{
     [_accountsButton setTitle:[NSString stringWithFormat:@"结算(%ld)", num] forState:UIControlStateNormal];
    _totalFeeLabel.attributedText = [self attrStringWithSuff:price];
}

#pragma mark - Getter
- (UIButton *)checkBoxBtn
{
    if (!_checkBoxBtn) {
        _checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBoxBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(21)];
        [_checkBoxBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_checkBoxBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        [_checkBoxBtn setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        [_checkBoxBtn setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(onCheckBox:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    return _checkBoxBtn;
}

- (UILabel *)totalFeeLabel
{
    if (!_totalFeeLabel) {
        
        _totalFeeLabel = [[UILabel alloc] init];
        _totalFeeLabel.font = [UIFont systemFontOfSize:14];
        _totalFeeLabel.textAlignment = NSTextAlignmentRight;
        _totalFeeLabel.attributedText = [self attrStringWithSuff:0];
    }
    return _totalFeeLabel;
}

- (NSMutableAttributedString *)attrStringWithSuff:(double)suff
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"合计 " attributes:@{
                                                                                                                 NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeWithpx(20)], NSForegroundColorAttributeName:HEX_RGB(BASE_TEXT_COLOR)}];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f", suff] attributes:@{
                                                                                               NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeWithpx(20)], NSForegroundColorAttributeName:HEX_RGB(0xF25008)}];
    [attString appendAttributedString:sufStr];
    return attString;
}

- (UILabel *)typeLabel
{
    if (!_typeLabel) {
        
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(19)];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.textColor = kGrayColor;
        [_typeLabel sizeToFit];
        _typeLabel.text = @"不含运费";
    }
    return _typeLabel;
}

- (UIButton *)accountsButton
{
    if (!_accountsButton) {
        _accountsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_accountsButton setTitle:@"结算(0)" forState:UIControlStateNormal];
        [_accountsButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _accountsButton.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(21)];
//        [_accountsButton addTarget:self action:@selector(onCheckBox) forControlEvents:UIControlEventTouchUpInside];
        _accountsButton.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
    }
    return _accountsButton;
}

#pragma mark - Actions
- (void)onCheckBox:(UIButton *)button
{
    button.selected = !button.selected;
    
    OnSelectAll block = self.onSelectAll;
    if (block) {
        block();
    }
}

#pragma mark - Layout
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.checkBoxBtn horizontalCenterImageAndTitle];
}

- (void)reLayoutLabelWithStat:(SHOPBOTTOMSTATUS)status
{
    switch (status) {
        case SHOPBOTTOMSTATUS_UPSIDE:
        {
            [_totalFeeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(5);
                make.right.mas_equalTo(_accountsButton.mas_left).offset(-5);
            }];
            
            [_typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(_totalFeeLabel.mas_bottom);
                make.bottom.mas_equalTo(-5);
                make.right.mas_equalTo(_totalFeeLabel);
            }];
            
            [self setNeedsLayout];
            [self layoutIfNeeded];

        }
            break;
        case SHOPBOTTOMSTATUS_LEFTSIDE:
        {
            [self updateConstraints];
            [self setNeedsLayout];
            [self layoutIfNeeded];
        }
            
        default:
            break;
    }
    
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [@[_checkBoxBtn,_accountsButton] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
    }];
    
    [_checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(70);
        
    }];
    
    [_accountsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(85);
    }];
    
    [_typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(_accountsButton.mas_left).offset(-5);
    }];
    
    [_totalFeeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(_typeLabel.mas_left).offset(0);
        make.left.mas_equalTo(_checkBoxBtn.mas_right).offset(5);
    }];
}

@end
