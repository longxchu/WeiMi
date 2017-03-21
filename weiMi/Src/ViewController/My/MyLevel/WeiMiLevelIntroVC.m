//
//  WeiMiLevelIntroVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLevelIntroVC.h"
#import "WeiMiWebView.h"

@interface WeiMiLevelIntroVC ()<WeiMiWebViewDelegate>

@property(nonatomic, strong) WeiMiWebView *webView;

@end

@implementation WeiMiLevelIntroVC

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
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.webView];
    self.webView.delegate = self;
    
    //加载本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
//    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"levelIntro"
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont];
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
    self.title = @"等级说明";
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
