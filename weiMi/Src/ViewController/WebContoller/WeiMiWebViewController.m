//
//  WeiMiWebViewController.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWebViewController.h"
#import "WeiMiWebView.h"

@interface WeiMiWebViewController ()<WeiMiWebViewDelegate>

@property(nonatomic, strong) WeiMiWebView *webView;

@end
@implementation WeiMiWebViewController

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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.contentFrame = [self visibleBoundsShowNav:NO showTabBar:NO];
    
    [self.contentView addSubview:self.webView];
//    self.webView.frame = self.contentFrame;
    self.webView.delegate = self;
    
    if (self.url) {
        //去除特殊符号
        self.url = [self.url stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
        [self.webView loadURL:[NSURL URLWithString:self.url]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"链接";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        if (_saveName) {
        //            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVC" params:@[_name]];
        //        }
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (WeiMiWebView *)webView
{
    if (!_webView) {
        //        CGRect frame = self.contentFrame;
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_BAR_HEIGHT - NAV_HEIGHT);
        _webView = [[WeiMiWebView alloc] initWithFrame:frame];
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - Delegate
- (void)WeiMiWebView:(WeiMiWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    
}
- (void)WeiMiWebView:(WeiMiWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{
    
}
- (void)WeiMiWebView:(WeiMiWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{
    
}
- (void)WeiMiWebViewDidStartLoad:(WeiMiWebView *)webview
{
    
}

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

@end
