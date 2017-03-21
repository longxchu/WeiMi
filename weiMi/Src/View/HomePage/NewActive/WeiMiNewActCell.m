//
//  WeiMiNewActCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewActCell.h"
#import <UIImageView+WebCache.h>
#import <OHAttributedStringAdditions.h>
@interface WeiMiNewActCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation WeiMiNewActCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.subTitleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiNewestActDTO *)dto
{
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.imgURL)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.title;
    _detailLabel.text = dto.detailTitle;
    _subTitleLabel.text = [self strWithPeriod:dto.activityPeriod joinMember:dto.joinMember];
}

#pragma mark - Getter
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
        _titleLabel.font = WeiMiSystemFontWithpx(22);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = WeiMiSystemFontWithpx(18);
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _detailLabel.numberOfLines = 2;
        _detailLabel.text = @"[买1送六][包邮]害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花害得娜娜 小清新和果子樱花";
    }
    return _detailLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(16)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = kGrayColor;
    }
    return _subTitleLabel;
}

#pragma mark - Util
- (NSString *)strWithPeriod:(NSString *)period joinMember:(NSUInteger)joinMember
{
    return [NSString stringWithFormat:@"活动时间：%@   已有%ld人参加", period, (long)joinMember];
}

#pragma mark - Layout
- (void)updateConstraints
{
    [super updateConstraints];
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(10);
        make.bottom.mas_equalTo(-10);
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_cellImageView).offset(5);
    }];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel.mas_left);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_cellImageView).offset(-5);
    }];
}


@end
