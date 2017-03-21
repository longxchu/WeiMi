//
//  WeiMiRQDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiRQDetailVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiRQDetailAnonymousCell.h"
#import "UILabel+NotiLabel.h"
#import "WeiMiRQDetailCell.h"
#import "WeiMiRQDetailCell.h"
#import <OHActionSheet.h>
#import <OHAlertView.h>
#import "WeiMiPublishView.h"
//----- 分享
#import "SimpleShare.h"
//----- 聊天键盘
#import "WeiMiRQChatBar.h"
//#import "WeiMiInvitationChatBar.h"
//----- 富文本cell
#import "LWImageBrowser.h"
#import "WeiMiRQCommentCell.h"
#import "WeiMiRQCommentLayout.h"
#import "WeiMiRQCommentModel.h"
//#import "CommentModel.h"
#import "LWAlertView.h"
//----- 刷新组件
#import "WeiMiRefreshComponents.h"
//----- request
//男生问答
#import "WeiMiMaleRQRequest.h"
#import "WeiMiMaleRQResponse.h"
//女生问答
#import "WeiMiFemaleRQRequest.h"
#import "WeiMiFemaleRQResponse.h"
//回答问题
#import "WeiMiAddRQRequest.h"
#import "WeiMiRQReplyListRequest.h"
#import "WeiMiRQReplyListResponse.h"

@interface WeiMiRQDetailVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, WeiMiPublishViewDelegate,UITextViewDelegate>
{
    /**数据源*/
//    NSMutableArray *_dataSource;
    
    NSInteger _currentPage;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
//@property (nonatomic, strong) WeiMiRQDetailTopicDTO *dto;
@property (nonatomic, strong) UILabel *notiEmptyLabel;

//-------------- 评论回复
@property (nonatomic, strong) WeiMiRQChatBar *chatBar;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,strong) WeiMiAddRQRequest* postCommentRequest;
@end



