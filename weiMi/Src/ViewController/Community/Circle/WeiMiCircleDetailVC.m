//
//  WeiMiCircleDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleDetailVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiSegmentView.h"
#import "WeiMiInvitationVC.h"
//------ Cell
#import "WeiMiCircleMouleCell.h"
#import "WeiMiCircleOnlineNumCell.h"
#import "WeiMiCircleTopTopicCell.h"

#import "LWImageBrowser.h"
#import "WeiMiCircleCell.h"
#import "WeiMiCircleLayout.h"
#import "LWAlertView.h"
//刷新组件
#import "WeiMiRefreshComponents.h"
//批量请求
#import "YTKBatchRequest.h"
//帖子列表
#import "WeiMiInvitationListRequest.h"
#import "WeiMiInvitationListResponse.h"
//帖子评论列表
#import "WeiMiCommentListRequest.h"
#import "WeiMiCommentListResponse.h"

//圈子内帖子分类 最新帖子不用，因为帖子按时间分类倒排
//isAble=0不显示 1正常 2精华 3置顶 4首页 5推荐
typedef NS_ENUM(NSInteger, POSTTYPE)
{
    POSTTYPE_ALL = 0,//全部不用参数
    POSTTYPE_NEWEST = 1,
#warning 未确认
    POSTTYPE_CREAM = 2,//精华帖子
    POSTTYPE_TOP = 3,//置顶帖子
};

@interface WeiMiCircleDetailVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,WeiMiSegmentViewDelegate>
{
    /**数据源*/
    NSMutableArray *_topTopicDataSource;//置顶帖子

    NSArray *_imgArr;
    BOOL _popWithBaseNavColor;
    
    //分页
    __block NSInteger _currentAllPage;//全部
    __block NSInteger _currentNewestPage;//最新
    __block NSInteger _currentCreamPage;//精华
    
    POSTTYPE _postType;//帖子分类key
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) WeiMiCircleInfoV *topCell;
@property (nonatomic, strong) WeiMiCircleOnlineNumCell *onlineCell;
@property (nonatomic, strong) WeiMiSegmentView *segView;
@property (nonatomic, strong) UIButton *segMaskBTN;

@property (nonatomic, strong) UIButton *onlineMaskBTN;

@property (nonatomic, strong) UIButton *commentBTN;//圆形评论按钮
//列表数据源
@property (nonatomic,strong) NSMutableArray* dataSource;
//列表数据缓存
@property (nonatomic,strong) NSMutableDictionary* cacheSource;


@end

@implementation WeiMiCircleDetailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _currentCreamPage = 1;
        _currentNewestPage = 1;
        _currentAllPage = 1;
        _postType = POSTTYPE_ALL;
        
        _topTopicDataSource = [NSMutableArray arrayWithArray:@[@"发帖看我，新人须知",
                                                               @"发帖看我，新人须知",]];
        _cacheSource = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNavgationItem];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.topCell];
//    [self.contentView addSubview:self.onlineCell];
    [self.contentView addSubview:self.segView];
    [self.topCell updateConstraints];
    
    [self.contentView addSubview:self.onlineMaskBTN];
    [self.contentView addSubview:self.segMaskBTN];
    [self.contentView addSubview:self.tableView];

    [self.contentView addSubview:self.commentBTN];
    [self.view setNeedsUpdateConstraints];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        [self getCommentWithPostType:_postType ringId:_dto.ringId pageSize:10 isRefresh:YES];
    }];
    
    //下拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        switch (_postType) {
            case POSTTYPE_ALL:
                _currentAllPage = 1;
                break;
            case POSTTYPE_NEWEST:
                _currentNewestPage = 1;
                break;
            case POSTTYPE_CREAM:
                _currentCreamPage = 1;
                break;
            default:
                break;
        }
        [self getCommentWithPostType:_postType ringId:_dto.ringId pageSize:10 isRefresh:YES];
    }];
    [self.topCell setViewWithDTO:self.dto];
    [self getCommentWithPostType:_postType ringId:_dto.ringId pageSize:10 isRefresh:NO];
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
//    self.popWithBaseNavColor = _popWithBaseNavColor;
    self.title = @"圈子";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
