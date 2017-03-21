//
//  WeiMiShoppingCartVC.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiShoppingCartVC.h"
#import "WeiMiShopBottomBar.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiShopCartCell.h"
#import "WeiMiSystemInfo.h"
#import "WeiMiCommonHeader.h"
#import "WeiMiWellSaleGoodsCell.h"
#import <OHAlertView.h>
#import "WeiMiNotifiEmptyView.h"
#import "WeiMiCommunityMessageVC.h"

#import "WeiMiRefreshComponents.h"

//----- request
#import "WeiMiMyChartListRequest.h"
#import "WeiMiMyChartListResponse.h"
#import "WeiMiUpdateChartNumRequest.h"
#import "WeiMiDeleteChartRequest.h"
//热卖商品
#import "WeiMiHPProductListRequest.h"
#import "WeiMiHPProductListResponse.h"

/** DTO */
#import "WeiMiShoppingCartDTO.h"

#import "WeiMiUserCenter.h"

static NSString *kReuseViewID = @"reuseViewID";
static NSString *kCellID = @"cellID";

static const NSInteger kRandomNum = 3;
@interface WeiMiShoppingCartVC()<UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    /* 是否全选 购物篮*/
    __block BOOL _selectedAll;
    __block NSInteger _currentPage;

}
@property (nonatomic, strong) WeiMiShopBottomBar *toolBar;
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, assign) __block double totalPrice;
@property (nonatomic, assign) __block NSUInteger selectedNum;
@property (nonatomic, strong) NSMutableArray *dataSource;
/** 热卖商品 */
@property (nonatomic, strong) NSMutableArray *hotGoodDataSource;
@property (nonatomic, strong) NSMutableArray *cacheHotGoodDataSource;
@property (nonatomic, assign)  __block NSInteger randomHotIdx;//热卖随机ID
/**
 空购物车
 */
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;
//@property (nonatomic, strong) UIImageView *emptyImageView;
//@property (nonatomic, strong) UILabel *emptyLabel;
@property (nonatomic, strong) UIButton *emptyButton;
@property (nonatomic, strong) UICollectionView *hotGoodsCollection;
@property (nonatomic, strong) WeiMiCommonHeader *headerView;

@end

@implementation WeiMiShoppingCartVC

- (instancetype)init
{
    if (self = [super init]) {
        _currentPage = 1;

        _hotGoodDataSource = [[NSMutableArray alloc] init];
        _cacheHotGoodDataSource = [[NSMutableArray alloc] init];
        _totalPrice = 0.0f;
//        WeiMiShoppingCartDTO *dto = [[WeiMiShoppingCartDTO alloc] init];
//        [_hotGoodDataSource addObjectsFromArray:@[dto, dto,dto]];
        
        self.dataSource = [[NSMutableArray alloc] init];
        if (IOS7_OR_LATER) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
            _selectedAll = NO;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.toolBar];
    [self.contentView addSubview:self.tableView];
    
    [self.view addSubview:self.notiView];
//    [self.view addSubview:self.emptyButton];
    [self.view addSubview:self.hotGoodsCollection];
    [self.view addSubview:self.headerView];
    [self changeToEmptyShoppingCart:YES];
    if(self.isFromeGoodDetails){
        [self initNavgationItem];
    }
    
    [self addObserver:self forKeyPath:@"totalPrice" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:NULL];
    [self addObserver:self forKeyPath:@"selectedNum" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:NULL];
    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getShoppingChart];
    }];
    
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        [_dataSource removeAllObjects];
        _currentPage = 1;
        [self getShoppingChart];
    }];
//    [self getShoppingChart];
    [self getHotSllers];
    [self.view setNeedsUpdateConstraints];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //上拉刷新
    [_dataSource removeAllObjects];
    _currentPage = 1;
    [self getShoppingChart];
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"totalPrice"];
    [self removeObserver:self forKeyPath:@"selectedNum"];
    [self removeObserver:self forKeyPath:@"dataSource"];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if(self.isFromeGoodDetails){
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;
}

