//
//  WeiMiRelativeInvitaionCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRelativeInvitaionCell.h"
#import "UIImageView+WebCache.h"

@interface WeiMiRelativeInvitaionCell()


@property (nonatomic, strong) UILabel *commentLB;//相关帖子推荐

@property (nonatomic, strong) UIButton *leftBTN;
@property (nonatomic, strong) UILabel *leftLB;
@property (nonatomic, strong) UIButton *rightBTN;
@property (nonatomic, strong) UILabel *rightLB;

@end


@implementation WeiMiRelativeInvitaionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self addSubview:self.commentLB];
        [self addSubview:self.leftBTN];
        [self addSubview:self.leftLB];
        [self addSubview:self.rightBTN];
        [self addSubview:self.rightLB];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark - Getter
- (UILabel *)commentLB
{
    if (!_commentLB) {
        _commentLB = [[UILabel alloc] init];
        _commentLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _commentLB.textAlignment = NSTextAlignmentLeft;
        _commentLB.numberOfLines = 0;
        _commentLB.text = @"相关帖子推荐";
    }
    return _commentLB;
}

- (UILabel *)leftLB
{
    if (!_leftLB) {
        _leftLB = [[UILabel alloc] init];
        _leftLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _leftLB.textAlignment = NSTextAlignmentLeft;
        _leftLB.numberOfLines = 0;
        _leftLB.text = @"相关帖子推荐";
    }
    return _leftLB;
}

- (UILabel *)rightLB
{
    if (!_rightLB) {
        _rightLB = [[UILabel alloc] init];
        _rightLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _rightLB.textAlignment = NSTextAlignmentLeft;
        _rightLB.numberOfLines = 0;
        _rightLB.text = @"相关帖子推荐";
    }
    return _rightLB;
}

- (UIButton *)leftBTN
{
    if (!_leftBTN) {
        _leftBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_leftBTN sizeToFit];
        _leftBTN.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_leftBTN setTitle:@"撒飒飒" forState:UIControlStateNormal];
        //        [_leftBTN setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_leftBTN setImage:[UIImage imageNamed:@"weimiQrCode"] forState:UIControlStateNormal];
        [_leftBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBTN sizeToFit];
        
        
    }
    return _leftBTN;
}

- (UIButton *)rightBTN
{
    if (!_rightBTN) {
        _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBTN.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_rightBTN setTitle:@"sasasa" forState:UIControlStateNormal];
        //        [_rightBTN setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_rightBTN setImage:[UIImage imageNamed:@"weimiQrCode"] forState:UIControlStateNormal];
        [_rightBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBTN sizeToFit];
        
    }
    return _rightBTN;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    OnInvitaitonCellBTNHandler handler = self.onBtnHandler;
    if (sender ==_leftBTN) {
        handler(YES);
    }
    else
    {
        handler(NO);

    }
}

#pragma mark - layout
- (void)layoutSubviews
{
    
    [super layoutSubviews];
}

- (void)updateConstraints
{
    [_commentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.left.right.mas_equalTo(_titleLB);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 10);
        make.top.mas_equalTo(10);
    }];

    
    [@[_leftBTN , _rightBTN] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.mas_equalTo(_commentLB.mas_bottom).offset(10);
        make.size.mas_equalTo(GetAdapterHeight(80), GetAdapterHeight(75));
    }];

    [@[_leftLB, _rightLB] mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.mas_equalTo(_leftBTN);
    }];

    [_leftBTN mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(_commentLB);
    }];

    [_leftLB mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(_leftBTN.mas_right).offset(5);
        make.right.mas_equalTo(_rightBTN.mas_left);
    }];

    [_rightBTN mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(SCREEN_WIDTH/2);
    }];

    [_rightLB mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(_rightBTN.mas_right).offset(5);
        make.right.mas_equalTo(_commentLB);
    }];
    
    [super updateConstraints];
}


@end
