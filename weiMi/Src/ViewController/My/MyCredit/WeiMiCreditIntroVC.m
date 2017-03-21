//
//  WeiMiCreditIntroVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditIntroVC.h"
#import "WeiMiWebView.h"


@interface WeiMiCreditIntroVC()<WeiMiWebViewDelegate>

@property(nonatomic, strong) WeiMiWebView *webView;
@end

@implementation WeiMiCreditIntroVC


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
    //加载本地html
    NSString *path = [[NSBundle mainBundle] bundlePath];
    //    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:@"creditIntro"
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
    self.title = @"积分说明";
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
