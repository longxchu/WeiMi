//
//  WeiMiTryOutVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiTryOutVC.h"
#import "WeiMiTryoutCollectionCell.h"

#import "WeiMiRefreshComponents.h"

#import "WeiMiApplyDetailVC.h"
//---- request
#import "WeiMiTryoutListRequest.h"
#import "WeiMiTryoutListResponse.h"

static NSString  *kCellID = @"cellID";
static NSString  *kHeaderID = @"headerID";
@interface WeiMiTryOutVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *_dataSource;
    NSMutableArray *_imgSource;
    
    __block NSInteger _currentPage;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *headerLeftBTN;
@property (nonatomic, strong) UIButton *headerRightBTN;
@end

@implementation WeiMiTryOutVC

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
    
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.collectionView];
    self.collectionView.frame = self.contentFrame;
    
    //上拉刷新
    _collectionView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getTryoutListWithpageIndex:_currentPage pageSize:10];
    }];
    
    //下拉刷新
    _collectionView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        
        _currentPage = 1;
        [_dataSource removeAllObjects];
        [self getTryoutListWithpageIndex:_currentPage pageSize:10];
    }];
    
    [self getTryoutListWithpageIndex:_currentPage pageSize:10];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"试用评测";
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UIButton *)headerLeftBTN
{
    if (!_headerLeftBTN) {
        
        _headerLeftBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerLeftBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        [_headerLeftBTN setTitle:@"评测广场" forState:UIControlStateNormal];
        [_headerLeftBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        _headerLeftBTN.layer.borderColor = kGrayColor.CGColor;
        _headerLeftBTN.layer.borderWidth = 1.0f;
        _headerLeftBTN.layer.masksToBounds = YES;
        _headerLeftBTN.layer.cornerRadius = 3.0f;
        [_headerLeftBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerLeftBTN;
}

- (UIButton *)headerRightBTN
{
    if (!_headerRightBTN) {
        
        _headerRightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _headerRightBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        [_headerRightBTN setTitle:@"我的试用" forState:UIControlStateNormal];
        [_headerRightBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        _headerRightBTN.layer.borderColor = kGrayColor.CGColor;
        _headerRightBTN.layer.borderWidth = 1.0f;
        _headerRightBTN.layer.masksToBounds = YES;
        _headerRightBTN.layer.cornerRadius = 3.0f;
        [_headerRightBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerRightBTN;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake((self.view.width - 30)/2, (self.view.width - 30)/2 + 90);
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, GetAdapterHeight(70));

        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.scrollEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delaysContentTouches = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[WeiMiTryoutCollectionCell class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderID];
    }
    return _collectionView;
}

#pragma mark - Network
//---- 最新活动列表
- (void)getTryoutListWithpageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiTryoutListRequest *request = [[WeiMiTryoutListRequest alloc] initWithPageIndex:index pageSize:pageSize];
    WeiMiTryoutListResponse *response = [[WeiMiTryoutListResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [_dataSource addObjectsFromArray:response.dataArr];
            [strongSelf.collectionView reloadData];
            
            _currentPage ++;
            [_collectionView.mj_footer endRefreshing];
        }else
        {
            if ([_collectionView.mj_header isRefreshing]) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_collectionView.mj_footer endRefreshing];
            }
        }
        [_collectionView.mj_header endRefreshing];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];
        
    }];
}


#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == _headerLeftBTN) {
        
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiTryOutGroundVC" options:options];
    }else if (sender == _headerRightBTN)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiMyTryoutVC" options:options];
    }
}

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
    WeiMiTryoutCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderID forIndexPath:indexPath];
        
        [headerView addSubview:self.headerLeftBTN];
        [headerView addSubview:self.headerRightBTN];
        
        [_headerLeftBTN mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(_headerLeftBTN.mas_height).multipliedBy(3.6f);
//            make.centerX.mas_equalTo(headerView).multipliedBy(0.25);
            make.left.mas_equalTo(10);
        }];

        [_headerRightBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
            make.width.mas_equalTo(_headerLeftBTN.mas_height).multipliedBy(3.6f);
//            make.centerX.mas_equalTo(headerView.mas_centerX).multipliedBy(0.75);
            make.right.mas_equalTo(-10);
        }];
        
        return headerView;
    }
    return nil;
}

//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//
//    return CGSizeMake(collectionView.width, GetAdapterHeight(70));
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    WeiMiApplyContentVC
//    [[WeiMiPageSkipManager homeRT] open:@"WeiMiApplyContentVC"];
//        [[WeiMiPageSkipManager homeRT] open:@"WeiMiApplyDetailVC"];
    WeiMiApplyDetailVC *vc = [[WeiMiApplyDetailVC alloc] init];
    vc.dto = safeObjectAtIndex(_dataSource, indexPath.row);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