- (void)initNavgationItem
{
    self.title = @"购物车";
    WS(weakSelf);
    if(self.isFromeGoodDetails){
        [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
            SS(strongSelf);
            [strongSelf BackToLastNavi];
        }];
        return;
    }
    [self AddLeftBtn:nil normal:@"icon_message" selected:@"icon_message'" action:^{
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMessageVC" options:options];
        
        WeiMiCommunityMessageVC *vc = [[WeiMiCommunityMessageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

#pragma Getter
- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"icon_heart" title:@"购物车空空如也哦亲"];
    }
    return _notiView;
}

- (UICollectionView *)hotGoodsCollection
{
    if (!_hotGoodsCollection) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(self.view.width/3, self.view.width/3 + 60);
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 5, 5);
//        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, GetAdapterHeight(40));

        _hotGoodsCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _hotGoodsCollection.delegate = self;
        _hotGoodsCollection.dataSource = self;
        _hotGoodsCollection.scrollEnabled = NO;
        _hotGoodsCollection.backgroundColor = [UIColor whiteColor];
        _hotGoodsCollection.delaysContentTouches = NO;
        _hotGoodsCollection.showsVerticalScrollIndicator = NO;
        [_hotGoodsCollection registerClass:[WeiMiWellSaleGoodsCell class] forCellWithReuseIdentifier:kCellID];
        [_hotGoodsCollection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewID];
    }
    return _hotGoodsCollection;
}

- (WeiMiCommonHeader *)headerView
{
    if (!_headerView) {
        
        _headerView = [[WeiMiCommonHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _headerView.backgroundColor = kWhiteColor;
        WS(weakSelf);
        _headerView.onChangeBtnHandler = ^{
            SS(strongSelf);
            if (strongSelf.cacheHotGoodDataSource.count <= kRandomNum) {
                [strongSelf presentSheet:@"没有更多数据啦"];
                return;
            }
            [strongSelf.hotGoodDataSource removeAllObjects];
            
            NSInteger changeNum = strongSelf.cacheHotGoodDataSource.count/kRandomNum + ((strongSelf.hotGoodDataSource.count % kRandomNum) == 0 ? 0 : 1);//总共可以转换的次数
            NSInteger currentNum = strongSelf.randomHotIdx % changeNum + 1;//当前转换id
            strongSelf.randomHotIdx ++;
            
            [strongSelf.cacheHotGoodDataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx >= (currentNum -1)*kRandomNum && idx < currentNum * kRandomNum) {
                    [strongSelf.hotGoodDataSource addObject:obj];
                }
            }];
            [strongSelf.hotGoodsCollection reloadData];
        };
        [_headerView setTitle:@"热卖商品"];
    }
    return _headerView;
}


