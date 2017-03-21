//
//  WeiMiMyOrderVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/1.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyOrderVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiSegmentView.h"
#import "WeiMiNotifiEmptyView.h"
#import "WeiMiMyOrderCell.h"
#import "WeiMiOrderDTO.h"
#import "WeiMiSearchBar.h"
#import "WeiMiBaseSearchBar.h"
#import "WeiMiOderDetailVC.h"
#import "WeiMiPaymentView.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import <IQKeyboardManager.h>

#import "WeiMiRefreshComponents.h"

//---- request
#import "WeiMiMyOrderListRequest.h"
#import "WeiMiMyOrderListResponse.h"
typedef NS_ENUM(NSInteger, TABLEVIEWTYPE)
{
    TABLEVIEWTYPE_ALL,
    TABLEVIEWTYPE_TOPAY,
    TABLEVIEWTYPE_TOREC,
};
@interface WeiMiMyOrderVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
WeiMiSegmentViewDelegate,UISearchDisplayDelegate>
{
    WeiMiMyOrderListResponse *_response;
    /**数据源*/
    NSMutableArray *_dataSource;
    __block BOOL _searchEnable;
    
    NSMutableArray *_allArr;//全部
    NSMutableArray *_toPayArr;//带代付款
    NSMutableArray *_toRecArr;//待收货
    
    __block NSInteger _currentAllPage;
    __block NSInteger _currentToPayPage;
    __block NSInteger _currentToRecPage;

    TABLEVIEWTYPE _tableViewType;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) WeiMiSegmentView *segView;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;

//@property (nonatomic, strong) WeiMiSearchBar *searchBar;
@property (nonatomic, strong) UIView *titleBGView;
@property (nonatomic, strong) WeiMiBaseSearchBar *navSearchBar;
//@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) WeiMiBaseView *grayView;

@end

@implementation WeiMiMyOrderVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        _dataSource = @[@"在线客服",
//                        @"系统通知",
//                        @"我的消息"];
        _allArr = [NSMutableArray new];
        _toPayArr = [NSMutableArray new];
        _toRecArr = [NSMutableArray new];
        
        _currentAllPage = 1;
        _currentToPayPage = 1;
        _currentToRecPage = 1;
        
//        WeiMiOrderDTO *dto_0 = [[WeiMiOrderDTO alloc] init];
//        dto_0.tradeStatus = 0;
//        WeiMiOrderDTO *dto_1 = [[WeiMiOrderDTO alloc] init];
//        dto_1.tradeStatus = 1;
//        WeiMiOrderDTO *dto_2 = [[WeiMiOrderDTO alloc] init];
//        dto_2.tradeStatus = 2;
//        
//        [_allArr addObjectsFromArray:@[dto_0, dto_1, dto_2]];
//        [_toPayArr addObjectsFromArray:@[dto_0, dto_0]];
//        [_toRecArr addObjectsFromArray:@[dto_2, dto_2]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.segView];
    [self.contentView addSubview:self.tableView];

    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_segView.mas_bottom);
    }];
    [self.view setNeedsUpdateConstraints];
    
    _tableViewType = TABLEVIEWTYPE_ALL;
    _dataSource = _allArr;
    
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        switch (_tableViewType) {
            case TABLEVIEWTYPE_ALL:
                [self getMyOrderListWithOrderStatus:@"0" pageIndex:_currentAllPage pageSize:10];
                break;
            case TABLEVIEWTYPE_TOPAY:
                [self getMyOrderListWithOrderStatus:@"1" pageIndex:_currentToPayPage pageSize:10];
                break;
            case TABLEVIEWTYPE_TOREC:
                [self getMyOrderListWithOrderStatus:@"2" pageIndex:_currentToRecPage pageSize:10];
                break;
            default:
                break;
        }
    }];
    
    //orderStatus 0为全部 1为待发货 2为待收货 3为完成
    [self getMyOrderListWithOrderStatus:@"0" pageIndex:_currentAllPage pageSize:10];
//    [self getMyOrderListWithOrderStatus:@"1" pageIndex:_currentToPayPage pageSize:10];
//    [self getMyOrderListWithOrderStatus:@"2" pageIndex:_currentToRecPage pageSize:10];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    _searchEnable = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (BOOL)controllerWillPopHandler
{
    if (_searchEnable) {
        return NO;
    }
    return YES;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"我的订单";
    self.navigationItem.titleView = nil;
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        if (_searchEnable) {
            strongSelf.navigationItem.titleView = nil;
            [strongSelf.righBasetBtn setTitle:@"" forState:UIControlStateNormal];
            //[strongSelf.righBasetBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
           // [strongSelf.righBasetBtn setImage:[UIImage imageNamed:@"icon_search"] forState:/UIControlStateSelected];
            [self.grayView removeFromSuperview];
            _searchEnable = NO;
        }else
        {
            [strongSelf BackToLastNavi];
        }
    }];

