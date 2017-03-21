//
//  WeiMiCircleListVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleListVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiCircleMouleCell.h"
#import "WeiMiCircleOnlineNumCell.h"
#import "WeiMiSegmentView.h"
#import "WeiMiCircleTopTopicCell.h"


#pragma mark -
#import "LWImageBrowser.h"
#import "TableViewCell.h"
#import "StatusModel.h"
#import "CellLayout.h"
#import "CommentView.h"
#import "CommentModel.h"
#import "LWAlertView.h"

@interface WeiMiCircleListVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,WeiMiSegmentViewDelegate>
{
    /**数据源*/
    NSMutableArray *_topTopicDataSource;
    NSMutableArray *_lisDataSource;
    
    NSArray *_imgArr;
    BOOL _popWithBaseNavColor;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiSegmentView *segView;


//--------------
@property (nonatomic,strong) NSArray* fakeDatasource;
@property (nonatomic,strong) CommentView* commentView;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic,strong) CommentModel* postComment;

@end

@interface WeiMiCircleListVC ()

@end

@implementation WeiMiCircleListVC

- (instancetype)init
{
    self = [super init];
    if (self) {

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

    [self.contentView addSubview:self.segView];
    [self.contentView addSubview:self.tableView];
    
    _needRefresh = YES;
    [self fakeDownload];
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
    self.title = EncodeStringFromDic(self.params, @"title");
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:nil normal:@"icon_more_black" selected:nil action:^{
        
        
    }];
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


#pragma mark - Actions
- (void)onButton:(UIButton *)btn
{
//    [[WeiMiPageSkipManager communityRT] open:[NSString stringWithFormat:@"WeiMiCircleListVC/%@", @"闺蜜私房话"]];
}

#pragma mark - WeiMiSegmentViewDelegate
- (void)didSelectedAtIndex:(NSUInteger)index
{
    if (index == 0) {
        
    }else if (index == 1)
    {
        
    }else if (index == 2)
    {
        
    }
    [_tableView reloadData];
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
    //    return _lisDataSource.count;
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
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
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
            CellLayout* layout = self.dataSource[indexPath.row];
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

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(_segView.mas_bottom).offset(1);
    }];
}


///-----------
- (void)confirgueCell:(TableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    CellLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(TableViewCell *)cell {
    
    __weak typeof(self) weakSelf = self;
    cell.clickedLikeButtonCallback = ^(TableViewCell* cell,BOOL isLike) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell didClickedLikeButtonWithIsLike:isLike];
    };
    
    cell.clickedCommentButtonCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself commentWithCell:cell];
    };
    
    cell.clickedReCommentCallback = ^(TableViewCell* cell,CommentModel* model) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself reCommentWithCell:cell commentModel:model];
    };
    
    cell.clickedOpenCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself openTableViewCell:cell];
    };
    
    cell.clickedCloseCellCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself closeTableViewCell:cell];
    };
    
    cell.clickedAvatarCallback = ^(TableViewCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself showAvatarWithCell:cell];
    };
    
    cell.clickedImageCallback = ^(TableViewCell* cell,NSInteger imageIndex) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell showImageBrowserWithImageIndex:imageIndex];
    };
}

