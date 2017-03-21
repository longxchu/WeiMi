//
//  WeiMiNotifiEmptyView.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNotifiEmptyView.h"

@interface WeiMiNotifiEmptyView()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *notiLabel;

@end

@implementation WeiMiNotifiEmptyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    return self;
}

- (void)setViewWithImg:(NSString *)img title:(NSString *)title
{
    [self addSubview:self.imgView];
    [self addSubview:self.notiLabel];
    _imgView.image = [UIImage imageNamed:img];
    _notiLabel.attributedText = [self getAttr:title];
    [self setNeedsUpdateConstraints];
}

#pragma mark - Util
- (NSMutableAttributedString *)getAttr:(NSString *)title
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
//    style.firstLineHeadIndent = 10;
//    style.headIndent = 10;//左缩进
//    style.tailIndent = -10;//右缩进
    style.lineSpacing = 5.0f;
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,title.length)];
    return attrStr;
}

#pragma mark - Setter
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UILabel *)notiLabel
{
    if (!_notiLabel) {
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.textAlignment = NSTextAlignmentCenter;
        _notiLabel.font = WeiMiSystemFontWithpx(22);
        _notiLabel.numberOfLines = 0;
        _notiLabel.textColor = kGrayColor;
    }
    return _notiLabel;
}

- (void)updateConstraints
{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self);
        make.size.mas_equalTo(_imgView.image.size);
        make.bottom.mas_equalTo(self.mas_centerY);
//        make.bottom.mas_equalTo(_notiLabel.mas_top).offset(-20);
    }];
    
    [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.mas_centerY).offset(20);
        make.bottom.mas_lessThanOrEqualTo(self);
    }];
    
    [super updateConstraints];
}

@end