//    //[self AddRightBtn:nil normal:@"icon_search" selected:@"icon_search" action:^{
//        SS(strongSelf);
//        
//        if (!_searchEnable) {
//            _titleBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
//            [_titleBGView addSubview:strongSelf.navSearchBar];
//            _navSearchBar.frame = _titleBGView.frame;
//            strongSelf.navigationItem.titleView = _titleBGView;
//            
//            [strongSelf.righBasetBtn setTitle:@"搜索" forState:UIControlStateNormal];
//            [strongSelf.righBasetBtn setImage:nil forState:UIControlStateNormal];
//            [strongSelf.righBasetBtn setImage:nil forState:UIControlStateHighlighted];
//            [strongSelf.righBasetBtn setImage:nil forState:UIControlStateSelected];
//            [strongSelf.righBasetBtn sizeToFit];
//            //半透明遮盖
//            [strongSelf.view addSubview:self.grayView];
//            _searchEnable = YES;
//        }else
//        {
//            
//        }
//    }];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (WeiMiBaseView *)grayView
{
    if (!_grayView) {
        _grayView = [[WeiMiBaseView alloc] init];
        _grayView.frame = self.contentFrame;
        _grayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _grayView;
}

//- (UISearchDisplayController *)searchController
//{
//    if (!_searchController) {
//        
//    }
//    return _searchController;
//}

//- (UISearchDisplayController *)searchController
//{
//    if (!_searchController) {
//        _searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.navSearchBar contentsController:self];
//        _searchController.searchResultsDelegate = self;
//        _searchController.searchResultsDataSource = self;
//        _searchController.delegate = self;
//    }
//    return _searchController;
//}

- (WeiMiBaseSearchBar *)navSearchBar
{
    if (!_navSearchBar) {
        _navSearchBar = [[WeiMiBaseSearchBar alloc] init];
        _navSearchBar.placeholder = @"请输入搜索关键词";
//        _searchBar.layer.borderColor = kGrayColor.CGColor;
    }
    return _navSearchBar;
}


- (WeiMiSegmentView *)segView
{
    if (!_segView) {
        _segView = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(0, self.contentFrame.origin.y, 220, 35) titleArray:@[@"全部", @"待付款", @"待收货"] defaultSelectIndex:0 delegate:self];
        _segView.backgroundColor = kWhiteColor;
    }
    return _segView;
}

- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"icon_heart" title:@"您还没有收藏的商品"];
    }
    return _notiView;
}

