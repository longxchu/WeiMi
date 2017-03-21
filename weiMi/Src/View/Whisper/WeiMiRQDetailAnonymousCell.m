//
//  WeiMiRQDetailAnonymousCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQDetailAnonymousCell.h"
#import "UIButton+CenterImageAndTitle.h"

@interface WeiMiRQDetailAnonymousCell()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *careButton;

@property (nonatomic, strong) UILabel *infoLabel;
@end

@implementation WeiMiRQDetailAnonymousCell

+ (CGFloat)getHeightWithDTO:(WeiMiMaleFemaleRQDTO *)dto
{
    static WeiMiRQDetailAnonymousCell *testCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testCell = [[WeiMiRQDetailAnonymousCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"testCell"];
    });
    
    [testCell setViewWithDTO:dto];
    
    [testCell setNeedsLayout];
    [testCell layoutIfNeeded];
    
    CGFloat height = 55;
    height += [dto.qtTitle returnSize:testCell.titleLabel.font MaxWidth:SCREEN_WIDTH - 20].height;
    height += [dto.qtContent returnSize:testCell.subTitleLabel.font MaxWidth:SCREEN_WIDTH - 20].height;
    
    return height + 20;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
        [self.contentView addSubview:self.careButton];
        [self.contentView addSubview:self.infoLabel];
        
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    return self;
}

#pragma mark - Setter
- (void)setViewWithDTO:(WeiMiMaleFemaleRQDTO *)dto
{
//    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:[UIImage imageNamed:@"followus_bg480x800"]];
    _titleLabel.text = dto.qtTitle;
    _subTitleLabel.text = dto.qtContent;
    [_careButton setTitle:[NSString stringWithFormat:@"%ld", (long)dto.yuedu] forState:UIControlStateNormal];
    _infoLabel.text = [NSString stringWithFormat:@"匿名用户 %@", dto.createTime];
    [_careButton sizeToFit];
}

#pragma mark - Getter

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 0;
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
        _subTitleLabel.numberOfLines = 0;
        _subTitleLabel.text = @"还没有人回答该问题，没有女朋友谁来帮帮忙啊啊啊啊啊！！！！";
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

- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _infoLabel.textAlignment = NSTextAlignmentLeft;
        _infoLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _infoLabel.numberOfLines = 1;
        _infoLabel.text = @"匿名用户 5小时前";
    }
    return _infoLabel;
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
        
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        //        make.right.mas_equalTo(-10);
//        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_titleLabel);
        make.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
    }];
    
    [_careButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.width.mas_equalTo(_careButton.mas_height).multipliedBy(2.08f);
        //        make.height.mas_equalTo(20);
        make.top.mas_equalTo(_subTitleLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(_titleLabel);
//        make.centerY.mas_equalTo(_subTitleLabel);
    }];
    
    [_infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_careButton);
        make.left.mas_equalTo(_careButton.mas_right).offset(10);
        make.right.mas_equalTo(-10);
    }];
    [super updateConstraints];
}

@end
