//
//  WeiMiGoodsDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiGoodsDetailVC.h"
#import "WeiMiBaseTableView.h"
#import "CycleScrollView.h"
#import <UIImageView+WebCache.h>
#import "WeiMiGoodDetailHeader.h"
#import "UIButton+CenterImageAndTitle.h"
#import "WeiMiPurchaseGoodsVC.h"
#import "WeiMiMoreCommentVC.h"
#import "WeiMiWebView.h"
//------- cell
#import "WeiMiGoodDetailPriceCell.h"
#import "WeiMiPrivilegesCell.h"
#import "WeiMiGoodsDetailTagCell.h"
#import "WeiMiGoodsDetailCommentCell.h"
#import <OHAlertView.h>
//------- R&&Q
#import "WeiMiBannerRequest.h"
#import "WeiMiBannerResponse.h"
#import "WeiMiProductDetailRequest.h"
#import "WeiMiProductDetailResponse.h"

#import "WeiMiCollectionAddRequest.h"
//#import "WeiMiAddPurchaseChartRequest.h"
//评论列表
#import "WeiMiProductCommentListRequest.h"
#import "WeiMiProductCommentListResponse.h"
#import "WeiMiShoppingCartVC.h"
#import "SimpleShare.h"
//------- DTO
#import "WeiMiHomePageBannerDTO.h"

#import "WeiMiUserCenter.h"
#import "WeiMiLogInVC.h"

@interface WeiMiGoodsDetailVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WeiMiWebViewDelegate, UIWebViewDelegate>
{
    /**数据源*/
    NSMutableArray *_imgDataSource;
    //评论列表
    NSMutableArray *_commentDataSource;
    //请求响应
    WeiMiProductDetailResponse *_res;
    
    WeiMiGoodDetailPriceModel *_productInfoModel;
    //赠品
    NSString *_present;
    
    //webView高度
    float _webViewHeight;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic,strong) CycleScrollView *cycleScrollView;
@property (nonatomic, strong) UIWebView *picTextWevbView;

@property (nonatomic, strong) UIButton *buyBTN;
@property (nonatomic, strong) UIButton *addToChartBTN;
@property (nonatomic, strong) UIButton *collectBTN;
@property (nonatomic, strong) UIButton *serviceBTN;


@end

@implementation WeiMiGoodsDetailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _commentDataSource = [NSMutableArray new];
        _imgDataSource = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.tableView];
    CGRect frame = self.contentFrame;
    _tableView.frame = frame;
    _tableView.tableHeaderView = self.cycleScrollView;
    
    [self.view addSubview:self.addToChartBTN];
    [self.view addSubview:self.buyBTN];
    [self.view addSubview:self.collectBTN];
    [self.view addSubview:self.serviceBTN];
    
    [self.view setNeedsUpdateConstraints];

//    [self getBanner];
    [self getProductDetail:self.productId];
    [self getCommentListWithProductId:self.productId];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    [self.navigationController.navigationBar setTintColor:[UIColor clearColor]];
    
    self.title = @"宝贝详情";
    
