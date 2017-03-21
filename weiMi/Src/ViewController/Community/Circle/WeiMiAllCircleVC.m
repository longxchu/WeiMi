//
//  WeiMiAllCircleVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAllCircleVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiCircleAllTagCell.h"
#import "WeiMiCircleMouleCell.h"
#import "WeiMiRefreshComponents.h"
#import "WeiMiNotifiEmptyView.h"
//-------- vc
#import "WeiMiCircleDetailVC.h"
//-- request
#import "YTKChainRequest.h"
//圈子分类
#import "WeiMiCircleCateRequest.h"
#import "WeiMiCircleCateResponse.h"
//圈子分类详情
#import "WeiMiCircleCateListRequest.h"
#import "WeiMiCircleCateListResponse.h"
//关注圈子
#import "WeiMiCareCircleRequest.h"

@interface WeiMiAllCircleVC ()<UITableViewDelegate, UITableViewDataSource, YTKChainRequestDelegate>
{
    NSMutableArray *_leftDataSource;
    NSMutableDictionary *_rightCollectionArr;//右侧table缓存
    
    NSInteger _rightRowIdx;
    __block NSInteger _leftSelectIdx;
    __block NSInteger _currentPage;

}

@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic, strong) UITableView *rightTable;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiEmptyView;

@property (nonatomic, strong) NSMutableArray *rightDataSource;//右侧table显示数据


@end

@implementation WeiMiAllCircleVC

- (instancetype)init
{
    if (self = [super init]) {
        _rightRowIdx = 1;
        _currentPage = 1;

        _leftDataSource = [NSMutableArray new];
        _rightDataSource = [NSMutableArray new];
        _rightCollectionArr = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.leftTable];
    [self.contentView addSubview:self.rightTable];

    [self.rightTable addSubview:self.notiEmptyView];
    
    [self.view setNeedsUpdateConstraints];
    

    [self getCategory];
    
    //上拉刷新
    _rightTable.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        WeiMiCircleCateDTO *dto = safeObjectAtIndex(_leftDataSource, _leftSelectIdx);
        if (dto) {
            [self getListWithTypeId:dto.typeId pageIndex:_currentPage pageSize:10 leftSelectedIdx:_leftSelectIdx isRefresh:YES];
        }
    }];
    
    //下拉刷新
    _rightTable.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        _currentPage = 1;
        WeiMiCircleCateDTO *dto = safeObjectAtIndex(_leftDataSource, _leftSelectIdx);
        if (dto) {
            [self getListWithTypeId:dto.typeId pageIndex:_currentPage  pageSize:10 leftSelectedIdx:_leftSelectIdx isRefresh:YES];
        }
    }];
    
    [self addObserver:self forKeyPath:@"rightDataSource" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"rightDataSource"];
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
    self.title = @"所有圈子";
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];

}

#pragma mark - Getter
- (UITableView *)leftTable
{
    if (!_leftTable) {
        _leftTable = [WeiMiBaseTableView tableView];
//        _leftTable.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTable.showsVerticalScrollIndicator = NO;
        _leftTable.backgroundColor = HEX_RGB(0xF1F1F1);
    }
    return _leftTable;
}

- (UITableView *)rightTable
{
    if (!_rightTable) {
        _rightTable = [WeiMiBaseTableView tableView];
//        _rightTable.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        _rightTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _rightTable.showsVerticalScrollIndicator = NO;
        _rightTable.backgroundColor = HEX_RGB(0xF1F1F1);
    }
    return _rightTable;
}

//----  提示空视图
- (WeiMiNotifiEmptyView *)notiEmptyView
{
    if (!_notiEmptyView) {
        _notiEmptyView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiEmptyView setViewWithImg:@"icon_list" title:@"暂时没有圈子哦"];
    };
    return _notiEmptyView;
}
#pragma mark - NetWork
//---- 获取分类列表
- (void)getCategory
{
    //分类
    WeiMiCircleCateRequest *cateRequest = [[WeiMiCircleCateRequest alloc] init];
    WeiMiCircleCateResponse *cateResponse = [[WeiMiCircleCateResponse alloc] init];
    
    WS(weakSelf);
    YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
    [chainRequest addRequest:cateRequest callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        SS(strongSelf);
        WeiMiCircleCateRequest *req = (WeiMiCircleCateRequest *)baseRequest;
        NSInteger count = EncodeArrayFromDic(req.responseJSONObject, @"result").count;
        if (count) {
            [cateResponse parseResponse:req.responseJSONObject];
            [strongSelf addCate:cateResponse];
        }
    }];
    
    chainRequest.delegate = self;
    // start to send request
    [chainRequest start];

}