//    [self AddRightBtn:nil normal:@"icon_more_black" selected:nil action:^{
//        
//
//    }];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (WeiMiCircleInfoV *)topCell
{
    if (!_topCell) {
        _topCell = [[WeiMiCircleInfoV alloc] init];
    }
    return _topCell;
}

- (WeiMiCircleOnlineNumCell *)onlineCell
{
    if (!_onlineCell) {
        _onlineCell = [[WeiMiCircleOnlineNumCell alloc] initWithHeaders:@[TEST_IMAGE_URL, TEST_IMAGE_URL,TEST_IMAGE_URL,TEST_IMAGE_URL,TEST_IMAGE_URL,TEST_IMAGE_URL] reuseIdentifier:@"onlineCell"];
        _onlineCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return _onlineCell;
}

- (UIButton *)segMaskBTN
{
    if (!_segMaskBTN) {
        
        _segMaskBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_segMaskBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _segMaskBTN;
}

- (WeiMiSegmentView *)segView
{
    if (!_segView) {
        WeiMiSegmentViewConfig *config = [[WeiMiSegmentViewConfig alloc] init];
        config.titleArray = @[@"全部", @"最新", @"精华"];
        config.titleFont = WeiMiSystemFontWithpx(22);
        _segView = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(0, self.contentFrame.origin.y, SCREEN_WIDTH, 41) config:config delegate:self];
    }
    return _segView;
}

- (UIButton *)onlineMaskBTN
{
    if (!_onlineMaskBTN) {
        
        _onlineMaskBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_onlineMaskBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _onlineMaskBTN;
}

- (UIButton *)commentBTN
{
    if (!_commentBTN) {
        
        _commentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBTN setImage:[UIImage imageNamed:@"wisper_icon_fatie"] forState:UIControlStateNormal];
        _commentBTN.frame = CGRectMake(0, 0, GetAdapterHeight(50), GetAdapterHeight(50));
        _commentBTN.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 15 - GetAdapterHeight(50)/2);
        [_commentBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBTN;
}
    
- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
    return _dataSource;
}

#pragma mark - Getter
- (NSDateFormatter *)dateFormatter {
    static NSDateFormatter* dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM月dd日 hh:mm"];
    });
    return dateFormatter;
}
    