//    self.popWithBaseNavColor = NO;
    
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    [self AddRightBtn:nil normal:@"nav_icon_share" selected:@"nav_icon_share" action:nil];
    UIBarButtonItem *shareBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_share"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    shareBtn.tintColor = [UIColor darkGrayColor];
    UIBarButtonItem *shoppingBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_shoping_detail"] style:UIBarButtonItemStylePlain target:self action:@selector(showShopingCartVC:)];
    shoppingBtn.tintColor = [UIColor darkGrayColor];
    self.navigationItem.rightBarButtonItems = @[shareBtn,shoppingBtn];
}
#pragma --z 分享
- (void)shareAction:(id)sender {
    if([WeiMiUserCenter sharedInstance].isLogin){
        [SimpleShare showShareActionSheet:self.view withTitle:@"商品分享" content:_productInfoModel.productName  imageUrl:WEIMI_IMAGEREMOTEURL(_res.dto.faceImgPath) linkUrl:nil];
    } else {
        WeiMiLogInVC *loginVC = [[WeiMiLogInVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma --z 跳转购物车
- (void)showShopingCartVC:(id)sender {
    if([WeiMiUserCenter sharedInstance].isLogin){
        WeiMiShoppingCartVC *weimibaseVC = [[WeiMiShoppingCartVC alloc] init];
        weimibaseVC.isFromeGoodDetails = YES;
        [self.navigationController pushViewController:weimibaseVC  animated:YES];
    } else {
        WeiMiLogInVC *loginVC = [[WeiMiLogInVC alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (UIWebView *)picTextWevbView
{
    if(!_picTextWevbView)
    {
        _picTextWevbView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        _picTextWevbView.backgroundColor = kWhiteColor;
        _picTextWevbView.scrollView.scrollEnabled = NO;
        _picTextWevbView.delegate = self;
        [_picTextWevbView setScalesPageToFit:YES];
    }
    return _picTextWevbView;
}

- (UIButton *)buyBTN
{
    if (!_buyBTN) {
        _buyBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_buyBTN setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_buyBTN setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_buyBTN setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_buyBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBTN;
}

- (UIButton *)addToChartBTN
{
    if (!_addToChartBTN) {
        
        _addToChartBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _addToChartBTN.titleLabel.font =  [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        [_addToChartBTN setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addToChartBTN setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        //        [_leftBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_addToChartBTN setBackgroundImage:[UIImage imageNamed:@"purple_border_btn"] forState:UIControlStateNormal];
        //        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateSelected];
        [_addToChartBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addToChartBTN;
}

- (UIButton *)collectBTN
{
    if (!_collectBTN) {
        _collectBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _collectBTN.titleLabel.font = WeiMiSystemFontWithpx(18);
        [_collectBTN setTitle:@"收藏" forState:UIControlStateNormal];
        [_collectBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_collectBTN setImage:[UIImage imageNamed:@"icon_shoucang"] forState:UIControlStateNormal];
        [_collectBTN.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_collectBTN sizeToFit];
        [_collectBTN verticalCenterImageAndTitle];
        [_collectBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _collectBTN;
}

- (UIButton *)serviceBTN
{
    if (!_serviceBTN) {
        _serviceBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _serviceBTN.titleLabel.font = WeiMiSystemFontWithpx(18);
        [_serviceBTN setTitle:@"客服" forState:UIControlStateNormal];
        [_serviceBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        [_serviceBTN setImage:[UIImage imageNamed:@"icon_kefu"] forState:UIControlStateNormal];
        [_serviceBTN.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_serviceBTN sizeToFit];
        [_serviceBTN verticalCenterImageAndTitle];
        [_serviceBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _serviceBTN;
}
- (CycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(380)) animationDuration:4];
        _cycleScrollView.backgroundColor=[UIColor grayColor];
        _cycleScrollView.pageControl.currentPageIndicatorTintColor = HEX_RGB(BASE_COLOR_HEX);
        _cycleScrollView.pageControl.pageIndicatorTintColor = kGrayColor;
    }
    return _cycleScrollView;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    if (webView.isLoading) {
        return;
    }

    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue]+20;
    
    if (_webViewHeight == 0 && height != 0) {
        
        _webViewHeight = height;
//        webView.height = height;
        
        CGRect frame = webView.frame;
        [webView setFrame:CGRectMake(0, 0, frame.size.width, _webViewHeight)];
        
        if (_webViewHeight > 0 ) {//刷新cell高度
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    }else if(_webViewHeight == 0 && height == 0){
        
//        NSString *js_fit_code = [NSString stringWithFormat:@"var meta = document.createElement('meta');"
//                                 "meta.name = 'viewport';"
//                                 "meta.content = \"height=device-height,width=device-width,initial-scale=1,maximum-scale=1,minimum-scale=1,user-scalable=no\";"
//                                 "document.getElementsByTagName('head')[0].appendChild(meta);"];
//        [webView stringByEvaluatingJavaScriptFromString:js_fit_code];
//        //拦截网页图片  并修改图片大小
//        [webView stringByEvaluatingJavaScriptFromString:
//         [NSString stringWithFormat:@"var script = document.createElement('script');"
//          "script.type = 'text/javascript';"
//          "script.text = \"function ResizeImages() { "
//          "var myimg,oldwidth;"
//          "var maxwidth=%f;"
//          "for(i=0;i <document.images.length;i++){"
//          "myimg = document.images[i];"
//          "if(myimg.width > maxwidth){"
//          "oldwidth = myimg.width;"
//          "myimg.width = maxwidth;"
//          "myimg.height = myimg.height * (maxwidth/oldwidth);"
//          "}"
//          "}"
//          "}\";"
//          "document.getElementsByTagName('head')[0].appendChild(script);" , SCREEN_WIDTH]];
//        
//        [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    }
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (tag == 8888) {//查看更多评论
        WeiMiMoreCommentVC *vc = [[WeiMiMoreCommentVC alloc] init];
        //        vc.popWithBaseNavColor = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.productId = self.productId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (sender == _buyBTN) {//立即购买
        WeiMiPurchaseGoodsVC *vc = [[WeiMiPurchaseGoodsVC alloc] init];
//        vc.popWithBaseNavColor = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.response = _res;
        vc.isBuy = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (sender == _addToChartBTN)//加入购物车
    {
        WeiMiPurchaseGoodsVC *vc = [[WeiMiPurchaseGoodsVC alloc] init];
//        vc.popWithBaseNavColor = YES;
        vc.hidesBottomBarWhenPushed = YES;
        vc.response = _res;
        [self.navigationController pushViewController:vc animated:YES];
//        WeiMiAddPurchaseChartModel *model = [[WeiMiAddPurchaseChartModel alloc] init];
//        model.productName = _res.dto.productName;
//        model.productType = _res.dto.proTypeId;
//        model.productBrand = _res.dto.brandId;
//        model.productImg = _res.dto.faceImgPath;
//        model.price = _res.dto.price;
//        model.number = @"1";
//        model.property = _res.dto.proTypeName;
//        model.memberId = [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
//        model.productId = _res.dto.productId;
//        model.isAble = @"1";
//        
//        [self addChart:model];
    }else if (sender == _collectBTN)//收藏
    {
        [self addCollection:self.productId];
    }else if (sender == _serviceBTN)//客服
    {
        [OHAlertView showAlertWithTitle:nil message:@"亲, 小二在线时间为9:00~21:00, 是否拨打电话捏？" cancelButton:@"拨打" otherButtons:@[@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[Routable sharedRouter] openExternal:@"tel://10086"];
            }
        }];
        
    }
}
//#pragma mark - NetWork
////--- 加入购物车
//- (void)addChart:(WeiMiAddPurchaseChartModel *)model
//{
//    
//    WeiMiAddPurchaseChartRequest *request = [[WeiMiAddPurchaseChartRequest alloc] initWithModel:model];
//    WS(weakSelf);
//    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
//     {
//         SS(strongSelf);
//         NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
//         if ([result isEqualToString:@"1"]) {
//             [strongSelf presentSheet:@"加入购物车成功"];
//         }else
//         {
//             [strongSelf presentSheet:@"加入购物车失败"];
//         }
//         
//     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//         
//         //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
//     }];
//}
//--- 添加收藏
- (void)addCollection:(NSString *)productId
{

    WeiMiCollectionAddRequest *request = [[WeiMiCollectionAddRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel entityId:productId isAble:@"1"];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         SS(strongSelf);
         NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
         if ([result isEqualToString:@"1"]) {
             [strongSelf presentSheet:@"收藏成功"];
         }else if([result isEqualToString:@"2"])
         {
             [strongSelf presentSheet:@"已收藏过了"];
         }else if ([result isEqualToString:@"0"])
         {
             [strongSelf presentSheet:@"收藏失败"];
         }
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         
         //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
     }];
}

/// 评论列表
- (void)getCommentListWithProductId:(NSString *)productId
{
    WeiMiProductCommentListRequest *request = [[WeiMiProductCommentListRequest alloc] initWithProductId:productId pageIndex:1 pageSize:5];
    WeiMiProductCommentListResponse *res = [[WeiMiProductCommentListResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [res parseResponse:request.responseJSONObject];
        if (res.dataArr.count) {
            [_commentDataSource addObjectsFromArray:res.dataArr];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//---- 宝贝详情
- (void)getProductDetail:(NSString *)productId
{
    if (!productId) {
        return;
    }
    WeiMiProductDetailRequest *request = [[WeiMiProductDetailRequest alloc] initWithProductId:productId];
    if (!_res) {
        _res = [[WeiMiProductDetailResponse alloc] init];
    }
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
    {
        SS(strongSelf);
        [_res parseResponse:request.responseJSONObject];
        [strongSelf deliverProductData:_res.dto imgFiles:_res.imageFiles];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

- (void)deliverProductData:(WeiMiHPProductListDTO *)dto imgFiles:(NSArray *)imgFiles
{
    
    [_imgDataSource addObjectsFromArray:imgFiles];
    
    _productInfoModel = [[WeiMiGoodDetailPriceModel alloc] init];
    _productInfoModel.price = dto.price;
    _productInfoModel.productName = dto.productName;
    _productInfoModel.salesVolume = dto.salesVolume;
    
    _present = dto.zengpin ? dto.zengpin :@"暂时没有赠品";
    
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSString *imge in imgFiles) {
        WeiMiHomePageBannerDTO *bannerDTO = [[WeiMiHomePageBannerDTO alloc] init];
        bannerDTO.bannerImgPath = imge;
        [tempArr addObject:bannerDTO];
    }
    [self loadAdvert:tempArr];

    [_tableView reloadData];
}

- (void)getBanner
{
    WeiMiBannerRequest *request = [[WeiMiBannerRequest alloc] init];
    WeiMiBannerResponse *res = [[WeiMiBannerResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        [self loadAdvert:res.dataArr];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", (long)request.responseStatusCode, request.responseString]];
    }];
}
/**
 *  图片轮播
 */
-(void)loadAdvert:(NSArray *)bannerArr
{
    WS(weakSelf);
    
    self.cycleScrollView.fetchContentViewAtIndex=^UIView *(NSInteger pageIndex){
        
        NSString *imageUrl = ((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerImgPath;
        UIImageView *imageview = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, weakSelf.cycleScrollView.width, weakSelf.cycleScrollView.height)];
        //        imageview.image = [UIImage imageNamed:@"followus_bg480x800"];
        NSString *str = WEIMI_IMAGEREMOTEURL(imageUrl);
        [imageview sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"followus_bg480x800 "]];
        return imageview;
    };
    
    self.cycleScrollView.totalPagesCount=^NSInteger(void){
        return bannerArr.count;
    };
    
    self.cycleScrollView.TapActionBlock=^(NSInteger pageIndex){
        
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1)
    {
        return 1;
    }else if (section == 2)
    {
        return _commentDataSource.count;
    }else if (section == 3)
    {
//        return _imgDataSource.count;
        return 1;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    WeiMiGoodDetailPriceCell
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        static NSString *cellID = @"cell_0_0";
        
        WeiMiGoodDetailPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiGoodDetailPriceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        [cell setViewWith:_productInfoModel];
        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
//        WeiMiPrivilegesCell
        static NSString *cellID = @"cell_0_1";
        
        WeiMiPrivilegesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiPrivilegesCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        cell.bottomTitleLabel.text = _present;
        return cell;
    }else if (indexPath.section == 1)
    {
        static NSString *cellID = @"cell_1";
        
        WeiMiGoodsDetailTagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiGoodsDetailTagCell alloc] initWithItemDic:@{
                                                                      @"正品保证":@"icon_zhengpin",
                                                                      @"七天包退":@"icon_baohuan",
                                                                      @"极致服务":@"icon_jizhifuwu",
                                                                      @"隐私包装":@"icon_yinsibaozhuang",
                                                                      } reuseIdentifier:cellID];
        }
    
        return cell;
    }
    else if (indexPath.section == 2)
    {
        static NSString *cellID = @"cell_2";
        
        WeiMiGoodsDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiGoodsDetailCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        [cell setViewWithDTO:safeObjectAtIndex(_commentDataSource, indexPath.row)];
        
        return cell;
    }
    
    static NSString *cellID = @"imgCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        [cell.contentView addSubview:self.picTextWevbView];
//        [_picTextWevbView mas_makeConstraints:^(MASConstraintMaker *make) {
//    
//            make.edges.mas_equalTo(cell);
//        }];
    }
    NSString *appendStr1 = [NSString stringWithFormat: @"<!DOCTYPE html><html><head><title></title><meta charset=\"utf-8\"><meta name=\"HandheldFriendly\" content=\"True\"><meta name=\"format-detection\" content=\"telephone=no\"><meta http-equiv=\"cleartype\" content=\"on\"><!-- meta viewport --><meta name=\"viewport\" content=\"width=device-width, minimum-scale=0.8, maximum-scale=1.0,initial-scale=1, user-scalable=no\"/><meta name=\"editor\" content=\"superman\"><style>img{max-width:%gpx !important;} p{max-width:%gpx !important;}</style></head><body>",SCREEN_WIDTH-15,SCREEN_WIDTH-15];
    NSString *appendStr2 = [NSString stringWithFormat:@"</body></html>"];
    NSString *showHtmlStr = [NSString stringWithFormat:@"%@%@%@",appendStr1,_res.dto.remark,appendStr2];
    [self.picTextWevbView loadHTMLString:showHtmlStr baseURL:[NSURL URLWithString:BASE_URL]];
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        return 65;
    }else if (indexPath.section == 1)
    {
        return 80;
    }else if (indexPath.section == 2)
    {
        return [WeiMiGoodsDetailCommentCell getHeightWithContent:safeObjectAtIndex(_commentDataSource, indexPath.row)];
    }else if (indexPath.section == 3)
    {
        return _webViewHeight;
    }
    return 55;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        static NSString *headerViewId = @"headerViewId";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
//        WeiMiGoodDetailHeader
        if (!headerView) {
            
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
            WeiMiGoodDetailHeader *header = [[WeiMiGoodDetailHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
            [headerView addSubview:header];
        }
        
        return headerView;
    }
    else if (section == 3)
    {
        static NSString *headerViewId = @"footerViewId_3";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        //        WeiMiGoodDetailHeader
        if (!headerView) {
            
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
            
            UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bindBtn.backgroundColor = kWhiteColor;
            bindBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            bindBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [bindBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
            [bindBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [bindBtn setTitle:@" 图文详情" forState:UIControlStateNormal];
            //            bindBtn.tag = 8888;
            //    [bindBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            //            [bindBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:bindBtn];
        }
        
        return headerView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        static NSString *headerViewId = @"footerViewId";
        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
        //        WeiMiGoodDetailHeader
        if (!headerView) {
            
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
            
            UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            bindBtn.backgroundColor = kWhiteColor;
            bindBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
            bindBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [bindBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
            [bindBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [bindBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];
            bindBtn.tag = 8888;
            //    [bindBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
            [bindBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:bindBtn];
        }
        
        return headerView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 60.5f;
    }else if (section == 3)
    {
        return 40.5f;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
 
    if (section == 2) {
        return 50;
    }
    return 10.0f;
//    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)updateViewConstraints
{
    [_serviceBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.centerY.mas_equalTo(_buyBTN);
    }];
    
    [_collectBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_serviceBTN.mas_right).offset(10);
        make.centerY.mas_equalTo(_buyBTN);
    }];
    
    [_buyBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.mas_equalTo(-5);
        make.size.mas_equalTo(CGSizeMake(40*2.1, 35));
    }];
    
    [_addToChartBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(_buyBTN.mas_left).offset(-10);
        make.centerY.mas_equalTo(_buyBTN);
        make.size.mas_equalTo(_buyBTN);
        
    }];

    [super updateViewConstraints];
}


@end