@implementation WeiMiRQDetailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        _dto = [[WeiMiRQDetailTopicDTO alloc] init];
        _currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    

    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    
    [self.view setNeedsUpdateConstraints];
    [self.view addSubview:self.chatBar];
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getCommentWithQId:self.dto.qtId pageIndex:_currentPage pageSize:10];
    }];
    
    [self getCommentWithQId:self.dto.qtId pageIndex:_currentPage pageSize:10];
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
    self.title = @"问答详情";
    
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:nil normal:@"icon_more_black" selected:@"icon_more_black" action:^{
        
        SS(strongSelf);
        [OHActionSheet showFromView:strongSelf.view title:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"收藏",@"举报",@"分享"] completion:^(OHActionSheet *sheet, NSInteger buttonIndex) {
            
            switch (buttonIndex) {
                case 0:
                {
                    [strongSelf presentSheet:@"收藏成功"];
                }
                    break;
                case 1:
                {
                }
                    break;
                case 2:
                {
                    WeiMiPublishView *publishView = [[WeiMiPublishView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                    publishView.delegate = self;
                    [publishView show ];
                }
                    break;
                default:
                    break;
            }
        }];

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

- (WeiMiRQChatBar *)chatBar
{
    if (!_chatBar) {
        
        _chatBar = [[WeiMiRQChatBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT - 5, SCREEN_WIDTH, TAB_BAR_HEIGHT + 5)];
        _chatBar.delegate = self;
        WS(weakSelf);
        __weak typeof(self.chatBar.inputTextView) weakTextView = self.chatBar.inputTextView;

        _chatBar.onSendBtnHandler = ^{
            SS(strongSelf);
            [strongSelf textView:weakTextView shouldChangeTextInRange:weakTextView.selectedRange replacementText:@"\n"];
        };
    }
    return _chatBar;
}

- (WeiMiAddRQRequest *)postCommentRequest
{
    if (!_postCommentRequest) {
        
        _postCommentRequest = [[WeiMiAddRQRequest alloc] init];
    }
    return _postCommentRequest;
}

#pragma mark - Actions
-(void)didSelectBtnWithBtnTag:(NSInteger)tag
{
    SSDKPlatformType formType;
    
    if (tag==1)//微信好友
    {
        formType = SSDKPlatformSubTypeWechatSession;
    }else if (tag==2)//微信朋友圈
    {
        formType = SSDKPlatformSubTypeWechatTimeline;
    }
    [SimpleShare shareWithPlatformType:formType shareParams:[NSMutableDictionary shareParamsWithContent:@"content" title:@"title" link:@"www.baidu.com" images:nil] response:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        
        switch (state) {//判断分享是否成功
            case SSDKResponseStateSuccess:{
                [OHAlertView showAlertWithTitle:@"分享成功" message:nil dismissButton:@"确定"];
                break;
            }
            case SSDKResponseStateFail:{
                [OHAlertView showAlertWithTitle:@"分享失败" message:nil dismissButton:@"确定"];
                break;
            }
            case SSDKResponseStateCancel:{
                [OHAlertView showAlertWithTitle:@"您取消了分享" message:nil dismissButton:@"确定"];
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - UITextViewDelegate
-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font  width:(float)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width,   80000) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"] && ![NSString isNullOrEmpty:textView.text]) {
        
        if (!textView.text) {
            [textView resignFirstResponder];
            return NO; //使得return键失效
        }
        
        [self postCommentWithDisContent:textView.text];

        textView.text = nil;
        [textView resignFirstResponder];
        return NO; //使得return键失效
    }
    return YES;
}

//- (void)textViewDidEndEditing:(UITextView *)textView
//{
//    self.postComment.memberName = nil;
//}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        CGRect r = [textView caretRectForPosition:textView.selectedTextRange.end];
        CGFloat caretY =  MAX(r.origin.y - textView.frame.size.height + r.size.height + 8, 0);
        if (textView.contentOffset.y < caretY && r.origin.y != INFINITY) {
            textView.contentOffset = CGPointMake(0, caretY);
        }
    }
}



-(void)textViewDidChange:(UITextView *)textView{
    //获取文本中字体的size
    CGSize size = [self sizeWithString:textView.text font:textView.font width:textView.width];
    NSLog(@"height = %f",size.height);
    //获取一行的高度
    CGSize size1 = [self sizeWithString:@"Hello" font:textView.font width:textView.width];
    NSInteger i = size.height/size1.height;
    if (i == 1) {
        WS(weakSelf);
        [UIView animateWithDuration:0.3 animations:^{
            SS(strongSelf);
            strongSelf.chatBar.frame = CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT - 5, SCREEN_WIDTH, TAB_BAR_HEIGHT + 5);
            _tableView.frame = self.contentFrame;
        }];
        //        self.chatBar.height = TAB_BAR_HEIGHT;
    }
    
    if (i > 1 && i < 4) {
        WS(weakSelf);
        [UIView animateWithDuration:0.3 animations:^{
            SS(strongSelf);
            strongSelf.chatBar.height = size.height + 35;
            strongSelf.chatBar.frame = CGRectMake(0, SCREEN_HEIGHT - self.chatBar.height, SCREEN_WIDTH, self.chatBar.height);
            _tableView.height = SCREEN_HEIGHT - strongSelf.chatBar.height - STATUS_BAR_HEIGHT -NAV_HEIGHT;
        }];
        
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || _dataSource.count == 0) {
        return 1;
    }

    return _dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (_dto.niming) {//匿名用户
            static NSString *cellID = @"cell_isAnonymity";
            
            WeiMiRQDetailAnonymousCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[WeiMiRQDetailAnonymousCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
                //        cell.detailTextLabel.textColor = kGrayColor;
                [cell setViewWithDTO:_dto];
            }
            return cell;
        }else//非匿名用户
        {
            static NSString *cellID = @"cell_other";
            
            WeiMiRQDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[WeiMiRQDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
                cell.textLabel.font = [UIFont systemFontOfSize:15];
            }
            
            [cell setViewWithDTO:_dto];
            return cell;
        }
        
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
    
    WeiMiRQCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiRQCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    [self confirgueCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_dto.niming && indexPath.section == 0) {
        return [WeiMiRQDetailAnonymousCell getHeightWithDTO:_dto];
    }
    if (!_dto.niming && indexPath.section == 0) {
        return [WeiMiRQDetailCell getHeightWithDTO:_dto];
    }
    
    if (_dataSource.count == 0) {
        return 50;
    }
    if (self.dataSource.count > 0) {
        WeiMiRQCommentLayout* layout = self.dataSource[indexPath.row];
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
    
//    if (indexPath.section > 0 ) {
//        ///测试假数据
//        if (indexPath.row == 0) {
//            [[WeiMiPageSkipManager communityRT] open:@"WeiMiCommentDetail/no/yes"];
//        }
//        else
//        {
//            [[WeiMiPageSkipManager communityRT] open:@"WeiMiCommentDetail/yes/no"];
//        }
//    }

    
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

#pragma mark - cell 配置
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

/// cell 配置
- (void)confirgueCell:(WeiMiRQCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    WeiMiRQCommentLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    //事件回调
    [self callbackWithCell:cell];
}

/// cell回调事件
- (void)callbackWithCell:(WeiMiRQCommentCell *)cell {
    
    
}

#pragma mark - CellActions
///查看头像
//- (void)showAvatarWithCell:(WeiMiInviteCommentCell *)cell {
//    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.model.memberName]];
//}

//开始评论
- (void)commentWithCell:(WeiMiRQCommentCell *)cell  {
//    self.postCommentRequest.memberId = [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
//    self.postCommentRequest.qtId = _dto.qtId;
//    self.postCommentRequest.index = cell.indexPath.row;
//    
//    WeiMiRQCommentLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
//    if (layout) {
//        self.postComment.disId = layout.statusModel.disId;
//    }
////    self.chatBar.inputTextView.placeholder = @"评论帖子";
//    if (![self.chatBar.inputTextView isFirstResponder]) {
//        
//        [self.chatBar.inputTextView becomeFirstResponder];
//    }
}

//开始回复评论
//- (void)reCommentWithCell:(WeiMiRQCommentCell *)cell commentModel:(WeiMiCommentListReplayModel *)commentModel {
//    self.postComment.memberName = [WeiMiUserCenter sharedInstance].userInfoDTO.userName;
//    self.postComment.tomemberId = commentModel.tomemberId;
//    self.postComment.index = commentModel.index;
//    self.postComment.disId = commentModel.disId;
////    self.chatBar.inputTextView.placeholder = [NSString stringWithFormat:@"回复%@:",commentModel.memberName];
//    
//    if (![self.chatBar.inputTextView isFirstResponder]) {
//        [self.chatBar.inputTextView becomeFirstResponder];
//    }
//}

//查看头像
//- (void)showAvatarWithCell:(TableViewCell *)cell {
//    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.name]];
//}



- (WeiMiRQCommentLayout *)layoutWithStatusModel:(WeiMiRQCommentModel *)dto index:(NSInteger)index {
    WeiMiRQCommentLayout* layout = [[WeiMiRQCommentLayout alloc] initWithStatusModel:dto
                                                                                       index:index
                                                                               dateFormatter:self.dateFormatter];
    return layout;
}

//发表评论
- (void)postCommentWithCommentModel:(WeiMiRQCommentModel *)model {
    /* 由于是异步绘制，而且为了减少View的层级，整个显示内容都是在同一个UIView上面，所以会在刷新的时候闪一下，这里可以先把原先Cell的内容截图覆盖在Cell上，
     延迟0.25s后待刷新完成后，再将这个截图从Cell上移除 */
    
//    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:model.index inSection:0]];
//    UIImage* screenshot = [GallopUtils screenshotFromView:cell];
//    UIImageView* imgView = [[UIImageView alloc] initWithFrame:[self.tableView convertRect:cell.frame toView:self.tableView]];
//    imgView.image = screenshot;
//    [self.tableView addSubview:imgView];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [imgView removeFromSuperview];
//    });
//    
//    WeiMiRQCommentLayout* layout = [self.dataSource objectAtIndex:model.index];
//    NSMutableArray* newCommentLists = [[NSMutableArray alloc] initWithArray:layout.statusModel.commentArr];
//    [newCommentLists addObject:model];
//    WeiMiCommentListDTO* statusModel = layout.statusModel;
//    statusModel.commentArr = newCommentLists;
//    layout = [self layoutWithStatusModel:statusModel index:model.index];
//    [self.dataSource replaceObjectAtIndex:model.index withObject:layout];
//    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:1]]
//                          withRowAnimation:UITableViewRowAnimationAutomatic];
//    //如果是最后一个cell 需要滚动至最底层
//    if (model.index == _dataSource.count - 1) {
//        [self.tableView scrollToBottom];
//        
//    }
}


#pragma mark - NetWork
//---- 评论列表
- (void)getCommentWithQId:(NSString *)qId pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiRQReplyListRequest *request = [[WeiMiRQReplyListRequest alloc] initWithQId:qId pageIndex:index pageSize:pageSize];
    WeiMiRQReplyListResponse *response = [[WeiMiRQReplyListResponse alloc] init];;

    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            for (NSInteger i = 0; i < response.dataArr.count; i ++) {
                WeiMiRQCommentModel *commentDTO = safeObjectAtIndex(response.dataArr, i);
                LWLayout* layout = [self layoutWithStatusModel:
                                    commentDTO
                                                         index:i];
                [self.dataSource addObject:layout];
            }
            
            [strongSelf.tableView reloadData];
            _currentPage ++;
            [_tableView.mj_footer endRefreshing];
        }else
        {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
    }];
}

