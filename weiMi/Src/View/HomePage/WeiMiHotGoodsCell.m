//
//  WeiMiHotGoodsCell.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHotGoodsCell.h"
#import "WeiMiCountDownView.h"

@interface WeiMiHotGoodsCell()

@property (nonatomic, strong) WeiMiCountDownView *countDownView;
//@property (nonatomic, strong) WeiMiPriceGoodView *priceGoodView;

//@property (nonatomic, strong) UIButton *maskBTN;


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@end

@implementation WeiMiHotGoodsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.countDownView];
        [self.contentView addSubview:self.priceGoodView];
//        _countDownView.userInteractionEnabled = NO;
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.rightImageView_2];
        [self.contentView addSubview:self.rightImageView_3];
        
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subTitleLabel];
//        [self.contentView addSubview:self.maskBTN];
        [self setNeedsUpdateConstraints];
        
        // 注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTimeLabel:) name:NOTIFI_CHANGEDOWNTIME object:nil];
    }
    return self;

}


#pragma mark - Getter
- (UIButton *)rightImageView
{
    if (!_rightImageView) {
        _rightImageView = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightImageView setBackgroundImage:[UIImage imageNamed:@"followus_bg480x800"] forState:UIControlStateNormal];
        [_rightImageView addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightImageView;
}

- (UIButton *)rightImageView_2
{
    if (!_rightImageView_2) {
        _rightImageView_2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_rightImageView_2 setBackgroundImage:[UIImage imageNamed:@"followus_bg480x800"] forState:UIControlStateNormal];
        [_rightImageView_2 addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightImageView_2;
}
    
    - (UIButton *)rightImageView_3
    {
        if (!_rightImageView_3) {
            _rightImageView_3 = [UIButton buttonWithType:UIButtonTypeCustom];
            [_rightImageView_3 setBackgroundImage:WEIMI_PLACEHOLDER_RECT forState:UIControlStateNormal];
            [_rightImageView_3 addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        return _rightImageView_3;
    }


- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:@"Arial-Bold" size:kFontSizeWithpx(20)];
        _titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"热卖商品";
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (!_subTitleLabel) {
        
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(16)];
        _subTitleLabel.textColor = HEX_RGB(0xb5b5b5);
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        _subTitleLabel.text = @"HOT SELLERS";
    }
    return _subTitleLabel;
}


- (WeiMiCountDownView *)countDownView
{
    if (!_countDownView) {
        
        _countDownView = [[WeiMiCountDownView alloc] init];
        [_countDownView addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
//        _countDownView.backgroundColor = kGreenColor;
    }
    return _countDownView;
}

- (WeiMiPriceGoodView *)priceGoodView
{
    if (!_priceGoodView) {
        _priceGoodView = [[WeiMiPriceGoodView alloc] init];
        [_priceGoodView addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _priceGoodView;
}

//- (UIButton *)maskBTN
//{
//    if (!_maskBTN) {
//        _maskBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_maskBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _maskBTN;
//}

#pragma mark - Actions
- (void)onButton:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didSelectedView:atIndex:)]) {
        if (sender == _countDownView) {
            
            [self.delegate didSelectedView:self atIndex:0];
        }else if (sender == _rightImageView)
        {
            [self.delegate didSelectedView:self atIndex:2];
        }else if (sender == _rightImageView_2)
        {
            [self.delegate didSelectedView:self atIndex:3];
        }else if (sender == _rightImageView_3)
        {
            [self.delegate didSelectedView:self atIndex:4];
        }
        else if (sender == _priceGoodView)
        {
            [self.delegate didSelectedView:self atIndex:1];
        }
    }
}

- (void)changeTimeLabel:(NSNotification*)nf
{
    NSDictionary *dic = nf.userInfo;
    NSString *second = dic[@"second"];
    NSString *hour = dic[@"hour"];
    NSString *minute = dic[@"minute"];
    
    [_countDownView setTimeLabel:hour minute:minute second:second];
}

- (void)updateConstraints
{
//    [_maskBTN mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.edges.mas_equalTo(self.);
//    }];
    
    [_countDownView mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(_priceGoodView);
        make.bottom.mas_equalTo(_priceGoodView.mas_top);
    }];
    
    [_priceGoodView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(self.height/4*2);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(self.width/5*2);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.left.right.mas_equalTo(_rightImageView_2);
        make.bottom.mas_equalTo(_rightImageView.mas_centerY);
//        make.top.mas_equalTo(10);
    }];
    
    [_subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.left.right.mas_equalTo(_titleLabel);
        make.top.mas_equalTo(_titleLabel.mas_bottom).offset(10);
    }];
    
    [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
//        make.top.right.bottom.mas_equalTo(0);
//        make.left.mas_equalTo(_countDownView.mas_right);
        make.bottom.mas_equalTo(_rightImageView_2.mas_top);
        make.left.mas_equalTo(_rightImageView_2.mas_right);
        make.size.mas_equalTo(_rightImageView_2);
    }];
    
    [_rightImageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(_priceGoodView.mas_right);
        make.height.mas_equalTo(self).multipliedBy(0.5);
        make.width.mas_equalTo(_rightImageView_2.mas_height);
    }];
    
    [_rightImageView_3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(_rightImageView_2);
        make.width.mas_equalTo(_rightImageView_2.mas_height);
    }];
    [super updateConstraints];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
