//
//  WeiMiLogisticsInfoCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLogisticsInfoCell.h"
#import "WeiMiHorizonMenuItem.h"
#import <OHAttributedStringAdditions.h>

@interface WeiMiLogisticsInfoCell()
{
    
}

@property (nonatomic, strong) WeiMiHorizonMenuItem *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *infoLabel;


@end

@implementation WeiMiLogisticsInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.infoLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark -Getter
- (WeiMiHorizonMenuItem *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[WeiMiHorizonMenuItem alloc] init];
    }
    return _cellImageView;
}


- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = kGrayColor;
        _infoLabel.text = @"信息来源: 申通快递";
    }
    return _infoLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel  = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = kGrayColor;
        _subTitleLabel.text = @"运单号: 23423423423423423";
    }
    return _subTitleLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.attributedText = [self configInfo:@"物流状态: 已签收"];
    }
    return _titleLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)configInfo:(NSString *)str
{
    NSMutableAttributedString *attStr =  [[NSMutableAttributedString alloc] initWithString:str attributes:@{
                                    NSFontAttributeName:WeiMiSystemFontWithpx(22)}];
    
    [attStr setTextColor:kRedColor range:[str rangeOfString:@"已签收"]];
    return attStr;
}


#pragma mark - Layout
- (void)updateConstraints
{
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(_cellImageView.mas_width);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(-10);
    }];
    
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_subTitleLabel);
    }];
    
    [super updateConstraints];
}
@end
