//
//  WeiMiHomePageGoodsVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomePageGoodsVC.h"
#import "WeiMiHomePageGoodsCell.h"
#import "WeiMiGoodsDetailVC.h"
#import "WeiMiNotifiEmptyView.h"
#import "WeiMiGoodsDetailVC.h"
#import "WeiMiRefreshComponents.h"
//------ request
#import "WeiMiHPProductListRequest.h"
#import "WeiMiHPProductListResponse.h"

static NSString  *kCellID = @"cellID";
static NSString  *kHeaderID = @"headerID";
@interface WeiMiHomePageGoodsVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    __block NSInteger _currentPage;

}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiEmptyView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WeiMiHomePageGoodsVC

- (instancetype)init
{
    if (self = [super init]) {
        _currentPage = 1;

        _dataSource = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xC5C9C2);

    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.collectionView];
    self.collectionView.frame = self.contentFrame;
    
    [self.collectionView addSubview:self.notiEmptyView];
//    self.notiEmptyView.hidden = YES;
    //上拉刷新
    _collectionView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getHotSllersNavID:self.navId pageIndex:_currentPage pageSize:10];
    }];
    
    //下拉刷新
    _collectionView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        _currentPage = 1;
        [_dataSource removeAllObjects];
        [self getHotSllersNavID:self.navId pageIndex:_currentPage pageSize:10];
    }];
    
    [self getHotSllersNavID:self.navId pageIndex:_currentPage pageSize:10];

    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    [self.view setNeedsUpdateConstraints];
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
        layout.itemSize = CGSizeMake((self.view.width - 30)/2, self.view.width/2 * 1.49f);
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
    }
    return _collectionView;
}

//----  提示空视图
- (WeiMiNotifiEmptyView *)notiEmptyView
{
    if (!_notiEmptyView) {
        _notiEmptyView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiEmptyView setViewWithImg:@"icon_list" title:@"暂时没有商品哦"];
    };
    return _notiEmptyView;
}

// -------- 商品列表
- (void)getHotSllersNavID:(NSString *)navID pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiHPProductListRequestModel *model = [[WeiMiHPProductListRequestModel alloc] init];
    model.isAble = @"2";
    model.menuId = navID;
    WeiMiHPProductListRequest *request = [[WeiMiHPProductListRequest alloc] initWithModel:model pageIndex:index pageSize:pageSize];
    WeiMiHPProductListResponse *response = [[WeiMiHPProductListResponse alloc] init];
    
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            
            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:response.dataArr];
            [strongSelf.collectionView reloadData];
            
            _currentPage ++;
            [_collectionView.mj_footer endRefreshing];
        }else
        {
            if ([_collectionView.mj_footer isRefreshing]) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }

        [_collectionView.mj_header endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];

        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

//    UPRouterOptions *options = [UPRouterOptions routerOptions];
//    options.hidesBottomBarWhenPushed = YES;
//    [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiGoodsDetailVC" options:options];
    WeiMiHPProductListDTO *dto = safeObjectAtIndex(_dataSource, indexPath.row);
    WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
    vc.productId = dto.productId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints
{
    [_notiEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(_collectionView);
        make.left.mas_equalTo(_collectionView).offset(10);
        make.right.mas_equalTo(_collectionView).offset(-10);
        make.height.mas_equalTo(GetAdapterHeight(200));
    }];
    
//    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.right.bottom.mas_equalTo(0);
//        make.top.mas_equalTo(_menu.mas_bottom).offset(1);
//    }];
    [super updateViewConstraints];
    
}

@end
