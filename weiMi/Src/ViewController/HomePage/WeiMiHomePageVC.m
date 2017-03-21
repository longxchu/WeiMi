//
//  WeiMiHomePageVC.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomePageVC.h"
//--------- 3rd
#import "UIScrollView+_DScrollView.h"
#import "PYSearch.h"
//--------- view
#import "WeiMiBaseTableView.h"
#import "WeiMiHomeMenuCell.h"
#import "WeiMiGraceCell.h"
#import "WeiMiHorizonMenuCell.h"
#import "WeiMiWannaCell.h"
#import "WeiMiHotGoodsCell.h"
#import "WeiMiSearchBar.h"
#import "CycleScrollView.h"
#import "WeiMiPanicBuyItem.h"
//-------- vc
#import "WeiMiTryOutGroundVC.h"
#import "WeiMiGoodsDetailVC.h"
#import "WeiMiHomePageChoiceVC.h"
#import "WeiMiHomePageGoodsVC.h"
#import "WeiMiInvitationVC.h"
//#import "UIColor+WeiMiUIColor.h"
#import "WeiMiCommunityMessageVC.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>
#import "WeiMiWebViewController.h"
#import "WeiMiRefreshComponents.h"
//------- R&&Q
#import "WeiMiBannerRequest.h"
#import "WeiMiBannerResponse.h"
#import "WeiMiHPMenuRequest.h"
#import "WeiMiHPMenuResponse.h"
#import "WeiMiSearchProductRequest.h"
#import "WeiMiSearchProductResponse.h"
// 福利列表
#import "HPWealListModel.h"
//热卖商品
#import "WeiMiHPProductListRequest.h"
#import "WeiMiHPProductListResponse.h"
//------- DTO
#import "WeiMiHomePageBannerDTO.h"

@interface WeiMiHomePageVC()<UITableViewDelegate, UITableViewDataSource, WeiMiHomeMenuCellDelegate, WeiMiHotGoodsCellDelegate,
    WeiMiSearchBarDelegate, PYSearchViewControllerDelegate>
{
    NSMutableArray *_homeMenuTitleArr;
    NSMutableArray *_homeMenuImgArr;
    
    NSMutableArray *_horizonMenuTitleArr;
    NSMutableArray *_horizonMenuImgArr;
    NSMutableArray *_horizonMenuInfos;
    
    NSUInteger _downTime;
    
    NSMutableArray *_wannaCellItems;
    
    // 福利列表
    NSMutableArray *_homeWealArr;
    
    //热卖商品
    WeiMiHPProductListDTO *_hotSellerDTO_1;
    WeiMiHPProductListDTO *_hotSellerDTO_2;
    
    //限时抢购
    WeiMiHPProductListDTO *_panicBuyDTO;
    
    //搜索结果
    NSMutableArray<WeiMiHPProductListDTO *> *_searchResultArr;
    
    BOOL _isRefresh;//是否刷新
}

@property (nonatomic, strong) WeiMiSearchBar *searchBar;
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic,strong) CycleScrollView *cycleScrollView;


@end

@implementation WeiMiHomePageVC

- (instancetype)init
{
    if (self = [super init]) {
        
        _downTime = 59;

        _homeMenuTitleArr = [NSMutableArray new];
        _homeMenuImgArr = [NSMutableArray new];
        _homeWealArr = [NSMutableArray new];
        _horizonMenuTitleArr = [NSMutableArray new];
        _horizonMenuImgArr = [NSMutableArray new];
        _horizonMenuInfos = [NSMutableArray new];
//        WeiMiHPWannaDTO
        _wannaCellItems = [NSMutableArray new];
        
        _searchResultArr = [NSMutableArray new];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = self.searchBar;
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    [self.view setNeedsUpdateConstraints];
    
    [self.contentView addSubview:self.tableView];
    self.tableView.tableHeaderView = self.cycleScrollView;
    
    [self getWealList];
    [self getBeautyExperience];
    [self getBanner];
    [self getMenuItem];
    [self getHotSllers];
    [self getPanicBuy];
    //上拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        [_wannaCellItems removeAllObjects];
//        [_horizonMenuInfos removeAllObjects];
        [_horizonMenuImgArr removeAllObjects];
        [_horizonMenuTitleArr removeAllObjects];
        _isRefresh = YES;
        [self getWealList];
        [self getBeautyExperience];
        [self getBanner];
        [self getMenuItem];
        [self getHotSllers];
        [self getPanicBuy];
    }];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)initNavgationItem
{
    self.title = @"首页";
    [self AddLeftBtn:nil normal:@"icon_message" selected:@"icon_message'" action:^{

        [WeiMiPageSkipManager skipCommunityMessageSettingVC:self];
    }];
    
}

