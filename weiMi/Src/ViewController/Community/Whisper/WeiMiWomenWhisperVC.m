//
//  WeiMiWomenWhisperVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiWomenWhisperVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiCircleMouleCell.h"
#import "WeiMiCircleOnlineNumCell.h"
#import "WeiMiSegmentView.h"
#import "WeiMiCircleTopTopicCell.h"
#import "WeiMiWhisperTopCell.h"
#import "WeiMiWhisperInviteCell.h"

//刷新组件
#import "WeiMiRefreshComponents.h"
//批量请求
#import "YTKBatchRequest.h"
//帖子列表
#import "WeiMiFemalePostListRequest.h"
#import "WeiMiFemalePostListResponse.h"
#import "WeiMiMalePostListRequest.h"
#import "WeiMiMalePostListResponse.h"
//问答列表
#import "WeiMiFemaleRQRequest.h"
#import "WeiMiFemaleRQResponse.h"
#import "WeiMiMaleRQRequest.h"
#import "WeiMiMaleRQResponse.h"

#pragma mark -
#import "WeiMiPublishView.h"
#import "LWImageBrowser.h"
#import "WeiMiCircleCell.h"
#import "WeiMiCircleLayout.h"
#import "LWAlertView.h"


typedef NS_ENUM(NSInteger, CONTROLTYPE)
{
    CONTROLTYPE_MALE,//男生撸啊撸
    CONTROLTYPE_FEMAL,//女生悄悄话
};
//帖子类型  看帖/回答
typedef NS_ENUM(NSInteger, CELLTYPE) {
    CELLTYPE_INVITE,//看帖
    CELLTYPE_RQ,//问答
};

//圈子内帖子分类 最新帖子不用，因为帖子按时间分类倒排
typedef NS_ENUM(NSInteger, POSTTYPE)
{
    POSTTYPE_ALL = 0,//全部不用参数
    POSTTYPE_NEWEST = 1,
#warning 未确认
    POSTTYPE_CREAM = 2,//精华帖子
    POSTTYPE_TOP = 3,//置顶帖子
};

//1为未回答 2为最新 3为热门 4为置顶
typedef NS_ENUM(NSInteger, RQTYPE)
{
    RQTYPE_NEWEST = 0,
    RQTYPE_HOT = 1,
    RQTYPE_UNREPLAY = 2,
    RQTYPE_TOP = 3,
    
};

@interface WeiMiWomenWhisperVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,WeiMiSegmentViewDelegate, WeiMiPublishViewDelegate>
{
    
    BOOL _popWithBaseNavColor;
    //分页
    __block NSInteger _currentAllPage;//全部
    __block NSInteger _currentNewestPage;//最新
    __block NSInteger _currentCreamPage;//精华
    __block NSInteger _currentNewestRQPage;//最新问题
    __block NSInteger _currentHotRQPage;//热门问题
    __block NSInteger _currentUnreplyRQPage;//未回答
    
    CONTROLTYPE _contolType;//视图控制器类型 （男生撸啊撸 / 女生悄悄话）
    CELLTYPE _cellType;//cell类型
    POSTTYPE _postType;//圈子帖子分类key
    RQTYPE _rqType;//问答类型分类key
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) WeiMiSegmentView *segView;
@property (nonatomic, strong) WeiMiSegmentView *segView_2;

@property (nonatomic, strong) UIButton *commentBTN;//圆形评论按钮

/**帖子数据源*/
@property (nonatomic, strong) NSMutableArray *topTopicDataSource;//置顶帖子数据源
@property (nonatomic, strong) NSMutableArray *postDataSource;//帖子数据源列表
@property (nonatomic, strong) NSMutableDictionary *cachePostDataSource;//帖子数据源缓存
//问答数据源
@property (nonatomic, strong) NSMutableArray *rqDataSource;
@property (nonatomic, strong) NSMutableDictionary *cacheRqDataSource;//问答缓存数据源

@end


@implementation WeiMiWomenWhisperVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _currentCreamPage = 1;
        _currentNewestPage = 1;
        _currentAllPage = 1;
        _currentNewestRQPage = 1;
        _currentHotRQPage = 1;
        _currentUnreplyRQPage = 1;
        
        _cellType = CELLTYPE_INVITE;
        _postType = POSTTYPE_ALL;
        _rqType = RQTYPE_NEWEST;
        
        _topTopicDataSource = [NSMutableArray new];
        _postDataSource = [NSMutableArray new];
        _cachePostDataSource = [NSMutableDictionary new];
        _rqDataSource = [NSMutableArray new];
        _cacheRqDataSource = [NSMutableDictionary new];
        
        
        _topTopicDataSource = [NSMutableArray arrayWithArray:@[@"在线客服",
                                                         @"系统通知",]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _popWithBaseNavColor = [EncodeStringFromDic(self.params, @"popWithBaseNavColor")  isEqualToString: @"yes"] ? YES:NO;
    [self initNavgationItem];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
//    [self.contentView addSubview:self.topCell];
//    [self.contentView addSubview:self.onlineCell];
//    [self.contentView addSubview:self.segView];
//    
//    [self.contentView addSubview:self.onlineMaskBTN];
//    [self.contentView addSubview:self.segMaskBTN];
    [self.contentView addSubview:self.tableView];
    self.tableView.frame = self.contentFrame;
    [self.contentView addSubview:self.commentBTN];
    
    if ([_navId isEqualToString:kMaleTag]) {//男生撸啊撸
        _contolType = CONTROLTYPE_MALE;
    }else//女生悄悄话
    {
        _contolType = CONTROLTYPE_FEMAL;
    }
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        if (_cellType == CELLTYPE_INVITE) {
            [self getCommentWithPostType:_postType pageSize:10 isRefresh:YES];
        }else if (_cellType == CELLTYPE_RQ)
        {
            [self getRQWithPostType:_rqType pageSize:10 isRefresh:YES];
        }
    }];
    
    //下拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        
        if (_cellType == CELLTYPE_INVITE) {
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

            [self getCommentWithPostType:_postType pageSize:10 isRefresh:YES];
        }else if (_cellType == CELLTYPE_RQ)
        {
            switch (_rqType) {
                case RQTYPE_NEWEST:
                    _currentNewestRQPage = 1;
                    break;
                case RQTYPE_HOT:
                    _currentHotRQPage = 1;
                    break;
                case RQTYPE_UNREPLAY:
                    _currentUnreplyRQPage = 1;
                    break;
                case RQTYPE_TOP:
                    break;
                default:

                    break;
            }
            [self getRQWithPostType:_rqType pageSize:10 isRefresh:YES];
        }
    }];
    
    [self getCommentWithPostType:_postType pageSize:10 isRefresh:NO];
    
    [self.view setNeedsUpdateConstraints];
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
    self.popWithBaseNavColor = YES;
    
//    self.title = @"女生悄悄话";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
//    [self AddRightBtn:nil normal:@"wisper_icon_search" selected:nil action:^{
//        
//        
//    }];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (UIButton *)commentBTN
{
    if (!_commentBTN) {
        
        _commentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commentBTN setImage:[UIImage imageNamed:@"circle_icon_fatiezi"] forState:UIControlStateNormal];
        _commentBTN.frame = CGRectMake(0, 0, GetAdapterHeight(50), GetAdapterHeight(50));
        _commentBTN.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT - 15 - GetAdapterHeight(50)/2);
        [_commentBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBTN;
}


- (UISegmentedControl *)segControl
{
    if (!_segControl) {
        
        _segControl = [[UISegmentedControl alloc] initWithItems:@[@"看帖",@"问答"]];
        _segControl.frame = CGRectMake(10, 5, SCREEN_WIDTH - 20, 30);
        _segControl.tintColor = HEX_RGB(BASE_COLOR_HEX);
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:WeiMiSystemFontWithpx(22),NSFontAttributeName, HEX_RGB(BASE_COLOR_HEX), NSForegroundColorAttributeName,nil ,nil];
        [_segControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
        
        NSDictionary *highlightedAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [_segControl setTitleTextAttributes:highlightedAttributes forState:UIControlStateHighlighted];
        _segControl.selectedSegmentIndex=0;//默认选中的按钮索引
        [_segControl addTarget:self action:@selector(doSomethingInSegment:)forControlEvents:UIControlEventValueChanged];
    }
    return _segControl;
}

- (WeiMiSegmentView *)segView
{
    if (!_segView) {
        WeiMiSegmentViewConfig *config = [[WeiMiSegmentViewConfig alloc] init];
        config.titleArray = @[@"全部", @"最新", @"精华"];
        config.titleFont = WeiMiSystemFontWithpx(22);
        _segView = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41) config:config delegate:self];
    }
    return _segView;
}

