//
//  WeiMiNewestATVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiNewestATVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiNewActCell.h"
#import "WeiMiNewestActDTO.h"
#import "WeiMiRefreshComponents.h"
#import "WeiMiHomeActivityDetailVC.h"
//---- request
#import "WeiMiNewestActListRequest.h"
#import "WeiMiNewestActListResponse.h"
@interface WeiMiNewestATVC ()<UITableViewDataSource, UITableViewDelegate>
{
    /**数据源*/
    NSMutableArray *_dataSource;
    __block NSInteger _currentPage;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@end

@implementation WeiMiNewestATVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = 1;
//        WeiMiNewestActDTO *dto = [[WeiMiNewestActDTO alloc] init];
//        _dataSource = @[dto, dto, dto];
        _dataSource = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    
    [self.view setNeedsUpdateConstraints];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getNewestActWithpageIndex:_currentPage pageSize:10];
    }];
    
    //下拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        
        _currentPage = 1;
        [_dataSource removeAllObjects];
        [self getNewestActWithpageIndex:_currentPage pageSize:10];
    }];
    
    [self getNewestActWithpageIndex:_currentPage pageSize:10];
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
    self.title = @"最新活动";
    self.popWithBaseNavColor = YES;
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
- (UITableView *)tableView
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
//---- 最新活动列表
- (void)getNewestActWithpageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiNewestActListRequest *request = [[WeiMiNewestActListRequest alloc] initWithPageIndex:index pageSize:pageSize];
    WeiMiNewestActListResponse *response = [[WeiMiNewestActListResponse alloc] init];
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
            [strongSelf.tableView reloadData];
            
            _currentPage ++;
            [_tableView.mj_footer endRefreshing];
        }else
        {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [_tableView.mj_footer endRefreshing];
            }
        }
        [_tableView.mj_header endRefreshing];

    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];
 
    }];
}

#pragma mark - Actions

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    WeiMiNewActCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiNewActCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
    }
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 115;
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
    
//    [[WeiMiPageSkipManager homeRouter] skipIntoVC:@"WeiMiHomeActivityDetailVC"];
    WeiMiHomeActivityDetailVC *vc = [[WeiMiHomeActivityDetailVC alloc] init];
    vc.actId = ((WeiMiNewestActDTO *)safeObjectAtIndex(_dataSource, indexPath.row)).atId;
    [self.navigationController pushViewController:vc animated:YES];
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


@end