- (UIButton *)emptyButton
{
    if (!_emptyButton) {
        
        _emptyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _emptyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_emptyButton setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_emptyButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_emptyButton setBackgroundColor:HEX_RGB(BASE_COLOR_HEX)];
        _emptyButton.layer.masksToBounds = YES;
        _emptyButton.layer.cornerRadius = 3.0f;
        [_emptyButton addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emptyButton;
}

- (WeiMiShopBottomBar *)toolBar
{
    if (!_toolBar) {
        WS(weakSelf);
        _toolBar = [[WeiMiShopBottomBar alloc] init];
        _toolBar.onSelectAll = ^{
            _selectedAll = !_selectedAll;
            weakSelf.selectedNum = 0;
            weakSelf.totalPrice = 0.0f;
            [weakSelf.tableView reloadData];
        };
    }
    return _toolBar;
}

- (WeiMiBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Network
//---- 购物车列表
- (void)getShoppingChart
{
    if (_currentPage > 1) {
        [_tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    WeiMiMyChartListRequest *request = [[WeiMiMyChartListRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:1];
    WeiMiMyChartListResponse *response = [[WeiMiMyChartListResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:response.dataArr];
            
            [strongSelf.tableView reloadData];
            weakSelf.selectedNum = 0;
            weakSelf.totalPrice = 0.0f;
            _currentPage ++;
            [_tableView.mj_footer endRefreshing];
        }else {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
        
    }];
}

// -------- 热卖商品
- (void)getHotSllers
{
    if (_cacheHotGoodDataSource.count) {
        return;
    }
    WeiMiHPProductListRequestModel *model = [[WeiMiHPProductListRequestModel alloc] init];
    model.isAble = @"4";
    WeiMiHPProductListRequest *request = [[WeiMiHPProductListRequest alloc] initWithModel:model pageIndex:1 pageSize:18];
    WeiMiHPProductListResponse *res = [[WeiMiHPProductListResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [res parseResponse:request.responseJSONObject];
        
        if (res.dataArr.count) {
            [_hotGoodDataSource addObjectsFromArray:res.dataArr];
        }
        [self.hotGoodsCollection reloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//------ 添加或减少购物车数目
- (void)updateNumWithShopId:(NSString *)shopId num:(NSInteger)num
{
    WeiMiUpdateChartNumRequest *request = [[WeiMiUpdateChartNumRequest alloc] initWithShopId:shopId number:num];
//    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
//        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        
//        [strongSelf.tableView reloadData];
        }failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}

//删除购物车
- (void)deleteWithShopId:(NSString *)shopId cell:(WeiMiShopCartCell *)weakCell checkBtn:(UIButton *)checkBtn{
    WeiMiDeleteChartRequest *request = [[WeiMiDeleteChartRequest alloc] initWithShopId:shopId];
    //    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            [strongSelf presentSheet:@"删除成功"];
            
            if (checkBtn.selected) {
                strongSelf.totalPrice -= weakCell.price * weakCell.num;
                strongSelf.selectedNum -= weakCell.num;
            }
            NSIndexPath *path = [weakSelf.tableView indexPathForCell:weakCell];
            
            [[self mutableArrayValueForKey:@"dataSource"] removeObjectAtIndex:path.row];
            
            [strongSelf.tableView beginUpdates];
            [strongSelf.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
            [strongSelf.tableView endUpdates];
        }else
        {
            [strongSelf presentSheet:@"删除失败"];
        }
    }failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}

#pragma mark - Common
- (void)changeToEmptyShoppingCart:(BOOL)empty
{
    [self.toolBar setHidden:empty];
    [self.tableView setHidden:empty];
    [self.notiView setHidden:!empty];
//    [self.emptyButton setHidden:!empty];
    [self.hotGoodsCollection setHidden:!empty];
    [self.headerView setHidden:!empty];
    
    _tableView.backgroundColor = empty ? kWhiteColor : HEX_RGB(BASE_BG_COLOR);
    
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        if (empty) {
            make.bottom.mas_equalTo(_toolBar.mas_bottom);
        }else
        {
            make.bottom.mas_equalTo(self.toolBar.mas_top);
        }
    }];
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    [self presentSheet:@"去逛逛"];
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
                [self changeToEmptyShoppingCart:YES];
                [_hotGoodsCollection reloadData];
            }else
            {
                [self changeToEmptyShoppingCart:NO];
            }
            return;
        }
        [_toolBar setViewWithPrice:_totalPrice num:_selectedNum];
        [self relayOutToolBar];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellID = @"shopCartCell";
    WeiMiShopCartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        WS(weakSelf);
        cell = [[WeiMiShopCartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        __weak typeof(cell) weakCell = cell;
        cell.onSeletedCheckBoxBlock = ^(UIButton *btn){
            if (btn.selected) {
                weakSelf.totalPrice += weakCell.num *weakCell.price;
                weakSelf.selectedNum += weakCell.num;
            } else {
                weakSelf.totalPrice -= weakCell.num *weakCell.price;;
                weakSelf.selectedNum -= weakCell.num;
            }
        };
        
        cell.onDeleteBlock = ^(UIButton *checkBtn){
            SS(strongSelf);
            
            [OHAlertView showAlertWithTitle:@"删除购物车" message:nil cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    
                    [strongSelf deleteWithShopId:weakCell.dto.shopId cell:weakCell checkBtn:(UIButton *)checkBtn];
                    

                }
            }];
            
        };
        
        cell.onPlusBlock = ^(UIButton *checkBtn){
            if (checkBtn.selected) {
                weakSelf.totalPrice += weakCell.price;;
                weakSelf.selectedNum += 1;
                [self updateNumWithShopId:weakCell.dto.shopId num:weakSelf.selectedNum];

            }
        };
        
        cell.onMinusBlock = ^(UIButton *checkBtn, NSInteger num){
            if (checkBtn.selected) {
                if (num != 1) {
                    weakSelf.totalPrice -= weakCell.price;
                    weakSelf.selectedNum -= 1;
                    [self updateNumWithShopId:weakCell.dto.shopId num:weakSelf.selectedNum];
                }
            }
        };
    }
    
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    cell.checkBoxBtn.selected = _selectedAll;
    
    if (_selectedAll) {
        
        self.totalPrice += cell.price * cell.num;
        self.selectedNum += cell.num;
    }
    
    return cell;
}

- (void)relayOutToolBar
{
    if (_totalPrice - 0 > 0.001) {
        [_toolBar reLayoutLabelWithStat: SHOPBOTTOMSTATUS_UPSIDE];
    }else
    {
        [_toolBar reLayoutLabelWithStat: SHOPBOTTOMSTATUS_LEFTSIDE];
    }
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
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

#pragma mark 完成最后移动,主要操作数据就行(注:移动并不是交换,移动看看就知道了,移动到一个位置,原先所有的cell会自动向下)
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    // 取得要移动的数据
    NSString * moveString = [[_dataSource objectAtIndex:sourceIndexPath.section] objectAtIndex:sourceIndexPath.row];
    // 移动到目的地
    [[_dataSource objectAtIndex:sourceIndexPath.section] insertObject:moveString atIndex:destinationIndexPath.row];
    // 删除源始地的数据
    [[_dataSource objectAtIndex:sourceIndexPath.section] removeObjectAtIndex:sourceIndexPath.row];
    
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _hotGoodDataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeiMiWellSaleGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    [cell setViewWithDTO:safeObjectAtIndex(_hotGoodDataSource, indexPath.row)];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewID forIndexPath:indexPath];

        [headerView addSubview:self.headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(headerView);
        }];
        return headerView;
    }
    return nil;
}