#pragma mark - NetWork
//---- 获取订单信息
- (void)getMyOrderListWithOrderStatus:(NSString *)orderStatus pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize
{
    WeiMiMyOrderListRequest *request = [[WeiMiMyOrderListRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel orderStatus:orderStatus pageIndex:pageIndex pageSize:pageSize];
    _response = [[WeiMiMyOrderListResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            
            [_response parseResponse:result];
//            [[self mutableArrayValueForKey:@"dataSource"] removeAllObjects];
//            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:response.dataArr];
//            [strongSelf.tableView reloadData];
            //获得DTO
            NSMutableArray *dtoArr = [[NSMutableArray alloc] init];
            [_response.dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                WeiMiOrderResultModel *model = obj;
                [dtoArr addObject:model.orderDTO];
            }];
            switch (_tableViewType) {
                case TABLEVIEWTYPE_ALL:
                {
                    [_allArr addObjectsFromArray:dtoArr];
                    _currentAllPage ++;
                    _dataSource = _allArr;
//                    [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:dtoArr];
                }
                    break;
                case TABLEVIEWTYPE_TOPAY:
                {
                    [_toPayArr addObjectsFromArray:dtoArr];
                    _currentToPayPage++;
                    _dataSource = _toPayArr;

                }
                    break;
                case TABLEVIEWTYPE_TOREC:
                {
                    [_toRecArr addObjectsFromArray:dtoArr];
                    _currentToRecPage++;
                    _dataSource = _toRecArr;

                }
                    break;
                default:
                    break;
            }
            [_tableView reloadData];
        }
        [_tableView.mj_footer endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - Actions



#pragma mark - WeiMiSegmentViewDelegate
- (void)didSelectedAtIndex:(NSUInteger)index
{
    if (index == 0) {
        _tableViewType = TABLEVIEWTYPE_ALL;
        _dataSource = _allArr;
    }else if (index == 1)
    {
        _tableViewType = TABLEVIEWTYPE_TOPAY;
        _dataSource = _toPayArr;
    }else if (index == 2)
    {
        _tableViewType = TABLEVIEWTYPE_TOREC;
        _dataSource = _toRecArr;
    }
    
    switch (_tableViewType) {
        case TABLEVIEWTYPE_ALL://全部
        {
            if (_currentAllPage > 1) {
                [_tableView reloadData];
                return;
            }
            [self getMyOrderListWithOrderStatus:@"0" pageIndex:_currentAllPage pageSize:10];
        }
            break;
        case TABLEVIEWTYPE_TOPAY://待付款
        {
            if (_currentToPayPage > 1) {
                [_tableView reloadData];
                return;
            }
            [self getMyOrderListWithOrderStatus:@"1" pageIndex:_currentToPayPage pageSize:10];
        }
            break;
        case TABLEVIEWTYPE_TOREC://待收货
        {
            if (_currentToRecPage > 1) {
                [_tableView reloadData];
                return;
            }
            [self getMyOrderListWithOrderStatus:@"2" pageIndex:_currentToRecPage pageSize:10];
        }
            break;
        default:
            break;
    }
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID;
    switch (_tableViewType) {
        case TABLEVIEWTYPE_ALL:
            cellID = @"cellALL";
            break;
        case TABLEVIEWTYPE_TOREC:
            cellID = @"cellTOREC";
            break;
        case TABLEVIEWTYPE_TOPAY:
            cellID = @"cellTOPAY";
            break;
        default:
            cellID = @"cell";
            break;
    }
    
    WeiMiMyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiMyOrderCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(weakSelf);
        if (_tableViewType == TABLEVIEWTYPE_TOREC) {//待收货
            
            cell.onRightHandler = ^{//确认收货
                [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiMakeRecVC"];
            };
        }else if (_tableViewType == TABLEVIEWTYPE_TOPAY)//全部
        {
            __weak typeof(cell) weakCell = cell;
            cell.onLeftHandler = ^{
                [[WeiMiPageSkipManager mineRT] open:@"WeiMiRefundVC"];
    
            };
            
            cell.onRightHandler = ^{
                WeiMiPaymentView *payAlert = [[WeiMiPaymentView alloc] init];
                payAlert.title = @"请输入支付密码";
                payAlert.detail = @"提现";
                payAlert.amount= 10;
                [payAlert show];
                payAlert.completeHandle = ^(NSString *inputPwd) {
                    NSLog(@"密码是%@",inputPwd);};
                
            };
        }else if (_tableViewType == TABLEVIEWTYPE_ALL)//全部
        {
            __weak typeof(cell) weakCell = cell;
            cell.onLeftHandler = ^{
                switch ([weakCell tradeStatus]) {
                    case TRADESTATUS_DEALSUCEESS://交易成功
                    {
                        NSIndexPath *path = [tableView indexPathForCell:weakCell];
                        [_dataSource removeObjectAtIndex:path.section];
                        [tableView deleteSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationLeft];
                        SS(strongSelf);
                        [strongSelf presentSheet:@"删除成功"];
                    }
                        break;
                    case TRADESTATUS_UNPAY:
                    {
                        [[WeiMiPageSkipManager mineRT] open:@"WeiMiRefundVC"];
                    }
                        
                        break;
                    case TRADESTATUS_UNREC:
    
                        break;
                        
                    default:
                        break;
                }
            };
            
            cell.onRightHandler = ^{
                switch ([weakCell tradeStatus]) {
                    case TRADESTATUS_DEALSUCEESS://评价
                    {
                        [[WeiMiPageSkipManager mineRT] open:@"WeMiCommentOrderVC"];
                    }
                        
                        break;
                    case TRADESTATUS_UNPAY:
                    {
                        WeiMiPaymentView *payAlert = [[WeiMiPaymentView alloc] init];
                        payAlert.title = @"请输入支付密码";
                        payAlert.detail = @"提现";
                        payAlert.amount= 10;
                        [payAlert show];
                        payAlert.completeHandle = ^(NSString *inputPwd) {
                            NSLog(@"密码是%@",inputPwd);
                        };
                    }
                        
                        break;
                    case TRADESTATUS_UNREC://确认收货
                    {
                        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiMakeRecVC"];
                    }
                        break;
                        
                    default:
                        break;
                }
            };
        }
    }
    
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.section)];
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    WeiMiOderDetail
    
    WeiMiMyOrderCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell) {
        switch ([cell tradeStatus]) {
            case TRADESTATUS_UNPAY:
            {
                [[WeiMiPageSkipManager mineRT] open:@"WeiMiOrderUnpayVC"];
            }
                break;
                
            default:
            {
                WeiMiOderDetailVC *vc =  [[WeiMiOderDetailVC alloc] init];
                vc.tradeStatus = [cell tradeStatus];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
        }
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
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}



@end