#pragma mark - NetWork
//---- 圈子帖子列表
- (void)getCommentWithPostType:(POSTTYPE)postType ringId:(NSString *)ringId pageSize:(NSInteger)pageSize isRefresh:(BOOL)isRefresh
{
    NSInteger pageIndex = 1;
    if (!isRefresh) {//若不是刷新，而是切换,检查缓存

        [[self mutableArrayValueForKey:@"dataSource"] removeAllObjects];
        //                [_tableView.mj_footer endRefreshing];
        NSMutableArray *allArr = EncodeArrayFromDic(_cacheSource, [NSString stringWithFormat:@"%ld", (long)postType]);
        if (allArr.count) {
            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:allArr];
            [_tableView reloadData];
            return;
        }
    }
    
    //isAble=0不显示 1正常 2精华 3置顶 4首页 5推荐
    NSString *_isAble;
    switch (postType) {
        case POSTTYPE_ALL:
        {
            _isAble = @"1";
            pageIndex = _currentAllPage;
        }
        break;
        case POSTTYPE_NEWEST:
        {
            _isAble = @"1";
            pageIndex = _currentNewestPage;
        }
        break;
        case POSTTYPE_CREAM:
        {
            _isAble = @"2";
            pageIndex = _currentCreamPage;
        }
        break;
        case POSTTYPE_TOP:
        {
            _isAble = @"3";
        }
        break;
        default:
        {
            _isAble = @"0";
        }
        break;
    }
    
    WeiMiInvitationListRequest *request = [[WeiMiInvitationListRequest alloc] initWithIsAble:_isAble ringId:ringId  pageIndex:pageIndex pageSize:pageSize];
    WeiMiInvitationListResponse *response = [[WeiMiInvitationListResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {

            [response parseResponse:result];
            
            if (pageIndex == 1) {
                [self.dataSource removeAllObjects];
            }
            //数据源生成layout
            for (NSInteger i = 0; i < response.dataArr.count; i ++) {
                LWLayout* layout = [self layoutWithStatusModel:
                                    safeObjectAtIndex(response.dataArr, i)
                                                         index:i];
                [self.dataSource addObject:layout];
            }
            
            [strongSelf.tableView reloadData];
            switch (postType) {
                case POSTTYPE_ALL:
                {
                    _currentAllPage++;
//                    self.cacheSource[POSTTYPE_ALL] = [_dataSource mutableCopy];
                    [self.cacheSource setObject:[_dataSource mutableCopy] forKey:[NSString stringWithFormat:@"%ld", (long)POSTTYPE_ALL]];
                }
                break;
                case POSTTYPE_NEWEST:
                {
                    _currentNewestPage++;
//                    self.cacheSource[POSTTYPE_NEWEST] = [_dataSource mutableCopy];
                    [self.cacheSource setObject:[_dataSource mutableCopy] forKey:[NSString stringWithFormat:@"%ld", (long)POSTTYPE_NEWEST]];
                }
                break;
                case POSTTYPE_CREAM:
                {
                    _currentCreamPage++;
//                    self.cacheSource[POSTTYPE_CREAM] = [_dataSource mutableCopy];
                    [self.cacheSource setObject:[_dataSource mutableCopy] forKey:[NSString stringWithFormat:@"%ld", (long)POSTTYPE_CREAM]];
                }
                break;
                default:
                break;
            }
            [_tableView.mj_footer endRefreshing];
        }else if (!isRefresh)//不是刷新，且数据为空
        {
            [self.dataSource removeAllObjects];
            [_tableView reloadData];
        }
        else
        {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [_tableView.mj_header endRefreshing];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
    }];
}

///批量获取评论
//- (void)batchGetComment:(NSArray *)arr
//{
//    NSMutableArray *bacthArr = [NSMutableArray new];
//    
//    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[a, b, c, d]];
//    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
//        NSLog(@"succeed");
//        NSArray *requests = batchRequest.requestArray;
//        GetImageApi *a = (GetImageApi *)requests[0];
//        GetImageApi *b = (GetImageApi *)requests[1];
//        GetImageApi *c = (GetImageApi *)requests[2];
//        GetUserInfoApi *user = (GetUserInfoApi *)requests[3];
//        // deal with requests result ...
//    } failure:^(YTKBatchRequest *batchRequest) {
//        NSLog(@"failed");
//    }];
//}

#pragma mark - Actions
- (void)onButton:(UIButton *)btn
{
    if (btn == _segMaskBTN) {
        [[WeiMiPageSkipManager communityRT] open:[NSString stringWithFormat:@"WeiMiCircleListVC/%@", @"闺蜜私房话"]];
        return;
    }else if (btn == _onlineMaskBTN)
    {
        [[WeiMiPageSkipManager communityRT] open:[NSString stringWithFormat:@"WeiMiOnlineDetailVC/%@", @"闺蜜私房话"]];
    }else if (btn == _commentBTN)
    {
        if (_dto.ringTitle && _dto.ringId) {
            
            [WeiMiPageSkipManager skipIntoAddCommentVC:self title:_dto.ringTitle sID:_dto.ringId commentType:COMMENTTYPE_INVITATION];
        }
    }
}

