//
//  WeiMiCreditExchangeCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditExchangeCell.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>

#define kTextColor  (0x4ECDC7)
@interface WeiMiCreditExchangeCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *exchangeBTN;

@end

@implementation WeiMiCreditExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.exchangeBTN];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiCreditExchangeDTO *)dto
{
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.title;
    _subTitleLabel.text = [NSString stringWithFormat:@"%@积分", dto.vouPrice];
    
}

- (void)setViewWithCreditDTO:(WeiMiMyCreditDTO *)dto
{
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.title;
    _subTitleLabel.text = [NSString stringWithFormat:@"%@积分", dto.vouPrice];
    self.exchangeBTN.hidden = YES;
}

#pragma mark - Getter
- (UIButton *)exchangeBTN
{
    if (!_exchangeBTN) {
        
        _exchangeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeBTN sizeToFit];
        [_exchangeBTN setTitle:@" 兑换 " forState:UIControlStateNormal];
        [_exchangeBTN setTitleColor:HEX_RGB(kTextColor) forState:UIControlStateNormal];
        _exchangeBTN.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSizeWithpx(20)];
        [_exchangeBTN setBackgroundImage:[UIImage imageNamed:@"blue_rectangle"] forState:UIControlStateNormal];
        [_exchangeBTN setImage:[UIImage imageNamed:@"blue_rectangle"] forState:UIControlStateHighlighted];
        [_exchangeBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBTN;
}

- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = [UIImage imageNamed:@"followus_bg480x800"];
    }
    return _cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(kTextColor);
        _subTitleLabel.text = @"呵呵哒健生馆";
    }
    return _subTitleLabel;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    OnButtonHandler block = self.onButtonHandler;
    if (block) {
//        UPRouterOptions *options = [UPRouterOptions routerOptions];
//        options.hidesBottomBarWhenPushed = YES;
//        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiExchangeVC" options:options];
        block();
    }
}

#pragma mark - Layout
- (void)updateConstraints
{
    [super updateConstraints];
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(_cellImageView.mas_height).multipliedBy(1.34);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(_exchangeBTN.mas_left).offset(-10);
        make.top.mas_equalTo(_cellImageView).offset(10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(_cellImageView).offset(-10);
    }];
    
    [_exchangeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-12);
        make.width.mas_equalTo(60);
    }];
}


@end
