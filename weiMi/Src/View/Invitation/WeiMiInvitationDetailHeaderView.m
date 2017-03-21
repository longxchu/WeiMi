//
//  WeiMiInvitationDetailHeaderView.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiInvitationDetailHeaderView.h"

#import "UIImageView+WebCache.h"

@interface WeiMiInvitationDetailHeaderView()




@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *levelLB;
@property (nonatomic, strong) UILabel *tagLB;

@end

@implementation WeiMiInvitationDetailHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.levelLB];
        [self addSubview:self.tagLB];

        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.layer.masksToBounds = YES;
//        [_cellImageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
        UIImage *image = [UIImage imageNamed:@"logo"];
        _cellImageView.image = image;
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
        _titleLabel.text = @"活动管理员";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

//- (UILabel *)timeLabel
//{
//    if (!_timeLabel) {
//        
//        _timeLabel = [[UILabel alloc] init];
//        _timeLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
//        _timeLabel.textAlignment = NSTextAlignmentLeft;
//        _timeLabel.textColor = kGrayColor;
//        _timeLabel.numberOfLines = 1;
//        _timeLabel.text = @"1998-02-01";
//        [_timeLabel sizeToFit];
//    }
//    return _timeLabel;
//}

//- (UILabel *)tagLB
//    if (!_tagLB) {
//        
//        _tagLB = [[UILabel alloc] init];
//        _tagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
//        _tagLB.textAlignment = NSTextAlignmentCenter;
//        _tagLB.textColor = kWhiteColor;
//        _tagLB.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
//        _tagLB.text = @"楼主";
//    }
//    return _tagLB;
//}

//- (UILabel *)levelLB
//{
//    if (!_levelLB) {
//        
//        _levelLB = [[UILabel alloc] init];
//        _levelLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
//        _levelLB.textAlignment = NSTextAlignmentCenter;
//        _levelLB.textColor = kWhiteColor;
//        _levelLB.backgroundColor = HEX_RGB(0x5ECBCF);
//        _levelLB.text = @"lv5";
//    }
//    return _levelLB;
//}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    
}

#pragma mark - Layout
- (void)layoutSubviews
{
    [super layoutSubviews];
    _cellImageView.layer.cornerRadius = _cellImageView.width/2;
    
}

- (void)updateConstraints
{
    [super updateConstraints];
    
    
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(self).multipliedBy(0.81);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(15);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.bottom.mas_equalTo(_cellImageView);
    }];
    
    [_levelLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_titleLabel);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(15);
//        make.height.mas_equalTo(_commentBTN).offset(-5);
        make.width.mas_equalTo(_levelLB.mas_height).multipliedBy(2);
    }];
    
    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_titleLabel);
        make.left.mas_equalTo(_levelLB.mas_right).offset(15);
        make.width.mas_equalTo(_tagLB.mas_height).multipliedBy(2);

    }];
    
}


@end
