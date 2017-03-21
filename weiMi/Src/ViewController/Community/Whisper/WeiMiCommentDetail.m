//
//  WeiMiCommentDetail.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommentDetail.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiRQDetailAnonymousCell.h"
#import "UILabel+NotiLabel.h"
#import "WeiMiRQDetailCell.h"
#import "WeiMiCommentTopicCell.h"
#import <OHActionSheet.h>
#import "WeiMiPublishView.h"

#pragma mark -
#import "LWImageBrowser.h"
#import "WeiMiInviteCommentCell.h"
#import "WeiMiInviteCommentLayout.h"
#import "WeiMiInviteCommentStatusModel.h"
#import "CommentView.h"
#import "CommentModel.h"
#import "LWAlertView.h"

@interface WeiMiCommentDetail ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WeiMiPublishViewDelegate>
{
    /**数据源*/
    //    NSMutableArray *_dataSource;
}
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiRQDetailTopicDTO *dto;
@property (nonatomic, strong) UILabel *notiEmptyLabel;

//--------------
@property (nonatomic,strong) NSArray* fakeDatasource;
@property (nonatomic,strong) CommentView* commentView;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,assign,getter = isNeedRefresh) BOOL needRefresh;
@property (nonatomic,strong) CommentModel* postComment;

@end

@implementation WeiMiCommentDetail

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dto = [[WeiMiRQDetailTopicDTO alloc] init];
        //        _dataSource = [NSMutableArray arrayWithArray:@[@"在线客服",
        //                                                       @"系统通知",
        //                                                       @"我的消息"]];
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
    
    _needRefresh = YES;
    [self fakeDownload];
    

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
    self.title = @"评论详情";
    
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
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

- (UILabel *)notiEmptyLabel
{
    if (!_notiEmptyLabel) {
        
        _notiEmptyLabel = [UILabel footerNotiLabelWithTitle:@"还没有人回答哦" textAlignment:NSTextAlignmentCenter];
        _notiEmptyLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(200));
        _notiEmptyLabel.font = WeiMiSystemFontWithpx(22);
        _notiEmptyLabel.backgroundColor = kWhiteColor;
    }
    return _notiEmptyLabel;
}

#pragma mark - Actions
-(void)didSelectBtnWithBtnTag:(NSInteger)tag
{
    if (tag==1)
    {
        NSLog(@"111");
    }else if (tag==2)
    {
        NSLog(@"222");
    }else{
        NSLog(@"CLOSE");
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    
    if (_dataSource.count == 0) {
        return 1;
    }
    return _dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {

        static NSString *cellID = @"cell_other";
        
        WeiMiCommentTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiCommentTopicCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setViewWithDTO:_dto];
        return cell;
    }
    
    //暂无回答
    if (_dataSource.count == 0) {
        static NSString *cellID = @"notiCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.textColor = kGrayColor;
            cell.textLabel.text = @"暂无回答";
        }
        return cell;
    }
    
    static NSString *cellID = @"cell_other";
    
    WeiMiInviteCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiInviteCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0) {
        return [WeiMiRQDetailCell getHeightWithDTO:_dto];
    }
    
    if (_dataSource.count == 0) {
        return 50;
    }
    
    if (self.dataSource.count > 0) {
        WeiMiInviteCommentLayout* layout = self.dataSource[indexPath.row];
        return layout.cellHeight;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (_dataSource.count == 0) {
        return self.notiEmptyLabel;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 10.0f;
    }
    
    if (_dataSource.count == 0 && section == 1) {
        return GetAdapterHeight(200);
    }
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

#pragma mark - Constraints
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}

///-----------
- (void)confirgueCell:(WeiMiInviteCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    WeiMiInviteCommentLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    [self callbackWithCell:cell];
}

- (void)callbackWithCell:(WeiMiInviteCommentCell *)cell {
    
    __weak typeof(self) weakSelf = self;
    cell.clickedZanButtonCallback = ^(WeiMiInviteCommentCell* cell, UIButton *btn) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself tableViewCell:cell didClickedLikeButtonWithIsLike:YES];
    };
    
    //    cell.clickedCommentButtonCallback = ^(TableViewCell* cell) {
    //        __strong typeof(weakSelf) sself = weakSelf;
    //        [sself commentWithCell:cell];
    //    };
    //
    //    cell.clickedReCommentCallback = ^(TableViewCell* cell,CommentModel* model) {
    //        __strong typeof(weakSelf) sself = weakSelf;
    //        [sself reCommentWithCell:cell commentModel:model];
    //    };
    
    
    cell.clickedAvatarCallback = ^(WeiMiInviteCommentCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself showAvatarWithCell:cell];
    };
    
    
}

