//
//  WeiMiCommentTopicCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommentTopicCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+CenterImageAndTitle.h"

@interface WeiMiCommentTopicCell()

@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *levelLB;

@property (nonatomic, strong) UIButton *upButton;
@property (nonatomic, strong) UIButton *downButton;

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@end



@implementation WeiMiCommentTopicCell

+ (CGFloat)getHeightWithDTO:(WeiMiRQDetailTopicDTO *)dto
{
    static WeiMiCommentTopicCell *testCell;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testCell = [[WeiMiCommentTopicCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:@"testCell"];
    });
    
    [testCell setViewWithDTO:dto];
    
    [testCell setNeedsLayout];
    [testCell layoutIfNeeded];
    
    CGFloat height = 40+GetAdapterHeight(44);
    height += [dto.subTitle returnSize:testCell.subTitleLabel.font MaxWidth:SCREEN_WIDTH - 20].height;
    
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.cellImageView];
        [self addSubview:self.titleLabel];
        [self addSubview:self.levelLB];
        [self addSubview:self.upButton];
        [self addSubview:self.downButton];
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.subTitleLabel];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Setter
- (void)setViewWithDTO:(WeiMiRQDetailTopicDTO *)dto
{
    [_cellImageView sd_setImageWithURL:[NSURL URLWithString:dto.imgURL] placeholderImage:[UIImage imageNamed:@"followus_bg480x800"]];
    _titleLabel.text = dto.user;
    _levelLB.text = [NSString stringWithFormat:@"lv%@", dto.level];
    _contentLabel.text = dto.subTitle;
//    _subTitleLabel.text = dto.subTitle;
//    [_careButton setTitle:dto.visitNum forState:UIControlStateNormal];
//    [_careButton sizeToFit];
}


#pragma mark - Getter
- (UIImageView *)cellImageView
{
    if (!_cellImageView) {
        _cellImageView = [[UIImageView alloc] init];
        _cellImageView.layer.masksToBounds = YES;
        [_cellImageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
    }
    return _cellImageView;
}

- (UILabel *)titleLabel//用户名
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.numberOfLines = 1;
        _titleLabel.text = @"小美女";
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
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

- (UIButton *)upButton
{
    if (!_upButton) {
        
        _upButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _upButton.titleLabel.font = WeiMiSystemFontWithpx(20);
        [_upButton setTitle:@"32" forState:UIControlStateNormal];
        //        [_careButton setTitle:@"取消" forState:UIControlStateSelected];
        [_upButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        //        [_careButton setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_upButton setImage:[UIImage imageNamed:@"wisper_icon_good"] forState:UIControlStateNormal];
        //        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateSelected];
        [_upButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_upButton sizeToFit];
        [_upButton horizontalCenterImageAndTitle];
        
    }
    return _upButton;
}

- (UIButton *)downButton
{
    if (!_downButton) {
        
        _downButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _downButton.titleLabel.font = WeiMiSystemFontWithpx(20);
        [_downButton setTitle:@"32" forState:UIControlStateNormal];
        //        [_careButton setTitle:@"取消" forState:UIControlStateSelected];
        [_downButton setTitleColor:kBlackColor forState:UIControlStateNormal];
        //        [_careButton setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_downButton setImage:[UIImage imageNamed:@"wisper_icon_bad"] forState:UIControlStateNormal];
        //        [_careButton setBackgroundImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateSelected];
        [_downButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_downButton sizeToFit];
        [_downButton horizontalCenterImageAndTitle];
        
    }
    return _downButton;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(21)];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _contentLabel.numberOfLines = 0;
        _contentLabel.text = @"女生悄悄话";
    }
    return _contentLabel;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender == _upButton) {
        
        if (sender.selected) {
            NSInteger num = [sender.titleLabel.text containsOnlyNumbers] ? sender.titleLabel.text.integerValue : 0;
            [sender setTitle:[NSString stringWithFormat:@"%ld", num + 1] forState:UIControlStateNormal];
            return;
        }
        NSInteger num = [sender.titleLabel.text containsOnlyNumbers] ? sender.titleLabel.text.integerValue : 0;
        if (num > 0 ) {
            [sender setTitle:[NSString stringWithFormat:@"%ld", num - 1] forState:UIControlStateNormal];
        }

    }else if (sender == _downButton)
    {
        if (sender.selected) {
            NSInteger num = [sender.titleLabel.text containsOnlyNumbers] ? sender.titleLabel.text.integerValue : 0;
            if (num > 0 ) {
                [sender setTitle:[NSString stringWithFormat:@"%ld", num - 1] forState:UIControlStateNormal];
            }
            return;
        }
        NSInteger num = [sender.titleLabel.text containsOnlyNumbers] ? sender.titleLabel.text.integerValue : 0;
        [sender setTitle:[NSString stringWithFormat:@"%ld", num + 1] forState:UIControlStateNormal];
    }
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
        make.height.mas_equalTo(self).multipliedBy(0.295);
        //        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(_cellImageView);
    }];
    
    
    [_levelLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_titleLabel);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(15);
        //        make.height.mas_equalTo(_commentBTN).offset(-5);
        make.width.mas_equalTo(_levelLB.mas_height).multipliedBy(2);
    }];
    
    [_upButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(_downButton.mas_left).offset(-10);
    }];
    
    [_downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.centerY.mas_equalTo(_cellImageView);
        make.right.mas_equalTo(-15);
    }];
    
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView);
        make.top.mas_equalTo(_cellImageView.mas_bottom).offset(10);
        make.right.mas_equalTo(-10);
        //        make.right.mas_equalTo(-10);
        //        make.bottom.mas_equalTo(self.mas_centerY);
    }];
    
}


@end
