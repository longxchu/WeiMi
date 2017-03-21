//
//  WeiMiWebView.h
//  app
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import "WeiMiBaseView.h"
#import <WebKit/WebKit.h>

@class WeiMiWebView;
@protocol WeiMiWebViewDelegate <NSObject>

@optional
- (void)WeiMiWebView:(WeiMiWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)WeiMiWebView:(WeiMiWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)WeiMiWebView:(WeiMiWebView *)webview shouldStartLoadWithURL:(NSURL *)URL;
- (void)WeiMiWebViewDidStartLoad:(WeiMiWebView *)webview;

@end

@interface WeiMiWebView : WeiMiBaseView <WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>

/// delegate
@property (nonatomic, weak) id<WeiMiWebViewDelegate> delegate;
/// 进度条
@property (nonatomic, strong) UIProgressView *progressView;
/// IOS8之前使用
@property (nonatomic, strong) UIWebView *uiWebView;
/// IOS之后使用WKWebView
@property (nonatomic, strong) WKWebView *wkWebView;

#pragma mark - Initializers view
- (instancetype)initWithFrame:(CGRect)frame;


#pragma mark - Static Initializers
@property (nonatomic, strong) UIBarButtonItem *actionButton;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, assign) BOOL actionButtonHidden;
@property (nonatomic, assign) BOOL showsURLInNavigationBar;
@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;

//Allow for custom activities in the browser by populating this optional array
@property (nonatomic, strong) NSArray *customActivityItems;

#pragma mark - Public Interface

// Load a NSURLURLRequest to web view
// Can be called any time after initialization
- (void)loadRequest:(NSURLRequest *)request;

// Load a NSURL to web view
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;

// Loads a URL as NSString to web view
// Can be called any time after initialization
- (void)loadURLString:(NSString *)URLString;

// Loads an string containing HTML to web view
// Can be called any time after initialization
- (void)loadHTMLString:(NSString *)HTMLString;

- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler; 
@end
