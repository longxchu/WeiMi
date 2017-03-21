//
//  WeiMiPriceTagView.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPriceTagView.h"

@interface WeiMiPriceTagView()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation WeiMiPriceTagView

- (instancetype)init
{
    if (self = [super init]) {
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.priceLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.priceLabel];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setTagPrice:(NSString *)tagPrice
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tagPrice attributes:@{
                                                                                                                NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:HEX_RGB(BASE_TEXT_COLOR)}];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:@"元" attributes:@{
                                                                                              NSFontAttributeName:[UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:HEX_RGB(BASE_TEXT_COLOR)}];
    [attString appendAttributedString:sufStr];
    _priceLabel.attributedText = attString;
}

- (UILabel *)priceLabel
{
    if (!_priceLabel) {
        
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [UIFont boldSystemFontOfSize:16];
        _priceLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _priceLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"49" attributes:@{
                            NSFontAttributeName:[UIFont boldSystemFontOfSize:18], NSForegroundColorAttributeName:HEX_RGB(BASE_TEXT_COLOR)}];
        NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:@"元" attributes:@{
                        NSFontAttributeName:[UIFont boldSystemFontOfSize:13], NSForegroundColorAttributeName:HEX_RGB(BASE_TEXT_COLOR)}];
        [attString appendAttributedString:sufStr];
        _priceLabel.attributedText = attString;
        _priceLabel.transform = CGAffineTransformMakeRotation(- M_PI/6);
    }
    return _priceLabel;
}

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"icon_baohuan"];
    }
    return _bgImageView;
}

#pragma mark - Layout
- (void)updateConstraints
{
    [super updateConstraints];
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self);
    }];
}

@end
