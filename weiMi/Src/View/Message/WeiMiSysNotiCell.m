//
//  WeiMiSysNotiCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSysNotiCell.h"
#import "WeiMiBaseView.h"

@interface WeiMiSysNotiCell()<UITextViewDelegate, UITextFieldDelegate>
{

}

@property (nonatomic, strong) UILabel *titleLB;
@property (nonatomic, strong) UILabel *detailLB;
@property (nonatomic, strong) WeiMiBaseView *bgView;

@end

@implementation WeiMiSysNotiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kClearColor;
        [self addSubview:self.bgView];
        
        [_bgView addSubview:self.titleLB];
        [_bgView addSubview:self.detailLB];

        [self setNeedsUpdateConstraints];
    }
    return self;
}

#pragma mark -Getter
- (WeiMiBaseView *)bgView
{
    if (!_bgView) {
        _bgView = [[WeiMiBaseView alloc] init];
        _bgView.backgroundColor = kWhiteColor;
        _bgView.layer.borderColor = kGrayColor.CGColor;
        _bgView.layer.borderWidth = 0.5f;
        _bgView.layer.cornerRadius = 3.0f;
    }
    return _bgView;
}

- (UILabel *)titleLB
{
    if (!_titleLB) {
        
        _titleLB = [[UILabel alloc] init];
        _titleLB.font = WeiMiSystemFontWithpx(22);
        _titleLB.textAlignment = NSTextAlignmentLeft;
        _titleLB.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _titleLB.numberOfLines = 1;
        _titleLB.text = @"上天猫就购了";
    }
    return _titleLB;
}

- (UILabel *)detailLB
{
    if (!_detailLB) {
        
        _detailLB = [[UILabel alloc] init];
        _detailLB.font = WeiMiSystemFontWithpx(20);
        _detailLB.textAlignment = NSTextAlignmentLeft;
        _detailLB.textColor = kGrayColor;
        _detailLB.numberOfLines = 0;
        _detailLB.text = @"您刚使用了184积分，看这里，看这里看这里，看这里看这里，看这里";
    }
    return _detailLB;
}

- (void)updateConstraints
{
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    
    [_detailLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_titleLB);
        make.bottom.mas_equalTo(-10);
        make.top.mas_equalTo(_titleLB.mas_bottom).offset(5);
    }];
    
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 15, 0, 15));
    }];
    [super updateConstraints];
}


@end