#pragma mark - Actions
//点赞
- (void)tableViewCell:(TableViewCell *)cell didClickedLikeButtonWithIsLike:(BOOL)isLike {
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    
    CellLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    NSMutableArray* newLikeList = [[NSMutableArray alloc] initWithArray:layout.statusModel.likeList];
    if (isLike) {
        [newLikeList addObject:@"waynezxcv的粉丝"];
    }
    else {
        [newLikeList removeObject:@"waynezxcv的粉丝"];
        
    }
    StatusModel* statusModel = layout.statusModel;
    statusModel.likeList = newLikeList;
    statusModel.isLike = isLike;
    layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

//开始评论
- (void)commentWithCell:(TableViewCell *)cell  {
    self.postComment.from = @"Waynezxcv的粉丝";
    self.postComment.to = @"";
    self.postComment.index = cell.indexPath.row;
    self.commentView.placeHolder = @"评论";
    if (![self.commentView.textView isFirstResponder]) {
        [self.commentView.textView becomeFirstResponder];
    }
}

//开始回复评论
- (void)reCommentWithCell:(TableViewCell *)cell commentModel:(CommentModel *)commentModel {
    self.postComment.from = @"waynezxcv的粉丝";
    self.postComment.to = commentModel.to;
    self.postComment.index = commentModel.index;
    self.commentView.placeHolder = [NSString stringWithFormat:@"回复%@:",commentModel.to];
    if (![self.commentView.textView isFirstResponder]) {
        [self.commentView.textView becomeFirstResponder];
    }
}

//点击查看大图
- (void)tableViewCell:(TableViewCell *)cell showImageBrowserWithImageIndex:(NSInteger)imageIndex {
    NSMutableArray* tmps = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < cell.cellLayout.imagePostions.count; i ++) {
        LWImageBrowserModel* model = [[LWImageBrowserModel alloc]
                                      initWithplaceholder:nil
                                      thumbnailURL:[NSURL URLWithString:[cell.cellLayout.statusModel.imgs objectAtIndex:i]]
                                      HDURL:[NSURL URLWithString:[cell.cellLayout.statusModel.imgs objectAtIndex:i]]
                                      containerView:cell.contentView
                                      positionInContainer:CGRectFromString(cell.cellLayout.imagePostions[i])
                                      index:i];
        [tmps addObject:model];
    }
    LWImageBrowser* browser = [[LWImageBrowser alloc] initWithImageBrowserModels:tmps
                                                                    currentIndex:imageIndex];
    
    [browser show];
}

//查看头像
- (void)showAvatarWithCell:(TableViewCell *)cell {
    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.name]];
}


//展开Cell
- (void)openTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    StatusModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initContentOpendLayoutWithStatusModel:model
                                                                                index:cell.indexPath.row
                                                                        dateFormatter:self.dateFormatter];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

//折叠Cell
- (void)closeTableViewCell:(TableViewCell *)cell {
    CellLayout* layout =  [self.dataSource objectAtIndex:cell.indexPath.row];
    StatusModel* model = layout.statusModel;
    CellLayout* newLayout = [[CellLayout alloc] initWithStatusModel:model
                                                              index:cell.indexPath.row
                                                      dateFormatter:self.dateFormatter];
    
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:newLayout];
    [self.tableView beginUpdates];
    [self.tableView reloadRowsAtIndexPaths:@[cell.indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

//发表评论
- (void)postCommentWithCommentModel:(CommentModel *)model {
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:model.index inSection:0]];
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    
    CellLayout* layout = [self.dataSource objectAtIndex:model.index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.commentList];
    NSDictionary* newComment = @{@"from":model.from,
                                 @"to":model.to,
                                 @"content":model.content};
    [newCommentLists addObject:newComment];
    StatusModel* statusModel = layout.statusModel;
    statusModel.commentList = newCommentLists;
    layout = [self layoutWithStatusModel:statusModel index:model.index];
    [self.dataSource replaceObjectAtIndex:model.index withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CellLayout *)layoutWithStatusModel:(StatusModel *)statusModel index:(NSInteger)index {
    CellLayout* layout = [[CellLayout alloc] initWithStatusModel:statusModel
                                                           index:index
                                                   dateFormatter:self.dateFormatter];
    return layout;
}

#pragma mark - Data
//模拟下载数据
- (void)fakeDownload {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.needRefresh) {
            [self.dataSource removeAllObjects];
            NSMutableArray* fakes = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < 10; i ++) {
                [fakes addObjectsFromArray:self.fakeDatasource];
            }
            for (NSInteger i = 0; i < fakes.count; i ++) {
                LWLayout* layout = [self layoutWithStatusModel:
                                    [[StatusModel alloc] initWithDict:fakes[i]]
                                                         index:i];
                [self.dataSource addObject:layout];
            }
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self refreshComplete];
        });
    });
}

//模拟刷新完成
- (void)refreshComplete {
    [self.tableView reloadData];
    self.needRefresh = NO;
}