#pragma mark - Delegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((self.view.width - 20)/3, GetAdapterHeight(180));
}

#pragma mark - UICollectionViewDelegateFlowLayout
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    
//    return CGSizeMake(collectionView.width, GetAdapterHeight(40));
//}

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

#pragma mark - layout
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    if(self.isFromeGoodDetails){
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-NAV_HEIGHT-STATUS_BAR_HEIGHT);
            make.height.mas_equalTo(GetAdapterHeight(45));
        }];
    } else {
        [_toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-TAB_BAR_HEIGHT-NAV_HEIGHT-STATUS_BAR_HEIGHT);
            make.height.mas_equalTo(GetAdapterHeight(45));
        }];
    }

    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(_toolBar.mas_bottom);
    }];
    
    [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.tableView);
        make.width.mas_equalTo(self.tableView).multipliedBy(0.5);
        make.bottom.mas_equalTo(self.tableView.mas_centerY).offset(-20);
    }];
    
//    if (_emptyButton) {
//        
//        [_emptyButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.center.mas_equalTo(self.view);
//            make.size.mas_equalTo(CGSizeMake(71, 27));
//        }];
//    }
    
    [_hotGoodsCollection mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_tableView);
        make.bottom.mas_equalTo(_tableView.mas_bottom);
        make.height.mas_equalTo(GetAdapterHeight(210));
    }];
    
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(_tableView);
        make.height.mas_equalTo(40);
        make.bottom.mas_equalTo(_hotGoodsCollection.mas_top).offset(10);
    }];
}

@end