#pragma mark - Getter
- (WeiMiSearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[WeiMiSearchBar alloc] init];
        _searchBar.frame = CGRectMake(0, 0, 200 * (SCREEN_WIDTH/320) , 25);
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (WeiMiBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
        
    }
    return _tableView;
}

- (CycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView=[[CycleScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(330/2)) animationDuration:4];
        _cycleScrollView.backgroundColor=[UIColor grayColor];
        _cycleScrollView.pageControl.currentPageIndicatorTintColor = HEX_RGB(BASE_COLOR_HEX);
        _cycleScrollView.pageControl.pageIndicatorTintColor = kGrayColor;
    }
    return _cycleScrollView;
}


#pragma mark - NetWork
- (void)getBanner
{
    WeiMiBannerRequest *request = [[WeiMiBannerRequest alloc] initWithIsAble:@"1"];
    WeiMiBannerResponse *res = [[WeiMiBannerResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        [self loadAdvert:res.dataArr];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
//        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}
- (void)getBeautyExperience {
    WS(weakSelf);
    HPMRtiyanRequest *request = [[HPMRtiyanRequest alloc] init];
    HPMRtiyanResponse *response = [[HPMRtiyanResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        [response parseResponse:request.responseJSONObject];
        for (HPMRtiyanModel *model in response.dataArr) {
            [_horizonMenuTitleArr addObject:model.inforTitile];
            [_horizonMenuImgArr addObject:model.inforImg];
        }
        _horizonMenuInfos = [response.dataArr copy];
        
        [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
}
//---- 8个轮播
- (void)getMenuItem
{
    WeiMiHPMenuRequest *request = [[WeiMiHPMenuRequest alloc] init];
    WeiMiHPMenuResponse *res = [[WeiMiHPMenuResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        // 8个轮播
        for (WeiMiHPMenuDTO *dto in res.dataArr) {
            
            [_homeMenuTitleArr addObject:dto.menuName];
            [_homeMenuImgArr addObject:dto.menuImgPath];
            
            WeiMiHPWannaDTO *wannerDTO =[[WeiMiHPWannaDTO alloc] init];
            wannerDTO.title = dto.menuName;
            wannerDTO.navID = dto.menuId;
            [_wannaCellItems addObject:wannerDTO];
            
        }
        
//        for (NSString *string in _homeMenuTitleArr) {
//            
//            WeiMiHPWannaDTO *dto =[[WeiMiHPWannaDTO alloc] init];
//            dto.title = string;
//            dto
//            [_wannaCellItems addObject:dto];
//        }
        [_tableView reloadData];
//        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [_tableView.mj_header endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_header endRefreshing];
    }];
}
// --z 福利 列表
- (void)getWealList {
    HPWealListRequest *request = [[HPWealListRequest alloc] init];
    HPWealListResponse *response = [[HPWealListResponse alloc] init];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@" %@",request.responseJSONObject);
        NSDictionary *result = request.responseJSONObject;
        if (EncodeArrayFromDic(result, @"result").count) {
            [response parseResponse:result];
            if(response.dataArr.count != 0){
                _homeWealArr = [NSMutableArray arrayWithArray:response.dataArr];
            }
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"request error");
    }];
}
// -------- 热卖商品
- (void)getHotSllers
{
    WeiMiHPProductListRequestModel *model = [[WeiMiHPProductListRequestModel alloc] init];
    model.isAble = @"4";
    WeiMiHPProductListRequest *request = [[WeiMiHPProductListRequest alloc] initWithModel:model pageIndex:1 pageSize:2];
    WeiMiHPProductListResponse *res = [[WeiMiHPProductListResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
//        for (WeiMiHPProductListDTO *dto in res.dataArr) {
//            
//        }
        if (safeObjectAtIndex(res.dataArr, 0)) {
            _hotSellerDTO_1 = safeObjectAtIndex(res.dataArr, 0);
        }
        if (safeObjectAtIndex(res.dataArr, 1)) {
            _hotSellerDTO_2 = safeObjectAtIndex(res.dataArr, 1);
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//---- 限时抢购
- (void)getPanicBuy
{
    WeiMiHPProductListRequestModel *model = [[WeiMiHPProductListRequestModel alloc] init];
    model.isAble = @"3";
    WeiMiHPProductListRequest *request = [[WeiMiHPProductListRequest alloc] initWithModel:model pageIndex:1 pageSize:1];
    WeiMiHPProductListResponse *res = [[WeiMiHPProductListResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        //        for (WeiMiHPProductListDTO *dto in res.dataArr) {
        //
        //        }
        if (safeObjectAtIndex(res.dataArr, 0)) {
            _panicBuyDTO = safeObjectAtIndex(res.dataArr, 0);
        }
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

/// 获取搜索结果
- (void)getSearchResultWithSearchText:(NSString *)searchText searchController:(PYSearchViewController *)control
{
    WeiMiSearchProductRequest *request = [[WeiMiSearchProductRequest alloc] initWithProductName:searchText];
    WeiMiSearchProductResponse *res = [[WeiMiSearchProductResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        // 显示建议搜索结果
        NSMutableArray *searchSuggestionsM = [NSMutableArray array];
        for (WeiMiHPProductListDTO *dto in res.dataArr) {
            [searchSuggestionsM addObject:dto.productName];
        }
        // 返回
        control.searchSuggestions = searchSuggestionsM;
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}


#pragma mark - Util
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
        [imageview sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(imageUrl)] placeholderImage:WEIMI_PLACEHOLDER_COMMON];
        return imageview;
    };
    
    self.cycleScrollView.totalPagesCount=^NSInteger(void){
        return bannerArr.count;
    };
    
    self.cycleScrollView.TapActionBlock=^(NSInteger pageIndex){
        SS(strongSelf);
        [WeiMiPageSkipManager skipIntoWebVC:strongSelf title:@"链接" url:((WeiMiHomePageBannerDTO *)safeObjectAtIndex(bannerArr, pageIndex)).bannerUrl                                                                popWithBaseNavColor:YES];
    };
}

#pragma mark - Actions

#pragma mark - WeiMiSearchBarDelegate
- (BOOL)searchBarTextFieldShouldBeginEditing:(UITextField *)textField
{
    // 1.创建热门搜索
    NSArray *hotSeaches = @[@"超薄避孕套", @"延时", @"润滑液", @"无线跳蛋", @"飞机杯"];
    // 2. 创建控制器
    
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"搜索你感兴趣的商品" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        
    }];
    // 3. 设置风格
    searchViewController.hotSearchStyle = PYHotSearchStyleBorderTag; // 热门搜索风格根据选择
    searchViewController.searchHistoryStyle = PYHotSearchStyleDefault; // 搜索历史风格为default
    // 4. 设置代理
    searchViewController.delegate = self;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    [self presentViewController:nav  animated:NO completion:nil];
    return false;
}

#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    if (searchText.length) { // 与搜索条件再搜索
        
        [self getSearchResultWithSearchText:searchText searchController:searchViewController];
    }
}

/** 点击热门搜索时调用，如果实现该代理方法则点击热门搜索时searchViewController:didSearchWithsearchBar:searchText:失效*/
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectHotSearchAtIndex:(NSInteger)index searchText:(NSString *)searchText
{
    
}
/** 点击搜索历史时调用，如果实现该代理方法则搜索历史时searchViewController:didSearchWithsearchBar:searchText:失效 */
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchHistoryAtIndex:(NSInteger)index searchText:(NSString *)searchText
{
    
}
/** 点击搜索建议时调用，如果实现该代理方法则点击搜索建议时searchViewController:didSearchWithsearchBar:searchText:失效 */
- (void)searchViewController:(PYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndex:(NSInteger)index searchText:(NSString *)searchText
{
    WS(weakSelf);
    WeiMiHPProductListDTO *dto = safeObjectAtIndex(_searchResultArr, index);
    WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
    vc.productId = dto.productId;
    vc.popWithBaseNavColor = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [searchViewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - WeiMiHomeMenuCellDelegate
- (void)didSelectedItemAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row == 6) {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiNewestATVC" options:options];
    }else if (indexPath.row == 7)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiTryOutVC" options:options];
    }else
    {
        WeiMiHPWannaDTO *dto = safeObjectAtIndex(_wannaCellItems, indexPath.row);
        if (dto) {
            [WeiMiPageSkipManager skipIntoProductListVC:self title:dto.title menuId:dto.navID];
        }

    }
}

#pragma mark - WeiMiHotGoodsCellDelegate
- (void)didSelectedView:(WeiMiHotGoodsCell *)cell atIndex:(NSUInteger)idx
{
    if (idx == 0) {//限时抢购
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiPanicBuyContentVC" options:options];
    }else if (idx == 2)//热卖商品
    {

        WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
        vc.productId = _hotSellerDTO_1.productId;
        vc.popWithBaseNavColor = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (idx == 3)//热卖商品_2
    {
        
        WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
        vc.productId = _hotSellerDTO_2.productId;
        vc.popWithBaseNavColor = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (idx == 4)//热卖商品_3
    {
        
        WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
        vc.productId = _hotSellerDTO_2.productId;
        vc.popWithBaseNavColor = YES;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
//    else if (idx == 1)
//    {
////        UPRouterOptions *options = [UPRouterOptions routerOptions];
////        options.hidesBottomBarWhenPushed = YES;
////        [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiPurchaseGoodsVC" options:options];
//        WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
//        vc.popWithBaseNavColor = YES;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_wannaCellItems.count) {
        return 2;
    }
    return _wannaCellItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 4;
            break;
        case 1:
            return 1;
            
        default:
            return 1;
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WS(weakSelf);
    if (indexPath.section == 0 && indexPath.row == 0) {
        static NSString *cellID = @"homeMenuCell";
        WeiMiHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiHomeMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        [cell addObjects:_homeMenuTitleArr images:_homeMenuImgArr];
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 1)
    {
        static NSString *cellID = @"graceCell";
        WeiMiGraceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSLog(@"%ld",_homeWealArr.count);
        if (!cell) {
            cell = [[WeiMiGraceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.clickImgHandler = ^
//            {
//                WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
//                vc.popWithBaseNavColor = YES;
//                vc.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:vc animated:YES];
//            };
            
            cell.clickLabelHandler = ^(NSInteger idx)
            {
                HPWealListModel *model = [_homeWealArr objectAtIndex:idx-101];
                SS(strongSelf);
                [WeiMiPageSkipManager skipIntoWebVC:strongSelf title:model.aboutTitle url:model.aboutContext                                                                popWithBaseNavColor:YES];
            };
        }
        NSMutableArray *titleArrs = [[NSMutableArray alloc] initWithCapacity:0];
        for (HPWealListModel *model in _homeWealArr) {
            [titleArrs addObject:model.aboutTitle];
        }
        cell.titleArr = titleArrs;
        return cell;
    }
    else if (indexPath.section == 0 && indexPath.row == 2)//限时抢购
    {
        static NSString *cellID = @"panicBuyingCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.backgroundColor = [UIColor colorWithPatternImage:WEIMI_IMAGENAMED(@"pannicBuy.png")];
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.image = WEIMI_IMAGENAMED(@"pannicBuy.png");
            cell.backgroundView = imageView;
        }
    
        return cell;
        
//        static NSString *cellID = @"hotGoodsCell";
//        WeiMiHotGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
////        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        if (!cell) {
//            cell = [[WeiMiHotGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.delegate = self;
//        }
//        
//        [cell.priceGoodView setViewWithPrice:_panicBuyDTO.price img:_panicBuyDTO.faceImgPath];
//        [cell.rightImageView sd_setBackgroundImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(_hotSellerDTO_1.faceImgPath)] forState:UIControlStateNormal placeholderImage:WEIMI_PLACEHOLDER_RECT];
//        [cell.rightImageView_2 sd_setBackgroundImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(_hotSellerDTO_2.faceImgPath)] forState:UIControlStateNormal placeholderImage:WEIMI_PLACEHOLDER_RECT];
//        [cell.rightImageView_3 sd_setBackgroundImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(_hotSellerDTO_3.faceImgPath)] forState:UIControlStateNormal placeholderImage:WEIMI_PLACEHOLDER_RECT];
//        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 3)//热卖商品
    {
        static NSString *cellID = @"hotCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(weakSelf);
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            //最左侧图
            UIImageView *leftImageView = [[UIImageView alloc] init];
            leftImageView.tag = 666;
            leftImageView.image = WEIMI_IMAGENAMED(@"hot_goods.png");
            [cell.contentView addSubview:leftImageView];
            
            WeiMiPanicBuyItem *itemMid = [[WeiMiPanicBuyItem alloc] init];
            itemMid.tag = 777;
            itemMid.onItemHandler = ^(NSString *productId){
                SS(strongSelf);
                [WeiMiPageSkipManager skipIntoProductDetailVC:strongSelf productId:productId popWithBaseNavColor:YES hidesBottomBarWhenPushed:YES];
            };
            [cell.contentView addSubview:itemMid];
            
            
            WeiMiPanicBuyItem *itemRight = [[WeiMiPanicBuyItem alloc] init];
            itemRight.tag = 888;
            itemRight.onItemHandler =  ^(NSString *productId){
                SS(strongSelf);
                [WeiMiPageSkipManager skipIntoProductDetailVC:strongSelf productId:productId popWithBaseNavColor:YES hidesBottomBarWhenPushed:YES];
            };
            [cell.contentView addSubview:itemRight];
            
            [@[leftImageView, itemMid, itemRight] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
            [@[leftImageView, itemMid, itemRight] mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.mas_equalTo(0);
            }];
        }
        
        UIImageView *leftImageView = [cell viewWithTag:666];
        if (leftImageView) {
            
        }
        WeiMiPanicBuyItem *itemMid = [cell viewWithTag:777];
        if (itemMid) {
            [itemMid setViewWithDTO:_hotSellerDTO_1];
        }
        
        WeiMiPanicBuyItem *itemRight = [cell viewWithTag:888];
        if (itemRight) {
            [itemRight setViewWithDTO:_hotSellerDTO_2];
        }

        return cell;
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        static NSString *cellID = @"horizonMenuCell";
        WeiMiHorizonMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!cell) {
            cell = [[WeiMiHorizonMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            WS(weakSelf);
            cell.onMoreBTN = ^{
                SS(strongSelf);
                WeiMiTryOutGroundVC *vc = [[WeiMiTryOutGroundVC alloc] init];
                vc.popWithBaseNavColor = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
            
            cell.onItem = ^(NSInteger idx)
            {
                SS(strongSelf);
                HPMRtiyanModel *model = _horizonMenuInfos[idx];
                WeiMiInvitationVC *vc = [[WeiMiInvitationVC alloc] init];
                vc.isFromMRtiyan = YES;
                vc.hidesBottomBarWhenPushed = YES;
                vc.popWithBaseNavColor = YES;
                vc.infoId = model.infoId;
                [strongSelf.navigationController pushViewController:vc animated:YES];
            };
        }
        [cell addObjects:_horizonMenuTitleArr images:_horizonMenuImgArr];

        return cell;
    }
    
    NSString *cellID = [NSString stringWithFormat:@"wannaCell_%ld", (long)indexPath.section];
    WeiMiWannaCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiWannaCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(weakSelf);
        cell.onWannCellMoreBTN = ^(NSString *navId, NSString *title){
            SS(strongSelf);
            
//            WeiMiHomePageGoodsVC *vc = [[WeiMiHomePageGoodsVC alloc] init];
//            vc.popWithBaseNavColor = YES;
//            vc.hidesBottomBarWhenPushed = YES;
//            vc.navId = navId;
//            vc.title = title;
//            [strongSelf.navigationController pushViewController:vc animated:YES];
            [weakSelf didSelectedItemAtIndex:[NSIndexPath indexPathForRow:indexPath.section-2 inSection:0]];
        };
        
        cell.onWannCellItem = ^(NSString * productId)
        {
            SS(strongSelf);
            if ([productId isEqualToString:@""]) {
                [strongSelf presentSheet:@"啊哦，该商品不存在啦"];
                return;
            }
            //跳转至宝贝详情
            [WeiMiPageSkipManager skipIntoProductDetailVC:self productId:productId popWithBaseNavColor:YES hidesBottomBarWhenPushed:YES];
        };
        
        cell.onWannCellBannerHandler = ^(NSString *bannerUrl){
            if ([bannerUrl isEqualToString:@""] || nil == bannerUrl) {
                return;
            }
            [WeiMiPageSkipManager skipIntoWebVC:self title:@"链接" url:bannerUrl popWithBaseNavColor:YES];
        };

    }
    if (_isRefresh) {
        [cell setViewWithDTO:safeObjectAtIndex(_wannaCellItems, indexPath.section - 2) isFresh:YES];
        if (indexPath.section == _wannaCellItems.count - 1) {
            _isRefresh = NO;
        }
    }else{
        [cell setViewWithDTO:safeObjectAtIndex(_wannaCellItems, indexPath.section - 2) isFresh:NO];
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return 350/2;
            }else if (indexPath.row == 1){
                return 43;
            }else if (indexPath.row == 2)
            {
                return self.view.width*0.31;
            }else if (indexPath.row == 3){
                return self.view.width/3;
            }
        }
            break;
        case 1:
        {
            return 320/2;
        }
            
        default:
            return [WeiMiWannaCell getHeight:safeObjectAtIndex(_wannaCellItems, indexPath.section - 2)];
            break;
    }

    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == [tableView numberOfSections] - 1) {
        return 0.1f;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 2) {//限时抢购
        [WeiMiPageSkipManager skipIntoPannicBuyVCHiddenBottomBar:YES];
    }
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

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)dealloc
{
}

@end
