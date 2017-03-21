//
//  WeiMiTryOutGroundCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryOutGroundCell.h"
#import <UIImageView+WebCache.h>
#import <OHAttributedStringAdditions.h>
#import "UIImage+WeiMiUIImage.h"
@interface WeiMiTryOutGroundCell()
{
    WeiMiTryoutGroundDTO *_dto;
}

@property (nonatomic, strong) UIImageView *headerImageView;

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end

@implementation WeiMiTryOutGroundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headerImageView];
        
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.detailLabel];
        [self.contentView addSubview:self.subTitleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiTryoutGroundDTO *)dto
{
    if ([dto isEqualToDto:_dto]) {
        return;
    }
    _dto = dto;
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.headImgPath)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.applyImg)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.memberName;
    _detailLabel.text = dto.title;
    _subTitleLabel.text = dto.createTime;
}

#pragma mark - Getter
- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = WEIMI_PLACEHOLDER_RECT;
        _headerImageView.layer.masksToBounds = YES;
    }
    return _headerImageView;
}

- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = WEIMI_PLACEHOLDER_RECT;
    }
    return _cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = WeiMiSystemFontWithpx(20);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = kGrayColor;
        _titleLabel.numberOfLines = 2;
        _titleLabel.text = @"test";
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.font = WeiMiSystemFontWithpx(22);
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
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = kGrayColor;
        _subTitleLabel.text = @"2016-08-17";
    }
    return _subTitleLabel;
}

#pragma mark - Util
- (NSString *)strWithPeriod:(NSString *)period joinMember:(NSUInteger)joinMember
{
    return [NSString stringWithFormat:@"活动时间：%@   已有%ld人参加", period, (long)joinMember];
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    _headerImageView.layer.cornerRadius = _headerImageView.width/2;
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(10);
        make.height.mas_equalTo(self).multipliedBy(0.25);
        make.width.mas_equalTo(_headerImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_headerImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_headerImageView);
    }];
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_headerImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(self).multipliedBy(0.5);
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(-10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_detailLabel);
        make.bottom.mas_equalTo(_cellImageView);
    }];
}

@end
