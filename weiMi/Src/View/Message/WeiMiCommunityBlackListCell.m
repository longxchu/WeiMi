//
//  WeiMiCommunityBlackListCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommunityBlackListCell.h"
#import "UIImageView+WebCache.h"

@interface WeiMiCommunityBlackListCell()


@property (nonatomic, strong) UIImageView *cellImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *tagLB;

@property (nonatomic, strong) UIButton *commentBTN;
@end

@implementation WeiMiCommunityBlackListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.cellImageView];
        [self.contentView addSubview:self.titleLabel];
        
        [self.contentView addSubview:self.tagLB];
        [self.contentView addSubview:self.commentBTN];
        [self setNeedsUpdateConstraints];
    }
    return self;
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

- (UILabel *)titleLabel
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

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
        _tagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _tagLB.textAlignment = NSTextAlignmentCenter;
        _tagLB.textColor = kWhiteColor;
        _tagLB.backgroundColor = HEX_RGB(0x5ECBCF);
        _tagLB.text = @"lv5";
    }
    return _tagLB;
}

- (UIButton *)commentBTN
{
    if (!_commentBTN) {
        _commentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBTN setTitle:@"移除" forState:UIControlStateNormal];
        [_commentBTN setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        _commentBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _commentBTN.layer.borderColor = HEX_RGB(BASE_COLOR_HEX).CGColor;
        _commentBTN.layer.borderWidth = 1.0f;
        _commentBTN.layer.cornerRadius = 3.0f;
//        [_commentBTN setBackgroundImage:[UIImage imageNamed:@"com_blackList_purple_-rectangle-"] forState:UIControlStateNormal];
//        [_commentBTN setBackgroundImage:[UIImage imageNamed:@"com_blackList_purple_-rectangle-"] forState:UIControlStateHighlighted];
        [_commentBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBTN;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    OnDeleteHandler block = self.onDeleteHandler;
    if (block) {
        block();
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
        
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(self).multipliedBy(0.81);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(_cellImageView.mas_height);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_cellImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(_cellImageView);
        make.height.mas_equalTo(_cellImageView);
    }];
    
    [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_cellImageView);
        make.left.mas_equalTo(_titleLabel.mas_right).offset(15);
        make.height.mas_equalTo(_commentBTN).offset(-5);
        make.width.mas_equalTo(_tagLB.mas_height).multipliedBy(2);
        make.right.mas_lessThanOrEqualTo(_commentBTN.mas_left);
    }];
    
    [_commentBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_cellImageView);
        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(25)*2, GetAdapterHeight(25)));
    }];

}


@end
