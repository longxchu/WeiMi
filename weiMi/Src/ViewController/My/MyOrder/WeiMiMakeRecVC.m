//
//  WeiMiMakeRecVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMakeRecVC.h"
#import "WeiMiNotifiEmptyView.h"

@interface WeiMiMakeRecVC()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;
@property (nonatomic, strong) UIButton *bindBtn;

@end

@implementation WeiMiMakeRecVC

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.scrollView];
    _scrollView.frame = self.contentFrame;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.contentFrame.size.height + 10);
    [_scrollView addSubview:self.notiView];
    [_scrollView addSubview:self.bindBtn];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"待收货";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        [strongSelf.APP.mineRouter open:[NSString stringWithFormat:@"WeiMiModifyNameVC/%@", _name]];
        
        
        [strongSelf BackToLastNavi];
    }];
    
}

- (BOOL)controllerWillPopHandler
{
    return YES;
}

#pragma mark -Actions
- (void)onButton:(UIButton *)sender
{
    [self presentSheet:@"去逛逛商城吧"];
}

#pragma mark - Getter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
//        _scrollView.contentSize = CGSizeZero;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled = YES;
    }
    return _scrollView;
}
- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"_icon_succeed" title:@"收货成功!"];
        _notiView.backgroundColor = kWhiteColor;
    }
    return _notiView;
}


- (UIButton *)bindBtn
{
    if (!_bindBtn) {
        _bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bindBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_bindBtn setTitle:@"逛逛商城" forState:UIControlStateNormal];
        [_bindBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_bindBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bindBtn;
}


#pragma mark - Constraints
- (void)updateViewConstraints
{
    [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(GetAdapterHeight(150));
    }];
    
    [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.view).offset(15);
        make.right.mas_equalTo(self.view).offset(-15);
        make.height.mas_equalTo(43);
        make.centerY.mas_equalTo(_scrollView);
    }];
    [super updateViewConstraints];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}


@end