//查看头像
- (void)showAvatarWithCell:(WeiMiInviteCommentCell *)cell {
    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.model.memberName]];
}



#pragma mark - Actions
//点赞
- (void)tableViewCell:(WeiMiInviteCommentCell *)cell didClickedLikeButtonWithIsLike:(BOOL)isLike {
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
    imgView.image = screenshot;
    [self.tableView addSubview:imgView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [imgView removeFromSuperview];
    });
    
    WeiMiInviteCommentLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    
    WeiMiInviteCommentStatusModel* statusModel = layout.statusModel;
    statusModel.isLike = isLike;
    layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

////开始评论
//- (void)commentWithCell:(TableViewCell *)cell  {
//    self.postComment.from = @"Waynezxcv的粉丝";
//    self.postComment.to = @"";
//    self.postComment.index = cell.indexPath.row;
//    self.commentView.placeHolder = @"评论";
//    if (![self.commentView.textView isFirstResponder]) {
//        [self.commentView.textView becomeFirstResponder];
//    }
//}
//
////开始回复评论
//- (void)reCommentWithCell:(TableViewCell *)cell commentModel:(CommentModel *)commentModel {
//    self.postComment.from = @"waynezxcv的粉丝";
//    self.postComment.to = commentModel.to;
//    self.postComment.index = commentModel.index;
//    self.commentView.placeHolder = [NSString stringWithFormat:@"回复%@:",commentModel.to];
//    if (![self.commentView.textView isFirstResponder]) {
//        [self.commentView.textView becomeFirstResponder];
//    }
//}


//查看头像
//- (void)showAvatarWithCell:(TableViewCell *)cell {
//    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.name]];
//}



- (WeiMiInviteCommentLayout *)layoutWithStatusModel:(WeiMiInviteCommentStatusModel *)statusModel index:(NSInteger)index {
    WeiMiInviteCommentLayout* layout = [[WeiMiInviteCommentLayout alloc] initWithStatusModel:statusModel
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
            [fakes addObjectsFromArray:self.fakeDatasource];
            for (NSInteger i = 0; i < fakes.count; i ++) {
                LWLayout* layout = [self layoutWithStatusModel:
                                    [[WeiMiInviteCommentStatusModel alloc] initWithDict:fakes[i]]
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
    
    WeiMiInviteCommentLayout* layout = [self.dataSource objectAtIndex:model.index];
    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.commentArr];
    NSDictionary* newComment = @{@"from":model.from,
                                 @"to":model.to,
                                 @"content":model.content};
    [newCommentLists addObject:newComment];
    WeiMiInviteCommentStatusModel* statusModel = layout.statusModel;
    statusModel.commentList = newCommentLists;
    layout = [self layoutWithStatusModel:statusModel index:model.index];
    [self.dataSource replaceObjectAtIndex:model.index withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:1]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSArray *)fakeDatasource {
    if (_fakeDatasource) {
        return _fakeDatasource;
    }
    _fakeDatasource =
    @[@{@"type":@"image",
        @"name":@"型格志style",
        @"avatar":@"http://tp4.sinaimg.cn/5747171147/50/5741401933/0",
        @"date":@"1459668442",
        @"floor":@"1楼",
        @"level":@"lv5",
        @"content":@"春天卫衣的正确打开方式~",
        @"commentList":@[@{@"from":@"SIZE潮流生活",
                           @"to":@"waynezxcv",
                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
        @"likeNum":@"5",
        @"isLike":@(NO),},
      
      @{@"type":@"image",
        @"name":@"型格志style",
        @"avatar":@"http://tp4.sinaimg.cn/5747171147/50/5741401933/0",
        @"date":@"1459668442",
        @"floor":@"1楼",
        @"level":@"lv5",
        @"content":@"春天卫衣的正确打开方式~",
        @"commentList":@[@{@"from":@"SIZE潮流生活",
                           @"to":@"waynezxcv",
                           @"content":@"nice~使用Gallop。支持异步绘制，让滚动如丝般顺滑。"}],
        @"likeNum":@"5",
        @"isLike":@(NO),}
      ];
    
    return _fakeDatasource;
}



@end
