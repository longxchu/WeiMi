//
//  WeiMiHomePageChoiceVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomePageChoiceVC.h"
#import "WeiMiHomePageGoodsCell.h"
#import "JSDropDownMenu.h"
#import "WeiMiHomePageChoiceTagCollectView.h"
#import "WeiMiRefreshComponents.h"
#import "WeiMiNotifiEmptyView.h"

#import "WeiMiGoodsDetailVC.h"
//----- request
#import "YTKChainRequest.h"
#import "WeiMiHPCategoryRequest.h"
#import "WeiMiHPCategoryResponse.h"
#import "WeiMiHPBrandRequest.h"
#import "WeiMiHPBrandResponse.h"
#import "WeiMiRandomRecommandRequest.h"
#import "WeiMiRandomRecommandResponse.h"
#import "WeiMiHPProductListRequest.h"
#import "WeiMiHPProductListResponse.h"

static NSString  *kCellID = @"cellID";
static NSString  *kHeaderID = @"headerID";

typedef NS_ENUM(NSInteger, SORTTYPE) {
    SORTTYPE_POPULAR = 0,//人气
    SORTTYPE_NEW = 1,//新品
    SORTTYPE_PRICE_ASC = 2,//价格升序
    SORTTYPE_PRICE_DESC = 3,//价格降序
    SORTTYPE_FLITER_CATE = 4,//分类排序
    SORTTYPE_FLITER_BRAND = 5,//品牌排序
};

@interface WeiMiHomePageChoiceVC ()
<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,JSDropDownMenuDataSource,JSDropDownMenuDelegate,YTKChainRequestDelegate>
{
//    NSMutableArray *_dataSource;
    
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSMutableArray *_data4;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData4Index;
    //右侧tableIndex
    NSInteger _currentData4RightIndex;
    
    //当前刷新页面数
    __block NSInteger _currentPage;
    NSString *_brandId;//品牌ID
    NSString *_proTypeId;//分类ID
    
    //价格 便宜到贵
    BOOL _isUpPrice;
    NSInteger _currentSelectedMenuIndex;//当前选中的menu下标志
    SORTTYPE _sortType;
    NSArray *_sortParams;//排序参数
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JSDropDownMenu *menu;

@property (nonatomic, strong) WeiMiNotifiEmptyView *notiEmptyView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WeiMiHomePageChoiceVC

- (instancetype)init
{
    if (self = [super init]) {
        _isUpPrice = YES;
        _dataSource = [NSMutableArray new];
        
        _data4 = [NSMutableArray new];
        _currentPage = 1;
        _currentSelectedMenuIndex = -1;
        _currentData4RightIndex = -1;
        _sortParams = @[@"cishu desc",
                        @"productId desc",
                        @"price asc",
                        @"price desc"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xC5C9C2);
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.menu];
    [self.contentView addSubview:self.collectionView];
    //    self.collectionView.frame = self.contentFrame;
    [self.contentView addSubview:self.notiEmptyView];
    self.notiEmptyView.hidden = YES;

    [self getCatregoryList];
    
    _collectionView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        switch (_sortType) {
//            case SORTTYPE_POPULAR:
//            {
//                
//            }
//                break;
//            case SORTTYPE_NEW:
//            {
//                
//            }
//                break;
//            case SORTTYPE_PRICE_ASC:
//            {
//                
//            }
//                break;
//            case SORTTYPE_PRICE_DESC:
//            {
//                
//            }
//                break;
            case SORTTYPE_FLITER_CATE:
            {
                [self getRandomProductWithIsAble:[NSString stringWithFormat:@"%ld", _currentPage*10] brandId:nil proTypeId:_proTypeId isRefresh:YES];
            }
                break;
            case SORTTYPE_FLITER_BRAND:
            {
                [self getRandomProductWithIsAble:[NSString stringWithFormat:@"%ld", _currentPage*10] brandId:_brandId proTypeId:nil isRefresh:YES];
            }
                break;
                
            default:
            {
                [self getProductsWithSortType:_sortType pageIndex:_currentPage isRefresh:YES];
            }
                break;
        }

    }];
    
