//
//  WeiMiMyCreditHeaderView.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCreditHeaderView.h"

@interface WeiMiMyCreditHeaderView()

@property (nonatomic, strong) UILabel *creditLabel;
@property (nonatomic, strong) UILabel *notiLabel;
@property (nonatomic, strong) UIButton *rightTopButton;

@end

@implementation WeiMiMyCreditHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhiteColor;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        
        [self addSubview:self.creditLabel];
        [self addSubview:self.notiLabel];
        [self addSubview:self.rightTopButton];
        [self setNeedsUpdateConstraints];
    }
    return self;
}


- (void)setCreditNum:(NSString *)creditNum
{
    _creditLabel.attributedText = [self attrStringWithSuff:creditNum];
}

#pragma mark - Getter
- (UIButton *)rightTopButton
{
    if (!_rightTopButton) {
        _rightTopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightTopButton sizeToFit];
        _rightTopButton.titleLabel.font = WeiMiSystemFontWithpx(19);
        [_rightTopButton setTitle:@"积分说明" forState:UIControlStateNormal];
        [_rightTopButton setTitleColor:HEX_RGB(0x0AA0E6) forState:UIControlStateNormal];
        [_rightTopButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightTopButton;
}

- (UILabel *)creditLabel
{
    if (!_creditLabel) {
        
        _creditLabel = [[UILabel alloc] init];
        _creditLabel.textAlignment = NSTextAlignmentCenter;
        _creditLabel.font = WeiMiSystemFontWithpx(13);
        _creditLabel.numberOfLines = 1;
        _creditLabel.attributedText = [self attrStringWithSuff:@"0"];
//        _creditLabel.textColor = kGrayColor;
    }
    return _creditLabel;
}

- (UILabel *)notiLabel
{
    if (!_notiLabel) {
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.font = WeiMiSystemFontWithpx(24);
        _notiLabel.numberOfLines = 0;
        _notiLabel.text = @"当前积分";
//        _notiLabel.textColor = kGrayColor;
    }
    return _notiLabel;
}

#pragma mark - Util
- (NSMutableAttributedString *)attrStringWithSuff:(NSString *)suff
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:suff attributes:@{
                                                                                                        
                        NSFontAttributeName:[UIFont fontWithName:@"Arial" size:kFontSizeWithpx(62)], NSForegroundColorAttributeName:HEX_RGB(0xF4480B)}];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"分"] attributes:@{
                                                                                                                                    NSFontAttributeName:WeiMiSystemFontWithpx(28), NSForegroundColorAttributeName:HEX_RGB(0xF4480B)}];
    
    [attString appendAttributedString:sufStr];
    return attString;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    OnIntroBTNHandler block = self.onIntroBTNHandler;
    if (block) {
        block();
    }
}

- (void)updateConstraints
{
    [_creditLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_rightTopButton.mas_bottom);
        make.left.right.mas_equalTo(0);
//        make.height.mas_equalTo(self.height/3*2);
    }];
    
    [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(self);
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(_creditLabel.mas_bottom).offset(10);
        make.bottom.mas_lessThanOrEqualTo(self.mas_bottom);
    }];
    
    [_rightTopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(-10);
    }];
    [super updateConstraints];
}

@end
