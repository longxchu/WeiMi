//
//  WeiMiWhisperInviteCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWhisperInviteCell.h"
#import <UIImageView+WebCache.h>
#import "UIButton+CenterImageAndTitle.h"
@interface WeiMiWhisperInviteCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *careButton;

@end

@implementation WeiMiWhisperInviteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.careButton];
        
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}
- (void)setViewWithDTO:(WeiMiMaleFemaleRQDTO *)dto
{
    _titleLabel.text = dto.qtTitle;
    _subTitleLabel.text = dto.createTime;
    [_careButton setTitle:[NSString stringWithFormat:@"%ld", (long)dto.yuedu] forState:UIControlStateNormal];
    [_careButton sizeToFit];
}

#pragma mark - Setter
//- (void)setViewWithDTO:(WeiMiCircleRecomDTO *)dto
//{
//    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:[UIImage imageNamed:@"followus_bg480x800"]];
//    _titleLabel.text = dto.title;
//    _subTitleLabel.text = dto.subTitle;
//    _timeLabel.text = dto.time;
//    [_titleLabel sizeToFit];
//}

#pragma mark - Getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"女生悄悄话";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _subTitleLabel.text = @"还没有人回答该问题";
        
    }
    return _subTitleLabel;
}


- (UIButton *)careButton
{
    if (!_careButton) {
        
        _careButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _careButton.titleLabel.font = WeiMiSystemFontWithpx(20);
        [_careButton setTitle:@"32" forState:UIControlStateNormal];
//        [_careButton setTitle:@"取消" forState:UIControlStateSelected];
        [_careButton setTitleColor:kBlackColor forState:UIControlStateNormal];
//        [_careButton setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_careButton setImage:[UIImage imageNamed:@"wisper_icon_vieww"] forState:UIControlStateNormal];
//        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateSelected];
        [_careButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_careButton sizeToFit];
        [_careButton horizontalCenterImageAndTitle];
    }
    return _careButton;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    button.selected = !button.selected;
}

#pragma mark - Layout
-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)updateConstraints
{

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        //        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.mas_centerY);
    }];
    
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.width.mas_equalTo(_careButton.mas_height).multipliedBy(2.08f);
//        make.height.mas_equalTo(20);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_subTitleLabel);
    }];
    [super updateConstraints];
}


@end