//    [self getRandomProductWithIsAble:@"10" brandId:nil proTypeId:nil isRefresh:NO];
    
    [self getProductsWithSortType:_sortType pageIndex:1 isRefresh:NO];
    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"dataSource"];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
//    self.title = @"套套";
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        layout.itemSize = CGSizeMake((self.view.width - 30)/2, self.view.width/2 * 1.49f);
        layout.itemSize = CGSizeMake((self.view.width - 30)/2, (self.view.width - 30)/2 + 90);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delaysContentTouches = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[WeiMiHomePageGoodsCell class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[WeiMiHomePageChoiceTagCollectView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderID];
    }
    return _collectionView;
}

//----  提示空视图
- (WeiMiNotifiEmptyView *)notiEmptyView
{
    if (!_notiEmptyView) {
        _notiEmptyView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiEmptyView setViewWithImg:@"icon_list" title:@"暂时没有结果哦"];
    };
    return _notiEmptyView;
}

- (JSDropDownMenu *)menu
{
    if (!_menu) {
        
        _menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, NAV_HEIGHT + STATUS_BAR_HEIGHT) andHeight:45];
        _menu.backgroundColor = [UIColor whiteColor];
        _menu.indicatorColor = [UIColor clearColor];
        _menu.separatorColor = [UIColor clearColor];
        _menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
        _menu.dataSource = self;
        _menu.delegate = self;
    }
    return _menu;
}
#pragma mark - Network
// --------人气 新品 价格三者数据
- (void)getProductsWithSortType:(SORTTYPE)sortType pageIndex:(NSInteger)pageIndex isRefresh:(BOOL)refresh
{
    if (!refresh) {
        _currentPage = 1;
    }
    WeiMiHPProductListRequestModel *model = [[WeiMiHPProductListRequestModel alloc] init];
    model.isAble = @"1";
    model.menuId = self.menuId;
    model.strSort = safeObjectAtIndex(_sortParams, sortType);
    WeiMiHPProductListRequest *request = [[WeiMiHPProductListRequest alloc] initWithModel:model pageIndex:pageIndex pageSize:10];
    WeiMiHPProductListResponse *res = [[WeiMiHPProductListResponse alloc] init];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        if (!refresh) {//不是刷新而是切换需要清空dataSource
            [[self mutableArrayValueForKey:@"dataSource"] removeAllObjects];
            [strongSelf.collectionView reloadData];

        }
        [res parseResponse:request.responseJSONObject];
        if (res.dataArr.count) {


            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:res.dataArr];
            [strongSelf.collectionView reloadData];
            _currentPage ++;
        }else
        {
            [_collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        [_collectionView.mj_footer endRefreshing];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [_collectionView.mj_footer endRefreshing];

        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//获取随机推荐数据
- (void)getRandomProductWithIsAble:(NSString *)isAble brandId:(NSString *)brandId proTypeId:(NSString *)proTypeId isRefresh:(BOOL)refresh
{
    if (!refresh) {
        _currentPage = 1;
    }
    WeiMiRandomRecommandRequest *request = [[WeiMiRandomRecommandRequest alloc] initWithIsAble:isAble brandId:brandId proTypeId:proTypeId];
    WeiMiRandomRecommandResponse *res = [[WeiMiRandomRecommandResponse alloc] init];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SS(strongSelf);
        [[self mutableArrayValueForKey:@"dataSource"] removeAllObjects];

        NSArray *array = EncodeArrayFromDic(request.responseJSONObject, @"result");
        if (array.count) {
            
            [res parseResponse:request.responseJSONObject];
            
            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:res.dataArr];
            _currentPage ++;
        }
        [strongSelf.collectionView reloadData];

        [_collectionView.mj_footer endRefreshing];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_collectionView.mj_footer endRefreshing];

    }];
}