///// 评论点赞
//- (void)zanCommentWithDisId:(NSString *)disId zanBtn:(UIButton *)btn
//{
//    WeiMiPostLikeRequest *request = [[WeiMiPostLikeRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel disId:disId];
//    request.showHUD = YES;
//    WS(weakSelf);
//    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        SS(strongSelf);
//        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
//        if ([result isEqualToString:@"1"]) {
//            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
//            [strongSelf presentSheet:@"点赞成功"];
//            btn.selected = !btn.selected;
//            NSInteger zanNum = btn.titleLabel.text.integerValue;
//            [btn setTitle:[NSString stringWithFormat:@"%ld", (long)(++zanNum)] forState:UIControlStateNormal];
//        }else if ([result isEqualToString:@"2"]) {
//            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
//            [strongSelf presentSheet:@"已经点过赞了"];
//        }
//        else
//        {
//            [strongSelf presentSheet:@"点赞失败"];
//        }
//        
//        
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        
//        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
//        
//    }];
//}
//
/// 发送帖子评论
- (void)postCommentWithDisContent:(NSString *)disContent
{
    self.postCommentRequest.memberId = [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
    self.postCommentRequest.qtId = _dto.qtId;
    self.postCommentRequest.content = disContent;
    self.postCommentRequest.showHUD = YES;
    WS(weakSelf);
    [_postCommentRequest startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            [strongSelf presentSheet:@"评论成功"];
        }
        else
        {
            [strongSelf presentSheet:@"评论失败"];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}

////回复帖子评论
//- (void)replyCommentWithCommentModel:(WeiMiCommentListReplayModel *)model;
//{
//    WeiMiReplyPostCommentRequest *request = [[WeiMiReplyPostCommentRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel tomemberId:model.tomemberId disContent:model.detContent disId:model.disId];
//    request.showHUD = YES;
//    WS(weakSelf);
//    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        SS(strongSelf);
//        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
//        if ([result isEqualToString:@"1"]) {
//            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
//            [strongSelf presentSheet:@"评论成功"];
//            
//            [strongSelf postCommentWithCommentModel:model];
//        }
//        else
//        {
//            [strongSelf presentSheet:@"评论失败"];
//        }
//        _postComment.memberName = nil;
//        
//        
//    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
//        
//        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
//        
//    }];
//}

@end
