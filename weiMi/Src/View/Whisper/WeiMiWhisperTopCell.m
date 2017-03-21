//
//  WeiMiWhisperTopCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWhisperTopCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiWhisperTopCell()



@end

@implementation WeiMiWhisperTopCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.careButton];
        
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
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
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = [UIImage imageNamed:@"followus_bg480x800"];
        _cellImageView.layer.masksToBounds = YES;
    }
    return _cellImageView;
}

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
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _subTitleLabel.text = @"关注:15.7w  帖子12.3w";
    }
    return _subTitleLabel;
}


- (UIButton *)careButton
{
    if (!_careButton) {
        
        _careButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _careButton.titleLabel.font = [UIFont systemFontOfSize:14];
//        [_careButton setTitle:@"关注" forState:UIControlStateNormal];
//        [_careButton setTitle:@"取消" forState:UIControlStateSelected];
//        [_careButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
//        [_careButton setTitleColor:kGrayColor forState:UIControlStateSelected];
//        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
//        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateSelected];
        [_careButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
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
    self.cellImageView.layer.cornerRadius = self.cellImageView.width/2;
}

- (void)updateConstraints
{
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(_cellImageView.mas_height);
        make.height.mas_equalTo(self).multipliedBy(0.38f);
//        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        //        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_cellImageView.mas_centerY).offset(-5);
        make.right.mas_equalTo(_careButton.mas_left);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(_careButton.mas_left);
        make.top.mas_equalTo(_cellImageView.mas_centerY).offset(5);
    }];
    
    
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(_careButton.mas_height).multipliedBy(2.08f);
        make.height.mas_equalTo(20);
//        make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(5);
//        make.left.mas_equalTo(_subTitleLabel);
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(_cellImageView);
    }];
    [super updateConstraints];
}


@end
