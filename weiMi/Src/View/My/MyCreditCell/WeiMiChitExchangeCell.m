//
//  WeiMiChitExchangeCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiChitExchangeCell.h"
#import <UIButton+WebCache.h>

#define kTextColor  (0x4ECDC7)
@interface WeiMiChitExchangeCell()



@end

@implementation WeiMiChitExchangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.rightLabel];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

//- (void)setViewWithDTO:(WeiMiCreditExchangeDTO *)dto
//{
//    [_cellImageView setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:[UIImage imageNamed:@"followus_bg480x800"]];
//    _titleLabel.text = dto.title;
//    _subTitleLabel.text = dto.subTitle;
//}

#pragma mark - Getter
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(24)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"他趣5元代金券";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(kTextColor);
        _subTitleLabel.attributedText = [self attrStringWithSuff:@"20"];
    }
    return _subTitleLabel;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = kGrayColor;
        _rightLabel.text = @"抢兑中";
        [_rightLabel sizeToFit];
    }
    return _rightLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)attrStringWithSuff:(NSString *)suff
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:suff attributes:@{
                                                                                                               NSFontAttributeName:WeiMiSystemFontWithpx(34), NSForegroundColorAttributeName:HEX_RGB(0xAC5BA)}];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" 趣币"] attributes:@{
                                                                                                                          NSFontAttributeName:WeiMiSystemFontWithpx(22), NSForegroundColorAttributeName:HEX_RGB(0xAC5BA)}];
    
    [attString appendAttributedString:sufStr];
    return attString;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [super updateConstraints];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_rightLabel.mas_left).offset(-20);
        make.top.mas_equalTo(10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(-10);
    }];

}


@end
