//
//  WeiMiMyOrderCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyOrderCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiMyOrderCell()
{
    NSUInteger _tradeStatus;
}

@property (nonatomic, strong) UILabel *statusLabel;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *offPriceLabel;
@property (nonatomic, strong) UILabel *numLaebl;

@property (nonatomic, strong) UILabel *priceInfoLabel;

@property (nonatomic, strong) UIView *bottomBGView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation WeiMiMyOrderCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _tradeStatus = 1;
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.statusLabel];
        
        [self.bgView addSubview:self.cellImageView];
        [self.bgView addSubview:self.titleLabel];
        [self.bgView addSubview:self.subTitleLabel];
        [self.bgView addSubview:self.priceLabel];
        [self.bgView addSubview:self.offPriceLabel];
        [self.bgView addSubview:self.numLaebl];
        
        [self.contentView addSubview:self.priceInfoLabel];
        
        [self.contentView addSubview:self.bottomBGView];
        [self.bottomBGView addSubview:self.leftBtn];
        [self.bottomBGView addSubview:self.rightBtn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - GETTER
- (TRADESTATUS)tradeStatus
{
//    return _tradeStatus;
    switch (_tradeStatus) {
        case 0:
            return TRADESTATUS_UNPAY;
            break;
        case 1:
            return TRADESTATUS_DEALSUCEESS;
            break;
        case 2:
            return TRADESTATUS_UNREC;
            break;
        default:
            return TRADESTATUS_UNPAY;
            break;
    }
}

#pragma mark - Setter
- (void)setViewWithDTO:(WeiMiOrderDTO *)dto
{
    _tradeStatus = dto.tradeStatus;
    switch (dto.tradeStatus) {
        case 0:
        {
            _statusLabel.text = @"等待买家付款";
                    [_leftBtn setHidden:NO];
            [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];

        }
            break;
        case 1:
            _statusLabel.text = @"交易成功";
                        [_leftBtn setHidden:NO];
            [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [_rightBtn setTitle:@"评价" forState:UIControlStateNormal];
            break;
        case 2:
        {
            _statusLabel.text = @"待收货";
            [_leftBtn setHidden:YES];
            [_rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.title;
    _titleLabel.text = dto.subTitle;
    _priceLabel.text = [NSString stringWithFormat:@"%.2lf", dto.price];
    _offPriceLabel.attributedText = [self configOffPrice:[NSString stringWithFormat:@"%.2lf", dto.offPrice]];
    _numLaebl.text = [NSString stringWithFormat:@"x%lu", (unsigned long)dto.buyNum];
    _priceInfoLabel.attributedText = [self configPriceInfo:[NSString stringWithFormat:@"%lu", (unsigned long)dto.buyNum] totalPrice:[NSString stringWithFormat:@"%.2lf", dto.totalPrice] transportFee:[NSString stringWithFormat:@"%.2lf", dto.transportFee]];
}

#pragma mark - Getter
- (UIView *)bottomBGView
{
    if (!_bottomBGView) {
        _bottomBGView = [[UIView alloc] init];
        _bottomBGView.backgroundColor = kWhiteColor;
    }
    return _bottomBGView;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
//        [_leftBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"purple_border_btn"] forState:UIControlStateNormal];
//        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitle:@"评价" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
//        [_rightBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"purple_border_btn"] forState:UIControlStateNormal];
//        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (UILabel *)statusLabel
{
    if (!_statusLabel) {
        
        _statusLabel  = [[UILabel alloc] init];
        _statusLabel.backgroundColor = kWhiteColor;
        _statusLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _statusLabel.textAlignment = NSTextAlignmentRight;
        _statusLabel.textColor = HEX_RGB(BASE_COLOR_HEX);
        _statusLabel.numberOfLines = 0;
        _statusLabel.text = @"待付款";
    }
    return _statusLabel;
}

- (UILabel *)priceInfoLabel
{
    if (!_priceInfoLabel) {
        
        _priceInfoLabel  = [[UILabel alloc] init];
        _priceInfoLabel.backgroundColor = kWhiteColor;
        _priceInfoLabel.font = [UIFont systemFontOfSize:14];
        _priceInfoLabel.textAlignment = NSTextAlignmentRight;
//        _priceInfoLabel.textColor = HEX_RGB(BASE_COLOR_HEX);
        _priceInfoLabel.numberOfLines = 0;

        _priceInfoLabel.attributedText = [self configPriceInfo:@"3" totalPrice:@"22.90" transportFee:@"0.00"];

    }
    return _priceInfoLabel;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = HEX_RGB(0xF5F5F5);
    }
    return _bgView;
}

- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
//        _cellImageView.image = [UIImage imageNamed:@"followus_bg480x800"];
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
    }
    return _offPriceLabel;
}

- (UILabel *)numLaebl
{
    if (!_numLaebl) {
        
        _numLaebl = [[UILabel alloc] init];
        _numLaebl.font = [UIFont systemFontOfSize:14];
        _numLaebl.textAlignment = NSTextAlignmentRight;
        _numLaebl.textColor = kGrayColor;
        _numLaebl.text = @"x3";
    }
    return _numLaebl;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:14];
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
        _subTitleLabel.font = [UIFont systemFontOfSize:14];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = kGrayColor;
        _subTitleLabel.numberOfLines = 2;
        _subTitleLabel.text = @"规格:白色睡裙M码";
    }
    return _subTitleLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
    }
    return _titleLabel;
}

#pragma mark  - Actions
- (void)onButton:(UIButton *)button
{
    button.selected  = !button.selected;
    if (button == _leftBtn) {

        OnLeftHandler block = self.onLeftHandler;
        if (block) {
            block();
        }
    }else if (button == _rightBtn)
    {
        OnRightHandler block = self.onRightHandler;
        if (block) {
            block();
        }
    }
}

#pragma mark - Util
- (NSMutableAttributedString *)configOffPrice:(NSString *)str
{
    return [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle)}];
}

- (NSMutableAttributedString *)configPriceInfo:(NSString *)goodNum totalPrice:(NSString *)price transportFee:(NSString *)fee
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"共%@件商品 合计:¥", goodNum] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    
    [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", price] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}]];
    NSMutableAttributedString *sufferStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"(含运费¥%@)", fee] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    [attStr appendAttributedString:sufferStr];
    
    return attStr;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(35);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_statusLabel.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
    }];
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self.bgView);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(_cellImageView.mas_width);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(_priceLabel.mas_left).offset(-10);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_titleLabel);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_offPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_priceLabel.mas_bottom).offset(5);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_numLaebl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_offPriceLabel.mas_bottom).offset(5);
        make.width.mas_greaterThanOrEqualTo(50);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
    }];
    

    [_priceInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(_bgView.mas_bottom);
    }];
    
    [_bottomBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_priceInfoLabel.mas_bottom);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_bottomBGView);
        make.size.mas_equalTo(CGSizeMake(70, 25));
        make.right.mas_equalTo(-15);
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_bottomBGView);
        make.size.mas_equalTo(CGSizeMake(70, 25));
        make.right.mas_equalTo(_rightBtn.mas_left).offset(-10);
    }];
    [super updateConstraints];
}

@end