//获得筛选列表
- (void)getCatregoryList
{
    //分类
    WeiMiHPCategoryRequest *cateRequest = [[WeiMiHPCategoryRequest alloc] init];
    WeiMiHPCategoryResponse *cateResponse = [[WeiMiHPCategoryResponse alloc] init];
    //品牌
    WeiMiHPBrandRequest *brandRequest = [[WeiMiHPBrandRequest alloc] init];
    WeiMiHPBrandResponse *brandResponse = [[WeiMiHPBrandResponse alloc] init];

    WS(weakSelf);
    YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
    [chainRequest addRequest:cateRequest callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        SS(strongSelf);
        WeiMiHPCategoryRequest *req = (WeiMiHPCategoryRequest *)baseRequest;
        NSInteger count = EncodeArrayFromDic(req.responseJSONObject, @"result").count;
        if (count) {
            [cateResponse parseResponse:req.responseJSONObject];
            [strongSelf addCate:cateResponse];
        }
        
        //发送品牌请求
        [chainRequest addRequest:brandRequest callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
            
            WeiMiHPBrandRequest *req = (WeiMiHPBrandRequest *)baseRequest;
            NSInteger count = EncodeArrayFromDic(req.responseJSONObject, @"result").count;
            if (count) {
                [brandResponse parseResponse:req.responseJSONObject];
                [strongSelf addBrand:brandResponse];
            }
            
        }];
    }];
    
    chainRequest.delegate = self;
    // start to send request
    [chainRequest start];
}

#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    id _oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    id _newValue = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (![_newValue isEqual:_oldValue])
    {
        //有变动
        if ([keyPath isEqualToString:@"dataSource"]) {
            if (_dataSource.count == 0) {
                _notiEmptyView.hidden = NO;
            }else
            {
                _notiEmptyView.hidden = YES;
            }
            return;
        }
    }
}


#pragma mark - Actions
- (void)addCate:(WeiMiHPCategoryResponse *)response
{
    NSMutableArray *cateArr = [NSMutableArray new];
    for (WeiMiHPCategoryDTO *dto in response.dataArr) {
        [cateArr addObject:dto];
    }
    [_data4 addObject:@{@"title":@"分类", @"data":cateArr}];
}

- (void)addBrand:(WeiMiHPBrandResponse *)response
{
    NSMutableArray *brandArr = [NSMutableArray new];
    for (WeiMiHPBrandDTO *dto in response.dataArr) {
        [brandArr addObject:dto];
    }
    [_data4 addObject:@{@"title":@"品牌", @"data":brandArr}];
}

#pragma mark - YTKChainRequest Delegate
- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    // all requests are done
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
}
#pragma mark - Actions

#pragma mark - 数据源方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeiMiHomePageGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//    
//    if (kind == UICollectionElementKindSectionHeader) {
//        WeiMiHomePageChoiceTagCollectView * view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderID forIndexPath:indexPath];
//        [view addObjects:@[@"冈本", @"durex",@"冈本", @"durex",@"冈本", @"durex",@"冈本", @"durex"]];
//        reusableview = view;
//    }
//    return reusableview;
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
//    UPRouterOptions *options = [UPRouterOptions routerOptions];
//    options.hidesBottomBarWhenPushed = YES;
//    
//    [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiGoodsDetailVC" options:options];
    NSString *productId = ((WeiMiHPProductListDTO *)safeObjectAtIndex(_dataSource, indexPath.row)).productId;
    WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
    vc.productId = productId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionViewDelegateFlowLayout
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
//{
//    return CGSizeMake(SCREEN_WIDTH, 160);
//}

#pragma mark - JSDropDownMenuDataSource,JSDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu {
    
    return 4;
}