- (WeiMiSegmentView *)segView_2
{
    if (!_segView_2) {
        WeiMiSegmentViewConfig *config = [[WeiMiSegmentViewConfig alloc] init];
        config.titleArray = @[@"最新问题", @"热门问题", @"未回答"];
        config.titleFont = WeiMiSystemFontWithpx(22);
        _segView_2 = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 41) config:config delegate:self];
    }
    return _segView_2;
}


#pragma mark - Actions
- (void)doSomethingInSegment:(UISegmentedControl *)sender
{
    NSInteger Index = sender.selectedSegmentIndex;
    switch (Index) {
        case 0://看帖
        {
            _segView.hidden = NO;
            _segView_2.hidden = YES;
            if (_cellType == CELLTYPE_INVITE) {
                return;
            }else
            {
                _cellType = CELLTYPE_INVITE;
//                [_tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(3, 2)] withRowAnimation:UITableViewRowAnimationAutomatic];
                [_tableView reloadData];
            }
        }
            break;
        case 1://回答
        {
            _segView.hidden = YES;
            _segView_2.hidden = NO;
            if (_cellType == CELLTYPE_RQ) {
                
                return;
            }else
            {
                _cellType = CELLTYPE_RQ;
                [self getRQWithPostType:_rqType pageSize:10 isRefresh:NO];
                [_tableView reloadData];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)onButton:(UIButton *)btn
{
    if (btn == _commentBTN)
    {
//        WeiMiPublishView *publishView = [[WeiMiPublishView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        WeiMiPublishView *publishView = [[WeiMiPublishView alloc] initWithTitleImgDic:@{@"发帖":@"wisper_icon_fatie", @"提问":@"wisper_icon_tiwen"} frame:[UIScreen mainScreen].bounds];
        publishView.delegate = self;
        [publishView show ];
    }
}

-(void)didSelectBtnWithBtnTag:(NSInteger)tag
{
    if (tag==1)//发帖
    {
        if (_contolType == CONTROLTYPE_MALE) {//男生撸啊撸帖子
            
            [WeiMiPageSkipManager skipIntoAddCommentVC:self title:@"男生撸啊撸" sID:nil commentType:COMMENTTYPE_MALEINVITATION];
        }else if(_contolType == CONTROLTYPE_FEMAL)//女生悄悄话帖子
        {
            [WeiMiPageSkipManager skipIntoAddCommentVC:self title:@"女生悄悄话" sID:nil commentType:COMMENTTYPE_FEMALEINVITATION];
        }

    }else if (tag==2)//提问
    {
        if (_contolType == CONTROLTYPE_MALE) {//男生撸啊撸问答
            
            [WeiMiPageSkipManager skipIntoAddCommentVC:self title:@"问答" sID:nil commentType:COMMENTTYPE_MALERQ];

        }else if(_contolType == CONTROLTYPE_FEMAL)//女生悄悄话问答
        {
            [WeiMiPageSkipManager skipIntoAddCommentVC:self title:@"问答" sID:nil commentType:COMMENTTYPE_FRMALERQ];

        }
    }else{
        DLog(@"CLOSE");
    }
}


#pragma mark - WeiMiSegmentViewDelegate
- (void)didSelectedAtIndex:(NSUInteger)index
{
    if (index == 0) {//全部 或者 最新问题
        if (_cellType == CELLTYPE_INVITE) {//帖子
            if (_postType == POSTTYPE_ALL) {
                return;
            }
            _postType = POSTTYPE_ALL;
        }else if (_cellType == CELLTYPE_RQ)//问答
        {
            if (_rqType == RQTYPE_NEWEST) {
                return;
            }
            _rqType = RQTYPE_NEWEST;
        }
        
    }else if (index == 1)//最新 或者 热门问题
    {
        if (_cellType == CELLTYPE_INVITE) {//帖子
            
            if (_postType == POSTTYPE_NEWEST) {
                return;
            }
            _postType = POSTTYPE_NEWEST;
        }else if (_cellType == CELLTYPE_RQ)//问答
        {
            if (_rqType == RQTYPE_HOT) {
                return;
            }
            _rqType = RQTYPE_HOT;

        }
    }else if (index == 2)// 精华 或者 未回答
    {
        if (_cellType == CELLTYPE_INVITE) {//帖子
            if (_postType == POSTTYPE_CREAM) {
                return;
            }
            _postType = POSTTYPE_CREAM;
            
        }else if (_cellType == CELLTYPE_RQ)//问答
        {
            if (_rqType == RQTYPE_UNREPLAY) {
                return;
            }
            _rqType = RQTYPE_UNREPLAY;
        }
    }
    
    if (_cellType == CELLTYPE_INVITE) {
        [self getCommentWithPostType:_postType pageSize:10 isRefresh:NO];
    }else if (_cellType == CELLTYPE_RQ)
    {
        [self getRQWithPostType:_rqType pageSize:10 isRefresh:NO];
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_cellType == CELLTYPE_RQ) {
        return 2;
    }
    return 5-1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
//    else if (section == 1) {
//        return _topTopicDataSource.count;
//    }
    else if (section == 1) {
        if (_cellType == CELLTYPE_RQ) {
            return 2+_rqDataSource.count;
        }
        return 2;
    }else if (section == 2) {
        return _topTopicDataSource.count;
    }
    return _postDataSource.count;
    //    return _lisDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {//女生悄悄话 最上cell
        
        static NSString *cellID = @"cell_0";
        WeiMiWhisperTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiWhisperTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if ([_navId isEqualToString:kMaleTag]) {//男生撸啊撸
            cell.titleLabel.text = @"男生撸啊撸";
            cell.subTitleLabel.text = @"好基友,一辈子,用力喊出来~撸~";
        }else {
            cell.titleLabel.text = @"女生悄悄话";
            cell.subTitleLabel.text = @"女生专属,最亲密的事,有你,有我~";
        }
        return cell;
    }
//    else if(indexPath.section == 1) {
//        
//        static NSString *cellID = @"cell_1";
//        WeiMiCircleTopTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            cell = [[WeiMiCircleTopTopicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        }
//        cell.titleLB.text = safeObjectAtIndex(_topTopicDataSource, indexPath.row);
//        return cell;
//    }
    else if (indexPath.section == 1)
    {
        
        if (_cellType == CELLTYPE_RQ && indexPath.row > 1) {//问答cell
            static NSString *cellID = @"cell_2_>1";
            WeiMiWhisperInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[WeiMiWhisperInviteCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            [cell setViewWithDTO:safeObjectAtIndex(_rqDataSource, indexPath.row - 2)];
            return cell;
        }
        // 全部 最新 精华
        //最新问题 热门问题 未回答
        static NSString *cellID = @"cell_2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == 1) {
                
                 [cell.contentView addSubview:self.segView];
                [cell.contentView addSubview:self.segView_2];
                _segView_2.hidden = YES;
            }else if (indexPath.row == 0)
            {
                [cell.contentView addSubview:self.segControl];
            }
        }
        return cell;
        
    }else if(indexPath.section == 2) {
        
        static NSString *cellID = @"cell_3";
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
        return 105;
    }
//    else if (indexPath.section == 1) {
//        return 35;
//    }
    else if (indexPath.section == 1) {
        if (_cellType == CELLTYPE_RQ && indexPath.row > 1) {
            return 61;
        }
        return 40;
    }else if (indexPath.section == 2) {
        return 35;
    }
    else
    {
        if (_postDataSource.count >= indexPath.row) {
            WeiMiCircleLayout* layout = _postDataSource[indexPath.row];
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
    if (_cellType == CELLTYPE_RQ) {
        
        if (section != 0 && section != 1 ) {
            return 0.0f;
        }
    }else
    {
        if (section == 4) {
            return 0.0f;
        }
    }
    
    return 10.0f;
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
    
    if (_cellType == CELLTYPE_INVITE) {
        
        [WeiMiPageSkipManager skipIntoPostDetailVC:self dto:((WeiMiCircleLayout *)safeObjectAtIndex(_postDataSource, indexPath.row)).statusModel popWithBaseNavColor:NO];
    }else
    {
        if (indexPath.section == 1 && indexPath.row > 1) {
            
            [WeiMiPageSkipManager skipIntoRQDetailVC:self dto:safeObjectAtIndex(_rqDataSource, indexPath.row - 2)];
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
    
//    _segView.frame = CGRectMake(0, self.onlineCell.bottom, SCREEN_WIDTH, 41);
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];

    
    //    [_segView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(_onlineCell.mas_bottom);
    //    }];
    
    //    [_onlineMaskBTN mas_makeConstraints:^(MASConstraintMaker *make) {
    //
    //        make.bottom.mas_equalTo(-15);
    //        make.centerX.mas_equalTo(self.view);
    //        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(50), 50));
    //    }];
    
}

///----------- 帖子cell
- (void)confirgueCell:(WeiMiCircleCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    WeiMiCircleLayout* cellLayout = safeObjectAtIndex(_postDataSource, indexPath.row);
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
- (void)getCommentWithPostType:(POSTTYPE)postType pageSize:(NSInteger)pageSize isRefresh:(BOOL)isRefresh
{
    NSInteger pageIndex = 1;
    if (!isRefresh) {//若不是刷新，而是切换,检查缓存
        
        [[self mutableArrayValueForKey:@"postDataSource"] removeAllObjects];
        //                [_tableView.mj_footer endRefreshing];
        NSMutableArray *allArr = EncodeArrayFromDic(_cachePostDataSource, [NSString stringWithFormat:@"%d", postType]);
        if (allArr.count) {
            [[self mutableArrayValueForKey:@"postDataSource"] addObjectsFromArray:allArr];
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
    
    WeiMiBaseRequest *request;
    WeiMiBaseResponse *response;
    if (_contolType == CONTROLTYPE_MALE) {
        request = [[WeiMiMalePostListRequest alloc] initWithIsAble:_isAble pageIndex:pageIndex pageSize:pageSize];
       response = [[WeiMiMalePostListResponse alloc] init];
    }else
    {
        request = [[WeiMiFemalePostListRequest alloc] initWithIsAble:_isAble pageIndex:pageIndex pageSize:pageSize];
        response = [[WeiMiFemalePostListResponse alloc] init];
    }
//    WeiMiFemalePostListRequest *request = [[WeiMiFemalePostListRequest alloc] initWithIsAble:_isAble pageIndex:pageIndex pageSize:pageSize];
//    WeiMiFemalePostListResponse *response = [[WeiMiFemalePostListResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            
            [response parseResponse:result];
            
            if (pageIndex == 1) {
                [self.postDataSource removeAllObjects];
            }
            //数据源生成layout
            if (_contolType == CONTROLTYPE_MALE) {
                for (NSInteger i = 0; i < ((WeiMiMalePostListResponse *)response).dataArr.count; i ++) {
                    LWLayout* layout = [self layoutWithStatusModel:
                                        safeObjectAtIndex(((WeiMiMalePostListResponse *)response).dataArr, i)
                                                             index:i];
                    [self.postDataSource addObject:layout];
                }
            }else if (_contolType == CONTROLTYPE_FEMAL)
            {
                for (NSInteger i = 0; i < ((WeiMiFemalePostListResponse *)response).dataArr.count; i ++) {
                    LWLayout* layout = [self layoutWithStatusModel:
                                        safeObjectAtIndex(((WeiMiFemalePostListResponse *)response).dataArr, i)
                                                             index:i];
                    [self.postDataSource addObject:layout];
                }
            }
            
            
            [strongSelf.tableView reloadData];
            switch (postType) {
                case POSTTYPE_ALL:
                {
                    _currentAllPage++;
//                    self.cachePostDataSource[POSTTYPE_ALL] = [self.postDataSource mutableCopy];
                    [self.cachePostDataSource setObject:[self.postDataSource mutableCopy] forKey:[NSString stringWithFormat:@"%d", POSTTYPE_ALL]];
                }
                    break;
                case POSTTYPE_NEWEST:
                {
                    _currentNewestPage++;
//                    self.cachePostDataSource[POSTTYPE_NEWEST] = [self.postDataSource mutableCopy];
                    [self.cachePostDataSource setObject:[self.postDataSource mutableCopy] forKey:[NSString stringWithFormat:@"%d", POSTTYPE_NEWEST]];
                }
                    break;
                case POSTTYPE_CREAM:
                {
                    _currentCreamPage++;
//                    self.cachePostDataSource[POSTTYPE_CREAM] = [self.postDataSource mutableCopy];
                    [self.cachePostDataSource setObject:[self.postDataSource mutableCopy] forKey:[NSString stringWithFormat:@"%d", POSTTYPE_CREAM]];
                }
                    break;
                default:
                    break;
            }
            [_tableView.mj_footer endRefreshing];
        }else if (!isRefresh)//不是刷新，且数据为空
        {
            [_postDataSource removeAllObjects];
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

//问答列表
- (void)getRQWithPostType:(RQTYPE)rqType pageSize:(NSInteger)pageSize isRefresh:(BOOL)isRefresh
{
    NSInteger pageIndex = 1;
    if (!isRefresh) {//若不是刷新，而是切换,检查缓存
        
        [[self mutableArrayValueForKey:@"rqDataSource"] removeAllObjects];
        //                [_tableView.mj_footer endRefreshing];
        NSMutableArray *allArr = EncodeArrayFromDic(_cacheRqDataSource, [NSString stringWithFormat:@"%ld", (long)rqType]);
        if (allArr.count) {
            [[self mutableArrayValueForKey:@"rqDataSource"] addObjectsFromArray:allArr];
            [_tableView reloadData];
            return;
        }
    }
    //isAble :1为未回答 2为最新 3为热门 4为置顶
    NSString *_isAble;
    switch (_rqType) {
        case RQTYPE_NEWEST:
        {
            _isAble = @"2";
            pageIndex = _currentNewestRQPage;
        }
            break;
        case RQTYPE_HOT:
        {
            _isAble = @"3";
            pageIndex = _currentHotRQPage;
        }
            break;
        case RQTYPE_UNREPLAY:
        {
            _isAble = @"1";
            pageIndex = _currentUnreplyRQPage;
        }
            break;
        case RQTYPE_TOP:
        {
            _isAble = @"4";
        }
            break;
        default:
        {
        }
            break;
    }
    
    WeiMiBaseRequest *request;
    WeiMiBaseResponse *response;
    if (_contolType == CONTROLTYPE_MALE) {
        request = [[WeiMiMaleRQRequest alloc] initWithIsAble:_isAble pageIndex:pageIndex pageSize:pageSize];
        response = [[WeiMiMaleRQResponse alloc] init];
    }else
    {
        request = [[WeiMiFemaleRQRequest alloc] initWithIsAble:_isAble pageIndex:pageIndex pageSize:pageSize];
        response = [[WeiMiFemaleRQResponse alloc] init];
    }
    
//    WeiMiFemaleRQRequest *request = [[WeiMiFemaleRQRequest alloc] initWithIsAble:_isAble pageIndex:pageIndex pageSize:pageSize];
//    WeiMiFemaleRQResponse *response = [[WeiMiFemaleRQResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            
            [response parseResponse:result];
            
            if (pageIndex == 1) {
                [self.rqDataSource removeAllObjects];
            }
            
            if (_contolType == CONTROLTYPE_MALE) {
                [self.rqDataSource addObjectsFromArray:((WeiMiMaleRQResponse *)response).dataArr];

            }else if (_contolType == CONTROLTYPE_FEMAL)
            {
                [self.rqDataSource addObjectsFromArray:((WeiMiFemaleRQResponse *)response).dataArr];

            }

            [strongSelf.tableView reloadData];
            switch (rqType) {
                case RQTYPE_NEWEST:
                {
                    _currentNewestRQPage++;
//                    self.cacheRqDataSource[RQTYPE_NEWEST] = [self.rqDataSource mutableCopy];
                    [self.self.cacheRqDataSource setObject:[self.self.rqDataSource mutableCopy] forKey:[NSString stringWithFormat:@"%ld", (long)RQTYPE_NEWEST]];
                }
                    break;
                case RQTYPE_HOT:
                {
                    _currentHotRQPage++;
//                    self.cacheRqDataSource[RQTYPE_HOT] = [self.rqDataSource mutableCopy];
                    [self.self.cacheRqDataSource setObject:[self.self.rqDataSource mutableCopy] forKey:[NSString stringWithFormat:@"%ld", (long)RQTYPE_HOT]];
                }
                    break;
                case RQTYPE_UNREPLAY:
                {
                    _currentUnreplyRQPage++;
//                    self.cacheRqDataSource[RQTYPE_UNREPLAY] = [self.rqDataSource mutableCopy];
                    [self.self.cacheRqDataSource setObject:[self.self.rqDataSource mutableCopy] forKey:[NSString stringWithFormat:@"%ld", (long)RQTYPE_UNREPLAY]];
                }
                    break;
                default:
                    break;
            }
            [_tableView.mj_footer endRefreshing];
        }else if (!isRefresh)//不是刷新，且数据为空
        {
            [_postDataSource removeAllObjects];
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

@end