#pragma mark - WeiMiSegmentViewDelegate
- (void)didSelectedAtIndex:(NSUInteger)index
{
    if (index == 0) {
        if (_postType == POSTTYPE_ALL) {
            return;
        }
        _postType = POSTTYPE_ALL;
        
    }else if (index == 1)
    {
        if (_postType == POSTTYPE_NEWEST) {
            return;
        }
        _postType = POSTTYPE_NEWEST;

    }else if (index == 2)
    {
        if (_postType == POSTTYPE_CREAM) {
            return;
        }
        _postType = POSTTYPE_CREAM;
        
    }
    [self getCommentWithPostType:_postType ringId:_dto.ringId pageSize:10 isRefresh:NO];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _topTopicDataSource.count;
    }
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"cell_0";
        WeiMiCircleTopTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiCircleTopTopicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLB.text = safeObjectAtIndex(_topTopicDataSource, indexPath.row);
        return cell;
    }
    
    static NSString* cellIdentifier = @"cellIdentifier";
    WeiMiCircleCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WeiMiCircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 35;
    }else
    {
//        return 20;
        if (self.dataSource.count >= indexPath.row) {
            WeiMiCircleLayout* layout = self.dataSource[indexPath.row];
            return layout.cellHeight;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.f;
    }
    return 0.1f;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] init];
//    view.backgroundColor = kClearColor;
//    return view;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    WeiMiInvitationVC *vc = [[WeiMiInvitationVC alloc] init];
//    vc.hidesBottomBarWhenPushed = YES;
//    vc.dto = ((WeiMiCircleLayout *)safeObjectAtIndex(_dataSource, indexPath.row)).statusModel;
//    [self.navigationController pushViewController:vc animated:YES];
    
    [WeiMiPageSkipManager skipIntoPostDetailVC:self dto:((WeiMiCircleLayout *)safeObjectAtIndex(_dataSource, indexPath.row)).statusModel popWithBaseNavColor:NO];
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
    
    _segView.frame = CGRectMake(0, self.topCell.bottom, SCREEN_WIDTH, 41);
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [_topCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + NAV_HEIGHT);
        make.height.mas_equalTo(70);
    }];
    
//    [_onlineCell mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(_topCell.mas_bottom);
//        make.left.right.mas_equalTo(_topCell);
//        make.height.mas_equalTo(45);
//    }];
    
//    [_onlineMaskBTN mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.edges.mas_equalTo(_onlineCell);
//    }];
//    
    [_segMaskBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(_topCell);
    }];
    
//    [_segView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(_onlineCell.mas_bottom);
//    }];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(_topCell);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_segView.mas_bottom);
    }];
    
//    [_onlineMaskBTN mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.bottom.mas_equalTo(-15);
//        make.centerX.mas_equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(50), 50));
//    }];

}


///-----------
- (void)confirgueCell:(WeiMiCircleCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    WeiMiCircleLayout* cellLayout = safeObjectAtIndex(_dataSource, indexPath.row);
    cell.cellLayout = cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(WeiMiCircleCell *)cell {
    
    __weak typeof(self) weakSelf = self;    
    cell.clickedAvatarCallback = ^(UITableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself showAvatarWithCell:(WeiMiCircleCell *)cell];
    };
    
}

#pragma mark - Actions


//查看头像
- (void)showAvatarWithCell:(WeiMiCircleCell *)cell {
    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.memberName]];
}

- (WeiMiCircleLayout *)layoutWithStatusModel:(WeiMiHotCommandDTO *)statusModel index:(NSInteger)index {
    WeiMiCircleLayout* layout = [[WeiMiCircleLayout alloc] initWithStatusModel:statusModel
                                                           index:index
                                                   dateFormatter:self.dateFormatter];
    return layout;
}

//#pragma mark - Data
////模拟下载数据
//- (void)fakeDownload {
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        if (self.needRefresh) {
//            [self.dataSource removeAllObjects];
//            NSMutableArray* fakes = [[NSMutableArray alloc] init];
//            [fakes addObjectsFromArray:self.fakeDatasource];
//            for (NSInteger i = 0; i < fakes.count; i ++) {
//                LWLayout* layout = [self layoutWithStatusModel:
//                                    [[StatusModel alloc] initWithDict:fakes[i]]
//                                                         index:i];
//                [self.dataSource addObject:layout];
//            }
//        }
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [self refreshComplete];
//        });
//    });
//}
//


@end
