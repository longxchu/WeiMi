//
//  WeiMiApplyContentVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiApplyContentVC.h"

@interface WeiMiApplyContentVC ()

@property (nonatomic, strong) UIScrollView *scrollBGView;

@property (nonatomic, strong) UILabel *applyDeclarationLB;//申请宣言
@property (nonatomic, strong) UILabel *recInfoLB;//收货信息
@property (nonatomic, strong) UITextView *applyDeclarationTextView;
@property (nonatomic, strong) UITextView *recInfoTextView;

@end

@implementation WeiMiApplyContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.scrollBGView];
    _scrollBGView.frame = self.contentFrame;

    [_scrollBGView addSubview:self.applyDeclarationLB];
    [_scrollBGView addSubview:self.applyDeclarationTextView];

    [_scrollBGView addSubview:self.recInfoLB];
    [_scrollBGView addSubview:self.recInfoTextView];

    [self.view setNeedsUpdateConstraints];

}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"申请内容";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        if (_saveName) {
        //            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVC" params:@[_name]];
        //        }
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:@"确定" normal:nil selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf presentSheet:@"申请已提交"];
    }];
}

#pragma mark - Getter
- (UIScrollView *)scrollBGView
{
    if (!_scrollBGView) {
        _scrollBGView = [[UIScrollView alloc] init];
        _scrollBGView.showsVerticalScrollIndicator = NO;
        _scrollBGView.showsHorizontalScrollIndicator = NO;
        _scrollBGView.scrollEnabled = YES;
        //        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    }
    return _scrollBGView;
}

- (UILabel *)applyDeclarationLB
{
    if (!_applyDeclarationLB) {
        _applyDeclarationLB = [[UILabel alloc] init];
        _applyDeclarationLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _applyDeclarationLB.textAlignment = NSTextAlignmentLeft;
        _applyDeclarationLB.numberOfLines = 0;
        _applyDeclarationLB.text = @"申请宣言";
    }
    return _applyDeclarationLB;
}

- (UITextView *)applyDeclarationTextView
{
    if (!_applyDeclarationTextView) {
        _applyDeclarationTextView = [[UITextView alloc] init];
        _applyDeclarationTextView.scrollEnabled = NO;
        _applyDeclarationTextView.backgroundColor = HEX_RGB(0xF6F6F6);
        _applyDeclarationTextView.textColor = [UIColor darkGrayColor];
        _applyDeclarationTextView.font = WeiMiSystemFontWithpx(20);
        _applyDeclarationTextView.text = @" 很喜欢!";
    }
    return _applyDeclarationTextView;
}

- (UILabel *)recInfoLB
{
    if (!_recInfoLB) {
        _recInfoLB = [[UILabel alloc] init];
        _recInfoLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _recInfoLB.textAlignment = NSTextAlignmentLeft;
        _recInfoLB.numberOfLines = 0;
        _recInfoLB.text = @"收货信息";
    }
    return _recInfoLB;
}

- (UITextView *)recInfoTextView
{
    if (!_recInfoTextView) {
        _recInfoTextView = [[UITextView alloc] init];
        _recInfoTextView.scrollEnabled = NO;
        _recInfoTextView.backgroundColor = HEX_RGB(0xF6F6F6);
        _recInfoTextView.textColor = [UIColor darkGrayColor];
        _recInfoTextView.font = WeiMiSystemFontWithpx(20);
        _recInfoTextView.text = @"收货人：送至\n\n收货地址：北京市北山街公寓！";
    }
    return _recInfoTextView;
}
#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, _recInfoTextView.bottom > SCREEN_HEIGHT ? _recInfoTextView.bottom +10 : SCREEN_HEIGHT + 10);
    
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints
{
    [_applyDeclarationLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.mas_equalTo(15);
        make.width.mas_equalTo(SCREEN_WIDTH - 30);
    }];
    
    [_applyDeclarationTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_applyDeclarationLB);
        make.height.mas_greaterThanOrEqualTo(100);
        make.top.mas_equalTo(_applyDeclarationLB.mas_bottom).offset(10);
    }];
    
    [_recInfoLB mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_applyDeclarationLB);
        make.top.mas_equalTo(_applyDeclarationTextView.mas_bottom).offset(10);
    }];
    
    [_recInfoTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_applyDeclarationLB);
        make.height.mas_greaterThanOrEqualTo(150);
        make.top.mas_equalTo(_recInfoLB.mas_bottom).offset(10);
    }];
    [super updateViewConstraints];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
