//
//  WeiMiHomeActivityDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomeActivityDetailVC.h"
#import "WeiMiWebView.h"
#import "WeiMiActivityCommentBar.h"
#import "WeiMiInvitationDetailHeaderView.h"
//-------- requset
#import "WeiMiNewestActDetailRequest.h"
#import "WeiMiNewestActDetailResponse.h"
#import "UIImageView+WebCache.h"

@interface WeiMiHomeActivityDetailVC ()<WeiMiWebViewDelegate, UIWebViewDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_imgArr;
    
    WeiMiNewestActDetailDTO *_dto;
}

@property (nonatomic, strong) UIScrollView *scrollBGView;
@property (nonatomic, strong) WeiMiInvitationDetailHeaderView *userCell;

@property (nonatomic, strong) UILabel *headerLB;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WeiMiActivityCommentBar *toolBar;



@end

@implementation WeiMiHomeActivityDetailVC

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
    

    [self.contentView addSubview:self.scrollBGView];
    _scrollBGView.frame = self.contentFrame;
//    _scrollBGView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    
    [_scrollBGView addSubview:self.userCell];

    [_scrollBGView addSubview:self.headerLB];
//    [_scrollBGView addSubview:self.contentTextView];
    [_scrollBGView addSubview:self.webView];
    
//    [self.contentView addSubview:self.toolBar];
    
    [self getNewestDetailWithId:self.actId];
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
    self.title = @"活动详情";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (WeiMiActivityCommentBar *)toolBar
{
    if (!_toolBar) {
        _toolBar = [[WeiMiActivityCommentBar alloc] initWithFrame:CGRectMake(0, _scrollBGView.bottom, SCREEN_WIDTH, 48)];
    }
    return _toolBar;
}

- (UIScrollView *)scrollBGView
{
    if (!_scrollBGView) {
        _scrollBGView = [[UIScrollView alloc] init];
        _scrollBGView.scrollEnabled = YES;
        _scrollBGView.showsVerticalScrollIndicator = NO;
        _scrollBGView.showsHorizontalScrollIndicator = NO;
        //        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, 0);
    }
    return _scrollBGView;
}

- (WeiMiInvitationDetailHeaderView *)userCell
{
    if (!_userCell) {
        _userCell = [[WeiMiInvitationDetailHeaderView alloc] init];
    }
    return _userCell;
}

- (UIWebView *)webView
{
    if (!_webView) {
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(20, 300, self.view.frame.size.width - 40, 400)];
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
        //        [_webView loadHTMLString:str1 baseURL:nil];
        _webView.height = 200;

    }
    return _webView;
}

- (UILabel *)headerLB
{
    if (!_headerLB) {
        
        _headerLB = [[UILabel alloc] init];
        _headerLB.font = WeiMiSystemFontWithpx(28);
        _headerLB.textAlignment = NSTextAlignmentLeft;
        _headerLB.numberOfLines = 0;
        _headerLB.text = @"加载中";
    }
    return _headerLB;
}

- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = WeiMiSystemFontWithpx(21);
        _contentTextView.scrollEnabled = NO;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        _contentTextView.text = @"加载中";
    }
    return _contentTextView;
}

#pragma mark - Network
//---- 最新活动列表
- (void)getNewestDetailWithId:(NSString *)actId
{
    if (!actId) {
        return;
    }
    WeiMiNewestActDetailRequest *request = [[WeiMiNewestActDetailRequest alloc] initWithActId:actId];
    WeiMiNewestActDetailResponse *response = [[WeiMiNewestActDetailResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        if (result) {
            [response parseResponse:result];
//            _dto = response.dto;
            
            [self configData:response.dto];
        }else
        {
            [strongSelf presentSheet:@"获取失败"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
    }];
}

- (void)configData:(WeiMiNewestActDetailDTO *)dto
{
    _headerLB.text = dto.atTitle;
    _userCell.titleLabel.text = dto.atTitle;
    [_userCell.cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.atImg)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
//    _contentTextView.text = dto.atContent;
    
//    NSData *data = [dto.atContent dataUsingEncoding:NSUnicodeStringEncoding];
//    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
//    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
//                                                               options:options
//                                                    documentAttributes:nil
//                                                                 error:nil];
//    _contentTextView.attributedText = html;
    
    [_webView loadHTMLString:dto.atContent baseURL:nil];
}

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
    // CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"]floatValue];
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
//    webView.frame = newFrame;
    
    [_webView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(webViewHeight);
    }];
    if(webViewHeight > SCREEN_HEIGHT-64-80){
        _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, webViewHeight+80);
    }
}


#pragma mark - Constraints

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, _webView.bottom > SCREEN_HEIGHT ? _webView.bottom +10 : SCREEN_HEIGHT - NAV_HEIGHT -STATUS_BAR_HEIGHT  + 10);
    
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints
{
    
    [_userCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo(_scrollBGView);
    }];

    [_headerLB mas_makeConstraints:^(MASConstraintMaker *make) {

        make.left.mas_equalTo(10);
        make.width.mas_equalTo(SCREEN_WIDTH - 20);
        make.top.mas_equalTo(_userCell.mas_bottom).offset(10);
    }];

//    [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//
//        make.left.mas_equalTo(_headerLB);
//        make.width.mas_equalTo(_headerLB);
//        make.top.mas_equalTo(_headerLB.mas_bottom).offset(10);
//    }];
    
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_headerLB);
        make.width.mas_equalTo(_headerLB);
        make.top.mas_equalTo(_headerLB.mas_bottom).offset(10);
//        make.height.mas_equalTo(200);
    }];
    
    [super updateViewConstraints];
}


@end
