//
//  WeiMiPrivilegeCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPrivilegeCell.h"

@interface WeiMiPrivilegeCell()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *timeoutImageView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *chitLabel;
@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;

@property (nonatomic, strong) UILabel *deadLineLabel;
@end

@implementation WeiMiPrivilegeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"white_bg"]];
//        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_bg"]];
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.timeoutImageView];
        [self addSubview:self.lineView];
        [self addSubview:self.leftImageView];
        [self addSubview:self.chitLabel];
        [self addSubview:self.priceLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
        [self addSubview:self.deadLineLabel];
        
        [self.timeoutImageView setHidden:YES];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setViewWithDTO:(WeiMiPrivilegeDTO *)dto
{
    if (dto.timeOut) {
        [self.timeoutImageView setHidden:NO];
        _leftImageView.image = [UIImage imageNamed:@"_discountcoupon_gray"];
    }
    _deadLineLabel.text = dto.voucherTimeStart;
    _priceLabel.attributedText = [self getAttrStrWithPrice:dto.voucherEnd];
    _subTitleLabel.text = [NSString stringWithFormat:@"仅限于在唯蜜生活的积分商城使用，并且消费满%@才可以抵用。", dto.voucherStart];

}

#pragma mark - Getter
- (UILabel *)deadLineLabel
{
    if (!_deadLineLabel) {
        _deadLineLabel = [[UILabel alloc] init];
        _deadLineLabel.font = [UIFont fontWithName:@"Arial" size:14];
        _deadLineLabel.textAlignment = NSTextAlignmentRight;
        _deadLineLabel.text = @"有效期至";
    }
    return _deadLineLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Arial" size:16];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"唯蜜生活积分商城代金券";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
        _subTitleLabel.text = @"仅限于在唯蜜生活的积分商城使用，并且消费满 才可以抵用。";
        _subTitleLabel.numberOfLines = 3;
    }
    return _subTitleLabel;
}

-(UILabel *)chitLabel
{
    if (!_chitLabel) {
        _chitLabel = [[UILabel alloc] init];
        _chitLabel.font = [UIFont fontWithName:@"Arial" size:15];
        _chitLabel.textAlignment = NSTextAlignmentCenter;
        _chitLabel.textColor = kWhiteColor;
        _chitLabel.text = @"代金券";
    }
    return _chitLabel;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont fontWithName:@"Arial" size:15];
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        _priceLabel.attributedText = [self getAttrStrWithPrice:@"5"];
    }
    return _priceLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kGrayColor;
    }
    return _lineView;
}
- (UIImageView *)leftImageView
{
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.image = [UIImage imageNamed:@"_discountcoupon"];
    }
    return _leftImageView;
}

- (UIImageView *)timeoutImageView
{
    if (!_timeoutImageView) {
        _timeoutImageView = [[UIImageView alloc] init];
        _timeoutImageView.image = [UIImage imageNamed:@"white_bg"];
    }
    return _timeoutImageView;
}

#pragma mark - Common
- (NSMutableAttributedString *)getAttrStrWithPrice:(NSString *)str
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"¥ " attributes:@{
                                                        NSForegroundColorAttributeName:kWhiteColor,
                                                        NSFontAttributeName:[UIFont systemFontOfSize:25],
                                                                                                        }];
    
    NSAttributedString *suffStr = [[NSAttributedString alloc] initWithString:str attributes:@{
                                                        NSForegroundColorAttributeName:kWhiteColor,
                                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:40],
                                                     }];
    if (str.integerValue >= 100) {
        suffStr = [[NSAttributedString alloc] initWithString:str attributes:@{
                                                                              NSForegroundColorAttributeName:kWhiteColor,
                                                                              NSFontAttributeName:[UIFont boldSystemFontOfSize:30],
                                                                              }];
    }
    [attStr appendAttributedString:suffStr];
    
    return attStr;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.bottom.mas_equalTo(self);
        make.width.mas_equalTo(90);
    }];
    
    [_timeoutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.top.left.mas_equalTo(0);
        make.height.mas_equalTo(_timeoutImageView.mas_width).dividedBy(3.08);
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.height*0.7);
    }];
    
    [_chitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_leftImageView);
        make.top.mas_equalTo(self.height*0.65 + 10);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_greaterThanOrEqualTo(_leftImageView);
        make.left.right.mas_equalTo(_leftImageView);
        make.bottom.mas_equalTo(_chitLabel.mas_top).offset(-10);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(_leftImageView.mas_right).offset(5);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_leftImageView.mas_right).offset(5);
        make.right.mas_equalTo(-80);
        make.bottom.mas_equalTo(_lineView);
    }];
    
    [_deadLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.mas_equalTo(-5);
    }];
    
    [super updateConstraints];
}

@end
