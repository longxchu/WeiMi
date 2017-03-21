//
//  WeiMiHotMoudleItem.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHotMoudleCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiHotMoudleCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end
@implementation WeiMiHotMoudleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiHotCommandDTO *)dto
{
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.imgPath)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
    _titleLabel.text = dto.infoTitle;
    _subTitleLabel.text = dto.createTime;
}

#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = WEIMI_PLACEHOLDER_COMMON;
    }
    return _cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15];
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
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:12.0f];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _subTitleLabel.text = @"呵呵哒健生馆";
    }
    return _subTitleLabel;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [super updateConstraints];
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(5);
        make.top.mas_equalTo(7);
        make.bottom.mas_equalTo(-7);
        make.width.mas_equalTo(_cellImageView.mas_height).multipliedBy(1.34);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_cellImageView);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_cellImageView);
    }];
}


@end
