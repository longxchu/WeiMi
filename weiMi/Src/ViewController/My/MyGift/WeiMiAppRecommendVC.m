//
//  WeiMiAppRecommendVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAppRecommendVC.h"
#import "WeiMiWebView.h"


@interface WeiMiAppRecommendVC()<WeiMiWebViewDelegate>

@property(nonatomic, strong) WeiMiWebView *webView;
@end

@implementation WeiMiAppRecommendVC


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
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.contentView addSubview:self.webView];
    self.webView.delegate = self;
    
    NSString *url = EncodeStringFromDic(self.params, @"url");
    if (url) {
        [self.webView loadURLString:url];
        return;
    }
    [self.webView loadURLString:@"http://www.cnblogs.com/monicaios/archive/2014/01/05.html"];
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
    self.title = @"App推荐";
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
        //        frame.size.height += frame.origin.y - NAV_HEIGHT;
        //        frame.origin.y = STATUS_BAR_HEIGHT;
        CGRect frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _webView = [[WeiMiWebView alloc] initWithFrame:frame];
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
