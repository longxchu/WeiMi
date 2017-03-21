//
//  WeiMiCircleOnlineDetailCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleOnlineDetailCell.h"
#import <UIImageView+WebCache.h>
#import "UIButton+CenterImageAndTitle.h"

@interface WeiMiCircleOnlineDetailCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *careButton;

@end


@implementation WeiMiCircleOnlineDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.careButton];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Setter


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
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(21)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"闺蜜私房话";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _subTitleLabel.textAlignment = NSTextAlignmentRight;
        _subTitleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _subTitleLabel.text = @"浏览帖子";
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = kGrayColor;
        _timeLabel.text = @"今日:807";
    }
    return _timeLabel;
}

- (UIButton *)careButton
{
    if (!_careButton) {
        
        _careButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _careButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_careButton setTitle:@"也许来自火星" forState:UIControlStateNormal];
        [_careButton setTitleColor:kGrayColor forState:UIControlStateNormal];
        [_careButton setImage:[UIImage imageNamed:@"icon_jifen_gray"] forState:UIControlStateNormal];
        [_careButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_careButton horizontalCenterImageAndTitle];
        [_careButton sizeToFit];
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
        make.height.mas_equalTo(self.contentView).multipliedBy(0.69);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        //        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_cellImageView);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(_cellImageView);
    }];
    
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel.mas_right).offset(5);
        make.top.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(-10);
        //        make.width.mas_greaterThanOrEqualTo(44);
        make.centerY.mas_equalTo(_titleLabel);
    }];
    
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(_timeLabel.mas_left);
        make.bottom.mas_equalTo(_subTitleLabel);
    }];
    [super updateConstraints];
}


@end
