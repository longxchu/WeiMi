//
//  WeiMiCircleMouleCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleMouleCell.h"
#import <UIImageView+WebCache.h>

@interface WeiMiCircleMouleCell()
{
    WeiMiCircleCateListDTO *_dto;
}





@end

@implementation WeiMiCircleMouleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.careButton];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.timeLabel];

        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}
#pragma mark - Setter
- (void)setViewWithDTO:(WeiMiCircleCateListDTO *)dto
{
    if ([_dto isEqualToDto:dto]) {
        return;
    }
    _dto = dto;
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.ringIcon)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.ringTitle;
    _subTitleLabel.text = dto.dzscription;
//    _timeLabel.text = safeObjectAtIndex([dto.createTime splitBy:@" "], 0);
    
    _careButton.selected = [dto.isShou boolValue];
    [_titleLabel sizeToFit];
}

#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = WEIMI_PLACEHOLDER_RECT;
        _cellImageView.layer.masksToBounds = YES;
    }
    return _cellImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
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
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _subTitleLabel.text = @"女生专属,聊一切女生想聊的话题";
    }
    return _subTitleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _timeLabel.text = @"今日:807";
    }
    return _timeLabel;
}

- (UIButton *)careButton
{
    if (!_careButton) {
        
        _careButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _careButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_careButton setTitle:@"关注" forState:UIControlStateNormal];
        [_careButton setTitle:@"取消" forState:UIControlStateSelected];
        [_careButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_careButton setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateSelected];
        [_careButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _careButton;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
//    button.selected = !button.selected;
    
    OnCareBtnHandler block = self.onCareBtnHandler;
    if (block) {
        block(button, _dto.ringId);
    }
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
//        make.width.mas_equalTo(_cellImageView.mas_height);
//        make.height.mas_equalTo(self.contentView).multipliedBy(2/3);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
//        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_cellImageView);
    }];
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(_careButton.mas_height).multipliedBy(2.08f);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(_careButton.mas_left).offset(-10);
        make.bottom.mas_equalTo(_cellImageView);
    }];

    
//    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(_titleLabel.mas_right).offset(5);
//        make.top.mas_equalTo(_titleLabel);
//        make.right.mas_lessThanOrEqualTo(_careButton.mas_left).offset(-10);
////        make.width.mas_greaterThanOrEqualTo(44);
//        make.centerY.mas_equalTo(_titleLabel);
//    }];
    
    [super updateConstraints];
}


@end

@interface WeiMiCircleInfoV() {
    WeiMiCircleCateListDTO *_dto;
}
@end

@implementation WeiMiCircleInfoV

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.careButton];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.timeLabel];
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}
#pragma mark - Setter
- (void)setViewWithDTO:(WeiMiCircleCateListDTO *)dto {
    if ([_dto isEqualToDto:dto]) {
        return;
    }
    _dto = dto;
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.ringIcon)] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.ringTitle;
    _subTitleLabel.text = dto.dzscription;
    //    _timeLabel.text = safeObjectAtIndex([dto.createTime splitBy:@" "], 0);
    
    _careButton.selected = [dto.isShou boolValue];
    [_titleLabel sizeToFit];
}
#pragma mark - Getter
- (UIImageView *)cellImageView {
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.image = WEIMI_PLACEHOLDER_RECT;
        _cellImageView.layer.masksToBounds = YES;
    }
    return _cellImageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"闺蜜私房话";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _subTitleLabel.text = @"女生专属,聊一切女生想聊的话题";
    }
    return _subTitleLabel;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _timeLabel.text = @"今日:807";
    }
    return _timeLabel;
}
- (UIButton *)careButton {
    if (!_careButton) {
        _careButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _careButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_careButton setTitle:@"关注" forState:UIControlStateNormal];
        [_careButton setTitle:@"取消" forState:UIControlStateSelected];
        [_careButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_careButton setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateSelected];
        [_careButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _careButton;
}
#pragma mark - Actions
- (void)onButton:(UIButton *)button {
    //    button.selected = !button.selected;
    OnCareBtnHandler block = self.onCareBtnHandler;
    if (block) {
        block(button, _dto.ringId);
    }
}
#pragma mark - Layout
-(void)layoutSubviews {
    [super layoutSubviews];
    self.cellImageView.layer.cornerRadius = self.cellImageView.width/2;
}

- (void)updateConstraints {
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(self);
        //        make.width.mas_equalTo(_cellImageView.mas_height);
        //        make.height.mas_equalTo(self.contentView).multipliedBy(2/3);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        //        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(_cellImageView);
    }];
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(_careButton.mas_height).multipliedBy(2.08f);
        make.height.mas_equalTo(20);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.right.mas_equalTo(_careButton.mas_left).offset(-10);
        make.bottom.mas_equalTo(_cellImageView);
    }];
    [super updateConstraints];
}

@end