// -------- 圈子详情列表
- (void)getListWithTypeId:(NSString *)typeId pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize leftSelectedIdx:(NSInteger)leftSelectedIdx isRefresh:(BOOL)refresh
{
    if (!refresh) {//若不是刷新，检查缓存是否存在
        index = 1;//不是刷新，当前页置为1
        [[self mutableArrayValueForKey:@"rightDataSource"] removeAllObjects];
        [_rightTable.mj_footer endRefreshing];

        NSArray *cacheArr = [_rightCollectionArr objectForKey:[NSString stringWithFormat:@"%ld", (long)leftSelectedIdx]];
        if (cacheArr.count) {//若数据存在
            [[self mutableArrayValueForKey:@"rightDataSource"] addObjectsFromArray:cacheArr];
 
            [_rightTable reloadData];
            return;
        }
//        else//若数据不存在
//        {
//            [_rightTable reloadData];
//        }
    }//若是刷新
    WeiMiCircleCateListRequest *request = [[WeiMiCircleCateListRequest alloc] initWithTypeId:typeId pageIndex:index pageSize:pageSize memberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel];
    WeiMiCircleCateListResponse *response = [[WeiMiCircleCateListResponse alloc] init];
    
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            NSDictionary *result = request.responseJSONObject;
            NSInteger count = EncodeArrayFromDic(result, @"result").count;
            if (count) {//有数据
                [response parseResponse:result];
                
                if ([_rightTable.mj_header isRefreshing]) {//头刷新
                    [[self mutableArrayValueForKey:@"rightDataSource"] removeAllObjects];
                }
                [_rightCollectionArr setObject:response.dataArr forKey:[NSString stringWithFormat:@"%ld", leftSelectedIdx]];
                [[self mutableArrayValueForKey:@"rightDataSource"] addObjectsFromArray:response.dataArr];
                
                [strongSelf.rightTable reloadData];
                _currentPage ++;
                [_rightTable.mj_footer endRefreshing];
                
            }else//无数据
            {
                if ([_rightTable.mj_footer isRefreshing]) {
                    if (refresh) {//刷新
                        [_rightTable.mj_footer endRefreshingWithNoMoreData];
                    }
                    else//非刷新
                    {
                        [_rightTable.mj_footer endRefreshing];
                    }
                }
            }

            [_rightTable.mj_footer endRefreshing];
        }else
        {
            if ([_rightTable.mj_footer isRefreshing]) {
                [_rightTable.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        [_rightTable.mj_header endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        [_rightTable.mj_footer endRefreshing];
        [_rightTable.mj_header endRefreshing];
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//--- 关注圈子
- (void)careCircleWithringId:(NSString *)ringId success:(void(^)(bool isCancel))success
{
    WeiMiCareCircleRequest *request = [[WeiMiCareCircleRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel ringId:ringId];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         SS(strongSelf);
         NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
         if ([result isEqualToString:@"1"]) {
             success(YES);
             [strongSelf presentSheet:@"关注成功"];
         }else if([result isEqualToString:@"2"])
         {
             success(YES);
             [strongSelf presentSheet:@"已经关注过了"];
         }else if ([result isEqualToString:@"0"])
         {
             success(NO);
             [strongSelf presentSheet:@"关注失败"];
         }
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         
         //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
     }];
}
// 取消关注圈子
- (void)cancelCircleWithringId:(NSString *)ringId success:(void(^)(bool isCancel))success {
    WeiMiCancelCircleRequest *request = [[WeiMiCancelCircleRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel ringId:ringId];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            success(YES);
            [strongSelf presentSheet:@"取消关注成功"];
        }else{
            success(NO);
            [strongSelf presentSheet:@"取消关注过失败"];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        success(NO);
        [strongSelf presentSheet:@"取消关注过失败"];
    }];
}

#pragma mark - YTKChainRequest Delegate
- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    // all requests are done
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
}

#pragma mark - util
- (void)addCate:(WeiMiCircleCateResponse *)response
{
//    NSMutableArray *cateArr = [NSMutableArray new];
    for (WeiMiCircleCateDTO *dto in response.dataArr) {
        [_leftDataSource addObject:dto];
    }
    [_leftTable reloadData];
    
    if(_leftDataSource.count>0)
    {
        NSIndexPath *path = [NSIndexPath indexPathForItem:_leftSelectIdx inSection:0];
        [self.leftTable selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];//设置选中第一行（默认有蓝色背景）
        [self tableView:self.leftTable didSelectRowAtIndexPath:path];//实现点击第一行所调用的方法
    }
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
        if ([keyPath isEqualToString:@"rightDataSource"]) {
            if (_rightDataSource.count == 0) {
                _notiEmptyView.hidden = NO;
            }else
            {
                _notiEmptyView.hidden = YES;
            }
            return;
        }
    }
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == _leftTable) {
        
        return _leftDataSource.count;
    }else{
        return _rightDataSource.count;
    }
    
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //表1
    if (tableView == _leftTable) {
        
        static NSString *cellId = @"identify";
        WeiMiCircleAllTagCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            
            cell = [[WeiMiCircleAllTagCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = kWhiteColor;
            cell.textLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        }
        WeiMiCircleCateDTO *dto = safeObjectAtIndex(_leftDataSource, indexPath.row);
        if (dto) {
            cell.textLabel.text = dto.typeName;
        }
        return cell;
    }
    
    //表2
    static NSString *cellId2 = @"cell";
    WeiMiCircleMouleCell *cell2 = [tableView dequeueReusableCellWithIdentifier:cellId2];
    
    if (!cell2) {
        
        cell2 = [[WeiMiCircleMouleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId2];
        WS(weakSelf);
        cell2.onCareBtnHandler = ^(UIButton *btn, NSString *ringId)
        {
            SS(strongSelf);
            if(!btn.isSelected){
                [strongSelf careCircleWithringId:ringId success:^(bool isCancel) {
                    if(isCancel){
                        btn.selected = !btn.selected;
                    }
                }];
            } else {
                [strongSelf cancelCircleWithringId:ringId success:^(bool isCancel) {
                    if(isCancel){
                        btn.selected = !btn.selected;
                    }
                }];
            }
        };
    }
    
    //    cell2.backgroundColor = [UIColor orangeColor];
//    cell2.textLabel.text = [NSString stringWithFormat:@"表2_第%ld行",(long)indexPath.row];
    [cell2 setViewWithDTO:safeObjectAtIndex(_rightDataSource, indexPath.row)];
    return cell2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(tableView == _leftTable){
        _leftSelectIdx = indexPath.row;
//        _rightRowIdx = 1+arc4random_uniform(15);//随机数1-15行
//        [_rightTable reloadData];
        WeiMiCircleCateDTO *dto = safeObjectAtIndex(_leftDataSource, indexPath.row);
        if (dto) {
            [self getListWithTypeId:dto.typeId pageIndex:_currentPage pageSize:10 leftSelectedIdx:_leftSelectIdx isRefresh:NO];
        }

    }else if (tableView == _rightTable)
    {
//        UPRouterOptions *options = [UPRouterOptions routerOptions];
//        options.hidesBottomBarWhenPushed = YES;
//        [[WeiMiPageSkipManager communityRT] map:@"WeiMiCircleDetailVC/:popWithBaseNavColor" toController:NSClassFromString(@"WeiMiCircleDetailVC") withOptions:options];
//        [[WeiMiPageSkipManager communityRT] open:@"WeiMiCircleDetailVC/no        "];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        WeiMiCircleDetailVC *vc = [[WeiMiCircleDetailVC alloc] init];
        WeiMiCircleCateListDTO *dto = safeObjectAtIndex(_rightDataSource, indexPath.row);
        vc.dto = dto;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _leftTable) {
        return 45;
    }
    return 70;
}

#pragma mark - Layout
- (void)updateViewConstraints
{
    
    [_notiEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.mas_equalTo(_rightTable);
        make.left.mas_equalTo(_rightTable).offset(10);
        make.right.mas_equalTo(_rightTable).offset(-10);
        make.height.mas_equalTo(GetAdapterHeight(200));
    }];
    
    [_leftTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAV_HEIGHT + STATUS_BAR_HEIGHT);
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH*0.2);
    }];
    
    [_rightTable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.top.mas_equalTo(_leftTable);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(_leftTable.mas_right);
    }];
    [super updateViewConstraints];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
