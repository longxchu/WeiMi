//
//  WeiMiCreditShopCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditShopCell.h"
#import "UIButton+CenterImageAndTitle.h"

#define BUTTON_BORD_COLOR       (0xED672B)
@interface WeiMiCreditShopCell()


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UIButton *creditBtn;
@property (nonatomic, strong) UIButton *medalBtn;


@end

@implementation WeiMiCreditShopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.clickedBtn];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.rewardLabel];
        [self.contentView addSubview:self.creditBtn];
//        [self.contentView addSubview:self.medalBtn];
        [self.contentView addSubview:self.getRewardBtn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiCreditTaskDTO *)dto
{
    _titleLabel.text = dto.baseName;
    [_creditBtn setTitle:dto.baseValue forState:UIControlStateNormal];
//    [_medalBtn setTitle:dto.metalNum forState:UIControlStateNormal];
//    [_creditBtn setTitle:dto.creditNum forState:UIControlStateSelected];
//    [_medalBtn setTitle:dto.metalNum forState:UIControlStateSelected];
    
//    _getRewardBtn.selected = !dto.finished;
    
    if (_getRewardBtn.selected) {
        _getRewardBtn.layer.borderColor = kGrayColor.CGColor;
    }else
    {
        _getRewardBtn.layer.borderColor = HEX_RGB(BUTTON_BORD_COLOR).CGColor;
    }
//    if (dto.finished) {
//        _getRewardBtn.userInteractionEnabled = NO;
//    }
}

#pragma mark - Setter
- (void)setClickBtnOn:(BOOL)clickBtnOn
{
    _clickBtnOn = clickBtnOn;
    _clickedBtn.selected = clickBtnOn;
}


- (UIButton *)clickedBtn
{
    if (!_clickedBtn) {
        
        _clickedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clickedBtn setBackgroundImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        [_clickedBtn setBackgroundImage:[UIImage imageNamed:@"red_circle"] forState:UIControlStateSelected];
        [_clickedBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickedBtn;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.text = @"注册账号";
    }
    return _titleLabel;
}

- (UILabel *)rewardLabel
{
    if (!_rewardLabel) {
        _rewardLabel = [[UILabel alloc] init];
        _rewardLabel.font = [UIFont systemFontOfSize:14];
        _rewardLabel.textColor = kGrayColor;
        _rewardLabel.text = @"奖励:";
    }
    return _rewardLabel;
}

- (UIButton *)creditBtn
{
    if (!_creditBtn) {
        _creditBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_creditBtn setTitle:@"20" forState:UIControlStateNormal];
        [_creditBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _creditBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_creditBtn setImage:[UIImage imageNamed:@"icon_jifen_gray"] forState:UIControlStateNormal];
        [_creditBtn setImage:[UIImage imageNamed:@"icon_jifen_gray"] forState:UIControlStateHighlighted];
    }
    return _creditBtn;
}

- (UIButton *)medalBtn
{
    if (!_medalBtn) {
        _medalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_medalBtn setTitle:@"20" forState:UIControlStateNormal];
        [_medalBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _medalBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_medalBtn setImage:[UIImage imageNamed:@"icon_dengji"] forState:UIControlStateNormal];
        [_medalBtn setImage:[UIImage imageNamed:@"icon_dengji"] forState:UIControlStateHighlighted];
    }
    return _medalBtn;
}

- (UIButton *)getRewardBtn
{
    if (!_getRewardBtn) {
        _getRewardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getRewardBtn setTitle:@"领取奖励" forState:UIControlStateNormal];
        [_getRewardBtn setTitleColor:HEX_RGB(BUTTON_BORD_COLOR) forState:UIControlStateNormal];
        [_getRewardBtn setTitle:@"去完成" forState:UIControlStateSelected];
        [_getRewardBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
        _getRewardBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_getRewardBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        _getRewardBtn.layer.borderColor = HEX_RGB(BUTTON_BORD_COLOR).CGColor;
        _getRewardBtn.layer.borderWidth = 1.0f;
        _getRewardBtn.layer.masksToBounds = YES;
        _getRewardBtn.layer.cornerRadius = 3.0f;
        

    }
    return _getRewardBtn;
}
#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        button.layer.borderColor = kGrayColor.CGColor;
    }else
    {
        button.layer.borderColor = HEX_RGB(BUTTON_BORD_COLOR).CGColor;
    }
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    [_creditBtn horizontalCenterImageAndTitle];
//    [_medalBtn horizontalCenterImageAndTitle];
}

- (void)updateConstraints
{
    [_clickedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(self.mas_centerY).offset(-5);
        make.left.mas_equalTo(_clickedBtn.mas_right).offset(10);
    }];
    
    [_rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(self.mas_centerY).offset(5);
        make.width.mas_equalTo(40);
    }];
    
    [_creditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_rewardLabel.mas_right);
        make.centerY.mas_equalTo(_rewardLabel);
    }];
    
//    [_medalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(_creditBtn.mas_right).offset(10);
//        make.centerY.mas_equalTo(_creditBtn);
//    }];
    
    [_getRewardBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-20);
        
        make.height.mas_equalTo(35);
        make.width.mas_equalTo([@"领取奖励" returnSize:_getRewardBtn.titleLabel.font].width + 10);
    }];
    [super updateConstraints];
}

@end
