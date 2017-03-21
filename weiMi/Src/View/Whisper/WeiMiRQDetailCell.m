//
//  WeiMiRQDetailCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQDetailCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+CenterImageAndTitle.h"
@interface WeiMiRQDetailCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *levelLB;
@property (nonatomic, strong) UILabel *tagLB;

@property (nonatomic, strong) UIButton *careButton;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end


@implementation WeiMiRQDetailCell

+ (CGFloat)getHeightWithDTO:(WeiMiMaleFemaleRQDTO *)dto
{
    static WeiMiRQDetailCell *testCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testCell = [[WeiMiRQDetailCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"testCell"];
    });
    
    [testCell setViewWithDTO:dto];
    
    [testCell setNeedsLayout];
    [testCell layoutIfNeeded];
    
    CGFloat height = 40+GetAdapterHeight(44);
    height += [dto.qtTitle returnSize:testCell.contentLabel.font MaxWidth:SCREEN_WIDTH - 20].height;
    height += [dto.qtContent returnSize:testCell.subTitleLabel.font MaxWidth:SCREEN_WIDTH - 20].height;
    
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.timeLabel];
        [self addSubview:self.levelLB];
        [self addSubview:self.tagLB];
        [self addSubview:self.careButton];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.subTitleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Setter
- (void)setViewWithDTO:(WeiMiMaleFemaleRQDTO *)dto;
{
//    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto] placeholderImage:WEIMI_PLACEHOLDER_RECT];
    _titleLabel.text = dto.memberName;
    _timeLabel.text = dto.createTime;
    _tagLB.text = @"无tag";
    _levelLB.text = [NSString stringWithFormat:@"lv%@", @"5"];
    _contentLabel.text = dto.qtContent;
    _subTitleLabel.text = dto.qtTitle;
    [_careButton setTitle:[NSString stringWithFormat:@"%ld", (long)dto.yuedu] forState:UIControlStateNormal];
    [_careButton sizeToFit];
}


#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.layer.masksToBounds = YES;
        _cellImageView.image = WEIMI_PLACEHOLDER_RECT;
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
        _titleLabel.text = @"小美女";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        _timeLabel.textAlignment = NSTextAlignmentLeft;
        _timeLabel.textColor = kGrayColor;
        _timeLabel.numberOfLines = 1;
        _timeLabel.text = @"1998-02-01";
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _tagLB.textAlignment = NSTextAlignmentCenter;
        _tagLB.textColor = kWhiteColor;
        _tagLB.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        _tagLB.text = @"楼主";
    }
    return _tagLB;
}

- (UILabel *)levelLB
{
    if (!_levelLB) {
        
        _levelLB = [[UILabel alloc] init];
        _levelLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _levelLB.textAlignment = NSTextAlignmentCenter;
        _levelLB.textColor = kWhiteColor;
        _levelLB.backgroundColor = HEX_RGB(0x5ECBCF);
        _levelLB.text = @"lv5";
    }
    return _levelLB;
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
//        [_careButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_careButton sizeToFit];
        [_careButton horizontalCenterImageAndTitle];
        
    }
    return _careButton;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont boldSystemFontOfSize:kFontSizeWithpx(24)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"女生悄悄话";
    }
    return _contentLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.text = @"还没有人回答该问题，没有女朋友谁来帮帮忙啊啊啊啊啊！！！！";
    }
    return _subTitleLabel;
}

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
        
        make.left.top.mas_equalTo(10);
        make.height.mas_equalTo(GetAdapterHeight(44));
//        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.top.mas_equalTo(_cellImageView);
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
    
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        

        make.centerY.mas_equalTo(_timeLabel);
        make.left.mas_equalTo(_timeLabel.mas_right).offset(15);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView);
        make.top.mas_equalTo(_cellImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(-10);
        //        make.right.mas_equalTo(-10);
        //        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_contentLabel);
        make.right.mas_equalTo(_contentLabel);
        make.top.mas_equalTo(_contentLabel.mas_bottom).offset(10);
    }];
    
}

@end