-(BOOL)displayByCollectionViewInColumn:(NSInteger)column{
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column{
    
    if (column==3) {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column{
    
    if (column==3) {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column{
 
    switch (column) {
        case 0:
            return _currentData1Index;
            break;
        case 1:
            return _currentData2Index;
            break;
        case 2:
            return _currentData3Index;
            break;
        case 3:
            return _currentData4Index;
            break;
        default:
            break;
    }
    
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow{
    
    if (column==3) {
        if (leftOrRight==0) {
            
            return _data4.count;
        } else{
            
            NSDictionary *menuDic = [_data4 objectAtIndex:leftRow];
            if (!menuDic.count) {
                return 0;
            }
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==0){
        
        return 0;
        
    } else if (column==1){
        
        return 0;
    } else if (column==2){
        
        return 0;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column{
    
    switch (column) {
        case 3: return @"筛选";
            break;
        case 2: return @"价格";
            break;
        case 1: return @"新品";
            break;
        case 0: return @"人气";
            break;
        default:
            return nil;
            break;
    }
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column==3) {
        if (indexPath.leftOrRight==0) {
            NSDictionary *menuDic = [_data4 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else{
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data4 objectAtIndex:leftRow];
            WeiMiBaseDTO *dto = [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
            if ([dto isKindOfClass:[WeiMiHPCategoryDTO class]]) {

                return ((WeiMiHPCategoryDTO *)dto).proTypeName;
            }else if ([dto isKindOfClass:[WeiMiHPBrandDTO class]])
            {
                return ((WeiMiHPBrandDTO *)dto).brandName;
            }
        }
    } else if (indexPath.column==0) {
        
        return _data1[indexPath.row];
        
    } else if (indexPath.column==1) {
        
        return _data2[indexPath.row];
    } else if (indexPath.column==2) {
        
        return _data3[indexPath.row];
    }
    return 0;
}

//点击了Menu
- (void)menu:(JSDropDownMenu *)menu didSelectMenuAtIndex:(NSInteger)index
{
    
    if (index == _currentSelectedMenuIndex || index == 3) {//点击重复和点击筛选不加载
        return;
    }
    _currentPage = 1;
    
    if (index == 0) {
        
        _sortType = SORTTYPE_POPULAR;
    }else if (index == 1) {
        _sortType = SORTTYPE_NEW;

    }else if (index == 2) {
        _isUpPrice = !_isUpPrice;
        
        _sortType = _isUpPrice ? SORTTYPE_PRICE_ASC:SORTTYPE_PRICE_DESC;
    }
    [self getProductsWithSortType:_sortType pageIndex:_currentPage isRefresh:NO];
}

- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath {
    
    if (indexPath.column == 3) {
        
        if(indexPath.leftOrRight==0){//点击了左侧tableCell
            
            _currentData4Index = indexPath.row;
            
            return;
        }else if (indexPath.leftOrRight==1)//点击了右侧tableCell
        {
            if (_currentData4Index == indexPath.leftRow && _currentData4RightIndex == indexPath.row) {
                return;
            }
            _currentData4RightIndex = indexPath.row;
            NSDictionary *dic = safeObjectAtIndex(_data4, _currentData4Index);
            NSString *_title = EncodeStringFromDic(dic, @"title");
            NSArray *dataArr = EncodeArrayFromDic(dic, @"data");
            if ([_title isEqualToString:@"分类"]) {
                _sortType = SORTTYPE_FLITER_CATE;
                WeiMiHPCategoryDTO *dto = (WeiMiHPCategoryDTO *)safeObjectAtIndex(dataArr, indexPath.row);
                [self getRandomProductWithIsAble:@"10" brandId:nil proTypeId:dto.proTypeId isRefresh:NO];
            }else if ([_title isEqualToString:@"品牌"]) {
                _sortType = SORTTYPE_FLITER_BRAND;
                WeiMiHPBrandDTO *dto = (WeiMiHPBrandDTO *)safeObjectAtIndex(dataArr, indexPath.row);
                [self getRandomProductWithIsAble:@"10" brandId:dto.brandId proTypeId:nil isRefresh:NO];
            }

        }
        
    } else if(indexPath.column == 0){
        
        _currentData1Index = indexPath.row;
        
    } else if(indexPath.column == 1){
        
        _currentData2Index = indexPath.row;
        
    } else{
        
        _currentData3Index = indexPath.row;
    }
}

- (void)updateViewConstraints
{
    [_notiEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(GetAdapterHeight(200));
    }];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_menu.mas_bottom).offset(1);
    }];
    [super updateViewConstraints];
    
}

@end