#pragma mark - Getter
- (CommentView *)commentView {
    if (_commentView) {
        return _commentView;
    }
    __weak typeof(self) wself = self;
    _commentView = [[CommentView alloc]
                    initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 54.0f)
                    sendBlock:^(NSString *content) {
                        __strong  typeof(wself) swself = wself;
                        swself.postComment.content = content;
                        [swself postCommentWithCommentModel:swself.postComment];
                    }];
    return _commentView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource) {
        return _dataSource;
    }
    _dataSource = [[NSMutableArray alloc] init];
    return _dataSource;
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

- (CommentModel *)postComment {
    if (_postComment) {
        return _postComment;
    }
    _postComment = [[CommentModel alloc] init];
    return _postComment;
}


- (NSArray *)fakeDatasource {
    if (_fakeDatasource) {
        return _fakeDatasource;
    }
    _fakeDatasource =
    @[@{@"type":@"image",
        @"name":@"型格志style",
        @"avatar":@"http://tp4.sinaimg.cn/5747171147/50/5741401933/0",
        @"sex":@"♂",
        @"title":@"春天卫衣的正确打开方式~",
        @"tag":@"荐",
        @"content":@"春天卫衣的正确打开方式~",
        @"date":@"1459668442",
        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jeloxwhnj30fu0g0ta5.jpg",
                  @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelpn9bdj30b40gkgmh.jpg",
                  @"http://ww1.sinaimg.cn/mw690/006gWxKPgw1f2jelriw1bj30fz0g175g.jpg",
                  @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelt1kh5j30b10gmt9o.jpg",
                  @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jeluxjcrj30fw0fz0tx.jpg",
                  @"http://ww3.sinaimg.cn/mw690/006gWxKPgw1f2jelzxngwj30b20godgn.jpg",
                  @"http://ww2.sinaimg.cn/mw690/006gWxKPgw1f2jelwmsoej30fx0fywfq.jpg",
                  @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jem32ccrj30xm0sdwjt.jpg",
                  @"http://ww4.sinaimg.cn/mw690/006gWxKPgw1f2jelyhutwj30fz0fxwfr.jpg",],
        @"statusID":@"8",
        @"commentList":@[@{@"from":@"SIZE潮流生活",
                           @"to":@"waynezxcv",
                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
        @"isLike":@(NO),
        @"likeList":@[@"waynezxcv"]},
      
      @{@"type":@"image",
        @"name":@"SIZE潮流生活",
        @"avatar":@"http://tp2.sinaimg.cn/1829483361/50/5753078359/1",
        @"sex":@"♀",
        @"title":@"春天卫衣的正确打开方式~",
        @"tag":@"精",
        @"content":@"近日[心][心][心][心][心][心][face]，adidas Originals为经典鞋款Stan Smith打造Primeknit版本，并带来全新的“OG”系列。简约的鞋身采用白色透气Primeknit针织材质制作，再将Stan Smith代表性的绿、红、深蓝三个元年色调融入到鞋舌和后跟点缀，最后搭载上米白色大底来保留其复古风味。据悉该鞋款将在今月登陆全球各大adidas Originals指定店舖。",
        @"date":@"1459668442",
        @"imgs":@[@"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hgxij20lo0egwgc.jpg",
                  @"http://ww3.sinaimg.cn/mw690/6d0bb361gw1f2jim2hsg6j20lo0egwg2.jpg",
                  @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2d7nfj20lo0eg40q.jpg",
                  @"http://ww1.sinaimg.cn/mw690/6d0bb361gw1f2jim2hka3j20lo0egdhw.jpg",
                  @"http://ww2.sinaimg.cn/mw690/6d0bb361gw1f2jim2hq61j20lo0eg769.jpg"],
        @"statusID":@"1",
        @"commentList":@[@{@"from":@"SIZE潮流生活",
                           @"to":@"",
                           @"content":@"使用Gallop来快速构建图文混排界面。享受如丝般顺滑的滚动体验。"},
                         @{@"from":@"waynezxcv",
                           @"to":@"SIZE潮流生活",
                           @"content":@"哈哈哈哈"},
                         @{@"from":@"SIZE潮流生活",
                           @"to":@"waynezxcv",
                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
        @"isLike":@(NO),
        @"likeList":@[@"waynezxcv",@"伊布拉希莫维奇",@"权志龙",@"郜林",@"扎克伯格"]}
      ];
    
    return _fakeDatasource;
}



@end
