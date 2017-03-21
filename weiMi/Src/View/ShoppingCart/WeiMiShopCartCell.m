//
//  WeiMiShopCartCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiShopCartCell.h"
#import <UIImageView+WebCache.h>

#define BTN_BORDER_COLOR    (0xCFCFCF)
@interface WeiMiShopCartCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIButton *plusBtn;
@property (nonatomic, strong) UILabel *numLabel;
@property (nonatomic, strong) UIButton *minusBtn;

@end

@implementation WeiMiShopCartCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _num = 1;
        [self.contentView addSubview:self.checkBoxBtn];
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.deleteBtn];
        [self.contentView addSubview:self.minusBtn];
        [self.contentView addSubview:self.numLabel];
        [self.contentView addSubview:self.plusBtn];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiShoppingCartDTO *)dto
{
    _dto = dto;
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.title;
    _subTitleLabel.text = dto.subTitle;
    _priceLabel.text = [NSString stringWithFormat:@"¥%.2f", dto.price];
    _price = dto.price;
}

#pragma mark -Getter
- (UIButton *)minusBtn
{
    if (!_minusBtn) {
        _minusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_minusBtn setImage:[UIImage imageNamed:@"icon_less"] forState:UIControlStateNormal];
        [_minusBtn setImage:[UIImage imageNamed:@"icon_less"] forState:UIControlStateSelected];
        [_minusBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        _minusBtn.layer.masksToBounds = YES;
        _minusBtn.layer.borderColor = HEX_RGB(BTN_BORDER_COLOR).CGColor;
        _minusBtn.layer.borderWidth = 1.0f;
    }
    return _minusBtn;
}

- (UIButton *)plusBtn
{
    if (!_plusBtn) {
        _plusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_plusBtn setImage:[UIImage imageNamed:@"icon_more-1"] forState:UIControlStateNormal];
        [_plusBtn setImage:[UIImage imageNamed:@"icon_more-1"] forState:UIControlStateSelected];
        [_plusBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
        _plusBtn.layer.masksToBounds = YES;
        _plusBtn.layer.borderColor = HEX_RGB(BTN_BORDER_COLOR).CGColor;
        _plusBtn.layer.borderWidth = 1.0f;
    }
    return _plusBtn;
}

- (UILabel *)numLabel
{
    if (!_numLabel) {
        
        _numLabel = [[UILabel alloc] init];
        _numLabel.text = @"1";
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.layer.masksToBounds = YES;
        _numLabel.textAlignment = NSTextAlignmentCenter;
        _numLabel.layer.borderColor = HEX_RGB(BTN_BORDER_COLOR).CGColor;
        _numLabel.layer.borderWidth = 1.0f;
    }
    return _numLabel;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateNormal];
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_delete"] forState:UIControlStateSelected];
        [_deleteBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel  = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
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

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont systemFontOfSize:13];
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.textColor = kGrayColor;
        [_priceLabel sizeToFit];
        _priceLabel.text = @"￥99.01";
    }
    return _priceLabel;
}

- (UIButton *)checkBoxBtn
{
    if (!_checkBoxBtn) {
        _checkBoxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_checkBoxBtn setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        [_checkBoxBtn setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        [_checkBoxBtn setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
        [_checkBoxBtn addTarget:self action:@selector(onCellBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBoxBtn;
}

- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = [UIImage imageNamed:@"followus_bg480x800"];
    }
    return _cellImageView;
}

#pragma mark - Actions
- (void)onCellBtn:(UIButton *)button
{
    if (button == self.checkBoxBtn) {//勾选按钮
        button.selected = !button.selected;
        OnSeletedCheckBoxBlock block = self.onSeletedCheckBoxBlock;
        if (block) {
            block(button);
        }
    }else if (button == self.plusBtn) {
        NSInteger num = _numLabel.text.integerValue;
        _num = num + 1;
       _numLabel.text = [NSString stringWithFormat:@"%ld", num + 1];
        [self setNeedsLayout];
        OnPlusBlock block = self.onPlusBlock;
        if (block) {
            block(self.checkBoxBtn);
        }
    }else if (button == self.minusBtn)
    {
        NSInteger num = _numLabel.text.integerValue;
        if (num == 1) {
            _numLabel.text = @"1";
            _num = 1;
        }else{
            _numLabel.text = [NSString stringWithFormat:@"%ld", num - 1];
            _num = num - 1;
        }
        [self setNeedsLayout];
        OnMinusBlock block = self.onMinusBlock;
        if (block) {
            block(self.checkBoxBtn, num);
        }
    }else if (button == self.deleteBtn)
    {
        OnDeleteBlock block = self.onDeleteBlock;
        if (block) {
            block(self.checkBoxBtn);
        }
    }
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_checkBoxBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerY.mas_equalTo(self);
    }];
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(_checkBoxBtn.mas_right);
        make.height.mas_equalTo(_cellImageView.mas_width);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-15);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(_priceLabel.mas_left).offset(-10);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_titleLabel);
//        make.width.mas_greaterThanOrEqualTo(40);
    }];
    
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.baseline.mas_equalTo(_cellImageView.mas_bottom);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
//        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_minusBtn.mas_top).offset(-5);
    }];
    
    [_minusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.mas_equalTo(_titleLabel);
        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(35), GetAdapterHeight(35)));
        make.bottom.mas_equalTo(_cellImageView);
    }];
    
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(_minusBtn);
        make.left.mas_equalTo(_minusBtn.mas_right).offset(-1);
        make.width.mas_greaterThanOrEqualTo(_plusBtn);
    }];
    
    [_plusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.mas_equalTo(_numLabel);
        make.left.mas_equalTo(_numLabel.mas_right).offset(-1);
        make.size.mas_equalTo(_minusBtn);

    }];
    [super updateConstraints];
}

@end
