//
//  WeiMiInvitationVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiInvitationVC.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"
#import "WeiMiInvitationDetailHeaderView.h"
#import "UIButton+CenterImageAndTitle.h"
#import "WeiMiInvitationChatBar.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiRelativeInvitaionCell.h"
#import "WeiMiSegmentView.h"
#import "WeiMiOtherUsersVC.h"
#import "WeiMiCircleDetailVC.h"
#import "WeiMiInvitationVC.h"
#import "WeiMiRQDetailVC.h"
#import "WeiMiSystemInfo.h"

//----- 富文本cell
#import "LWImageBrowser.h"
#import "WeiMiInviteCommentCell.h"
#import "WeiMiInviteCommentLayout.h"
#import "WeiMiInviteCommentStatusModel.h"
//#import "CommentModel.h"
#import "LWAlertView.h"
//----- 刷新组件
#import "WeiMiRefreshComponents.h"
//----- request
//通过ID查询帖子信息
#import "WeiMiCircleFindInfoRequest.h"
#import "WeiMiCircleFindInfoResponse.h"
//帖子点赞
#import "WeiMiInvitationZanRequest.h"
//帖子收藏
#import "WeiMiCollectionAddRequest.h"
//帖子评论列表
#import "WeiMiCommentListRequest.h"
#import "WeiMiCommentListResponse.h"
//帖子评论点赞
#import "WeiMiPostLikeRequest.h"
//发送帖子评论
#import "WeiMiAddPostCommentRequest.h"
//回复帖子评论
#import "WeiMiReplyPostCommentRequest.h"


@interface WeiMiInvitationVC ()<UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,
WeiMiSegmentViewDelegate, UIWebViewDelegate>
{
    /**数据源*/
    __block NSInteger _currentPage;

    CGFloat _webViewHeight;
}

@property (nonatomic, strong) WeiMiInvitationDetailHeaderView *userCell;

@property (nonatomic, strong) UILabel *headerLB;
@property (nonatomic, strong) UITextView *contentTextView;

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) WeiMiInvitationChatBar *chatBar;

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) WeiMiBaseView *tableHeaderView;//table的HeaderView
@property (nonatomic, strong) WeiMiSegmentView *segView;//选项卡
@property (nonatomic, strong) UILabel *tagLB;//楼主Label

//--------------
//@property (nonatomic,strong) NSMutableArray* fakeDatasource;
@property (nonatomic,strong) NSMutableArray* dataSource;
@property (nonatomic,strong) WeiMiCommentListReplayModel* postComment;

@end

@implementation WeiMiInvitationVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = 1;
        _dataSource = [NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOS7_OR_LATER) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.contentView addSubview:self.chatBar];
    [self.view setNeedsUpdateConstraints];
    
//    [self fakeDownload];
    
    if (!_dto && _infoId) {//只有infoId
        
        [self getPostDetailWithInfoId:_infoId];
    }else{
        //上拉刷新
        _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
            
            [self getCommentWithInfoId:self.dto.infoId pageIndex:_currentPage pageSize:10];
        }];
        
        [self getCommentWithInfoId:self.dto.infoId pageIndex:_currentPage pageSize:10];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"帖子详情";
//    self.popWithBaseNavColor = YES;
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
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (WeiMiBaseView *)tableHeaderView
{
    if (!_tableHeaderView) {
        _tableHeaderView = [[WeiMiBaseView alloc] init];
        _tableHeaderView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
//        [_tableHeaderView addSubview:self.segView];
        [_tableHeaderView addSubview:self.tagLB];
        [_tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(_tableHeaderView);
            make.right.mas_equalTo(-10);
            make.width.mas_equalTo(_tagLB.mas_height).multipliedBy(2);
        }];
    }
    return _tableHeaderView;
}
- (WeiMiInvitationDetailHeaderView *)userCell
{
    if (!_userCell) {
        _userCell = [[WeiMiInvitationDetailHeaderView alloc] init];
        _userCell.userInteractionEnabled = NO;
        _userCell.titleLabel.text = _dto.memberName;
        [_userCell.cellImageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(_dto.headImgPath)] placeholderImage:[UIImage imageNamed:@"logo"]];
    }
    return _userCell;
}

- (UIWebView *)webView
{
    if (!_webView) {
        
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(20, 300, self.view.frame.size.width - 40, 400)];
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
//        [_webView loadHTMLString:str1 baseURL:nil];
    }
    return _webView;
}

- (UILabel *)headerLB
{
    if (!_headerLB) {
        
        _headerLB = [[UILabel alloc] init];
        _headerLB.font = WeiMiSystemFontWithpx(28);
        _headerLB.textAlignment = NSTextAlignmentLeft;
        _headerLB.numberOfLines = 0;
        _headerLB.text = @"我有那啥，不服来战！";
    }
    return _headerLB;
}

- (UITextView *)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.font = WeiMiSystemFontWithpx(21);
        _contentTextView.scrollEnabled = NO;
        _contentTextView.showsVerticalScrollIndicator = NO;
        _contentTextView.showsHorizontalScrollIndicator = NO;
        _contentTextView.editable = NO;
        _contentTextView.text = @"在开发中常常想要找到好看的字体,但是系统的字体太多,不可能一个个去试,所以就想到做个demo方便在今后的开发当中选择自己喜欢的字体。请前往GitHub免费下载";
    }
    return _contentTextView;
}
- (WeiMiInvitationChatBar *)chatBar
{
    if (!_chatBar) {
        
        _chatBar = [[WeiMiInvitationChatBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TAB_BAR_HEIGHT - 5, SCREEN_WIDTH, TAB_BAR_HEIGHT + 5)];
        _chatBar.delegate = self;
        WS(weakSelf);
        _chatBar.onZanBtnHandler = ^{//点赞
            SS(strongSelf);
            if (strongSelf.dto) {
                [strongSelf zanWithInfoId:strongSelf.dto.infoId];
            }
        };
        _chatBar.onLoveHandler = ^(UIButton *btn){//收藏
            SS(strongSelf);
            
            if (strongSelf.dto) {
                [strongSelf addCollection:strongSelf.dto.infoId button:btn];
            }
        };
    }
    return _chatBar;
}

- (WeiMiSegmentView *)segView
{
    if (!_segView) {
        WeiMiSegmentViewConfig *config = [[WeiMiSegmentViewConfig alloc] init];
        config.titleArray = @[@"默认", @"最赞", @"最新",];
        config.bgColor = kWhiteColor;
        config.scrollViewColor = kClearColor;
        config.selectTitleColor = kBlackColor;
        config.titleColor = kGrayColor;
        config.titleFont = WeiMiSystemFontWithpx(20);
        _segView = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH/3, 50) config:config delegate:self];
    }
    return _segView;
}

- (UILabel *)tagLB
{
    if (!_tagLB) {
        
        _tagLB = [[UILabel alloc] init];
//        _tagLB.frame = CGRectMake(SCREEN_WIDTH - 13 -20, _segView.centerY, 25, 13);
        _tagLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
        _tagLB.textAlignment = NSTextAlignmentCenter;
//        _tagLB.textColor = kWhiteColor;
//        _tagLB.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
//        _tagLB.text = @"楼主";
    }
    return _tagLB;
}

#pragma mark - Getter
- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }

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

- (WeiMiCommentListReplayModel *)postComment {
    if (_postComment) {
        return _postComment;
    }
    _postComment = [[WeiMiCommentListReplayModel alloc] init];
    return _postComment;
}


#pragma mark - NetWork
//----点赞
- (void)zanWithInfoId:(NSString *)infoId
{
    WeiMiInvitationZanRequest *request = [[WeiMiInvitationZanRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel infoId:infoId];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            [strongSelf presentSheet:@"点赞成功"];
        }else if ([result isEqualToString:@"2"]) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            [strongSelf presentSheet:@"已经点过赞了"];
        }
        else
        {
            [strongSelf presentSheet:@"点赞失败"];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}

//--- 添加收藏
- (void)addCollection:(NSString *)inviteId button:(UIButton *)btn
{
    
    WeiMiCollectionAddRequest *request = [[WeiMiCollectionAddRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel entityId:inviteId isAble:@"2"];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request)
     {
         SS(strongSelf);
         NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
         if ([result isEqualToString:@"1"]) {
             [strongSelf presentSheet:@"收藏成功"];
             btn.selected = YES;
         }else if([result isEqualToString:@"2"])
         {
             [strongSelf presentSheet:@"已收藏过了"];
             btn.selected = YES;
         }else if ([result isEqualToString:@"0"])
         {
             [strongSelf presentSheet:@"收藏失败"];
             btn.selected = NO;
         }
         
     } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         
         //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
     }];
}

//---- 评论列表
- (void)getCommentWithInfoId:(NSString *)infoId pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiCommentListRequest *request = [[WeiMiCommentListRequest alloc] initWithInfoId:infoId pageIndex:index pageSize:pageSize];
    WeiMiCommentListResponse *response = [[WeiMiCommentListResponse alloc] init];
//    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            for (NSInteger i = 0; i < response.dataArr.count; i ++) {
                WeiMiCommentListDTO *commentDTO = safeObjectAtIndex(response.dataArr, i);
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

/// 若只有一个infoId 没有Dto需要请求
- (void)getPostDetailWithInfoId:(NSString *)infoId;
{
    WeiMiCircleFindInfoRequest *request = [[WeiMiCircleFindInfoRequest alloc] initWithMemberId:infoId];
    if(_isFromMRtiyan){
        request.isFromMRtiyan = YES;
    }
    WeiMiCircleFindInfoResponse *response = [[WeiMiCircleFindInfoResponse alloc] init];

    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = (NSDictionary *)request.responseJSONObject;
        NSLog(@"---z %@",request.responseJSONObject);
        if (result) {
            [response parseResponse:result];
            strongSelf.dto = response.dto;
            [strongSelf.tableView reloadData];
            
            //上拉刷新
            strongSelf.tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
                
                [self getCommentWithInfoId:self.dto.infoId pageIndex:_currentPage pageSize:10];
            }];
            
            [strongSelf getCommentWithInfoId:self.dto.infoId pageIndex:_currentPage pageSize:10];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}



/// 评论点赞
- (void)zanCommentWithDisId:(NSString *)disId zanBtn:(UIButton *)btn
{
    WeiMiPostLikeRequest *request = [[WeiMiPostLikeRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel disId:disId];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            [strongSelf presentSheet:@"点赞成功"];
            btn.selected = !btn.selected;
            NSInteger zanNum = btn.titleLabel.text.integerValue;
            [btn setTitle:[NSString stringWithFormat:@"%ld", (long)(++zanNum)] forState:UIControlStateNormal];
        }else if ([result isEqualToString:@"2"]) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            [strongSelf presentSheet:@"已经点过赞了"];
        }
        else
        {
            [strongSelf presentSheet:@"点赞失败"];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}

/// 发送帖子评论
- (void)postCommentWithInfoId:(NSString *)infoId disContent:(NSString *)disContent
{
    WeiMiAddPostCommentRequest *request = [[WeiMiAddPostCommentRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel infoId:infoId disContent:disContent];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
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
    
//回复帖子评论
    - (void)replyCommentWithCommentModel:(WeiMiCommentListReplayModel *)model;
{
    WeiMiReplyPostCommentRequest *request = [[WeiMiReplyPostCommentRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel tomemberId:model.tomemberId disContent:model.detContent disId:model.disId];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            [strongSelf presentSheet:@"评论成功"];
            
            [strongSelf postCommentWithCommentModel:model];
        }
        else
        {
            [strongSelf presentSheet:@"评论失败"];
        }
        _postComment.memberName = nil;

        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
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

#pragma mark - UIWebViewDelegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (_webViewHeight > 0) {
        return;
    }
    _webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];

    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - UITextViewDelegate
-(CGSize)sizeWithString:(NSString*)string font:(UIFont*)font  width:(float)width {
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width,   80000) options:NSStringDrawingTruncatesLastVisibleLine |   NSStringDrawingUsesFontLeading    |NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return rect.size;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]) {
        
        if (!textView.text) {
            [textView resignFirstResponder];
            return NO; //使得return键失效
        }
        
        if ([NSString isNullOrEmpty:self.postComment.memberName]) {//如果评论人没有则是发帖
            
            [self postCommentWithInfoId:self.dto.infoId disContent:textView.text];
        }else{//有评论人则是回复评论
            self.postComment.detContent = textView.text;
            [self replyCommentWithCommentModel:[self.postComment copy]];
        }

        textView.text = nil;
        [textView resignFirstResponder];
        return NO; //使得return键失效
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    textView.placeholder = @"你想说些什么？";
    self.postComment.memberName = nil;
}

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
    if (section == 0) {
        return 3;
    }

    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        static NSString *cellID = @"cell_0_0";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:TEST_IMAGE_URL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                
//                if (image) {
//                    UIImage *img = [image resizedImage:CGSizeMake(50, 50) interpolationQuality:kCGInterpolationDefault];
//                    cell.imageView.image = img;
//                }
//            }];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//            cell.textLabel.font = WeiMiSystemFontWithpx(21);
//            cell.textLabel.text = @"此处风景独好";
//        }
//        return cell;
//    }
//    else
        if (indexPath.section == 0 && indexPath.row == 0)//发帖人
    {
        static NSString *cellID = @"cell_0_1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
            [cell.contentView addSubview:self.userCell];
            _userCell.userInteractionEnabled = NO;
            [_userCell mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.mas_equalTo(cell);
            }];
            
        }
        return cell;
    }    else if (indexPath.section == 0 && indexPath.row == 1)//发帖标题
    {
        static NSString *cellID = @"cell_0_2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
            [cell.contentView addSubview:self.headerLB];
            [_headerLB mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.mas_equalTo(cell).insets(UIEdgeInsetsMake(10, 10, 10, 10));
            }];
        }
        
        _headerLB.text = self.dto.infoTitle;
        return cell;
        
    }else if (indexPath.section == 0 && indexPath.row == 2)//发帖内容
    {
        static NSString *cellID = @"cell_0_3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];

//            [cell.contentView addSubview:self.contentTextView];
//            [_contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
//                
//                make.edges.mas_equalTo(cell).insets(UIEdgeInsetsMake(10, 10, 0, 0));
//            }];
            
            [cell.contentView addSubview:self.webView];
            [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.edges.mas_equalTo(cell).insets(UIEdgeInsetsMake(10, 0, 10, 0));
            }];
            
            if (![NSString isNullOrEmpty:self.dto.imgPath]) {
                NSString *contentNew = [NSString stringWithFormat:
                                        @"<html><head>\
                                        <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\"/>\
                                        </head>\
                                        <body>\
                                        %@<div>\
                                        <img src=\"%@\" id=\"image\" style=\"max-width: 100%%\"></div>\
                                        </body><script language=\"javascript\" type=\"text/javascript\"></script></html>"
                                        , self.dto.content ? self.dto.content : @"", WEIMI_IMAGEREMOTEURL(self.dto.imgPath)];
                [_webView loadHTMLString:contentNew baseURL:nil];
            }else
            {
                NSString *contentNew = [NSString stringWithFormat:
                                        @"<html><head>\
                                        <meta name=\"viewport\" content=\"width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no\"/>\
                                        </head>\
                                        <body>\
                                        %@\
                                        </body><script language=\"javascript\" type=\"text/javascript\"></script></html>"
                                        , self.dto.content ? self.dto.content : @""];
                [_webView loadHTMLString:contentNew baseURL:nil];
            }
            
        }

        return cell;
    }else if (indexPath.section == 0 && indexPath.row == 3)//帖子推荐
    {
        static NSString *cellID = @"cell_0_4";
        WeiMiRelativeInvitaionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiRelativeInvitaionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.onBtnHandler = ^(BOOL isLeft)
            {
//                UPRouterOptions *options = [UPRouterOptions routerOptions];
//                options.hidesBottomBarWhenPushed = YES;
//                [[WeiMiPageSkipManager communityRouter] intoVC:@"WeiMiInvitationVC" options:options];
                WeiMiInvitationVC *vc = [[WeiMiInvitationVC alloc] init];
                vc.popWithBaseNavColor = NO;
                [self.navigationController pushViewController:vc animated:YES];
            };
        }
        
//        UPRouterOptions *options = [UPRouterOptions routerOptions];
//        options.hidesBottomBarWhenPushed = YES;
//        [[WeiMiPageSkipManager communityRouter] intoVC:@"WeiMiInvitationVC" options:options];
        return cell;
    }
    

//    if (!_dataSource.count) {//若数据源为空，返回默认cell
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tempCell"];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tempCell"];
//            cell.textLabel.font = WeiMiSystemFontWithpx(22);
//            cell.textLabel.textColor = kGrayColor;
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.textLabel.text = @"暂时没有回复哦";
//            cell.userInteractionEnabled = NO;
//            return cell;
//        }
//    }
    
    static NSString* cellIdentifier = @"cellIdentifier";
    WeiMiInviteCommentCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[WeiMiInviteCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [self confirgueCell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        return 145/2;
//    }else
    if (indexPath.section == 0 && indexPath.row == 1) {
        return [_dto.infoTitle returnSize:self.headerLB.font MaxWidth:SCREEN_WIDTH - 20].height + 30;
    }else if (indexPath.section == 0 && indexPath.row == 2) {
        if (_webViewHeight > 0) {
            return _webViewHeight + 30;
        }else
        {
            return 40;
        }
//        return [self.dto.content  returnSize:self.contentTextView.font MaxWidth:SCREEN_WIDTH - 20].height + 40;
    }else if (indexPath.section == 0 && indexPath.row == 3)
    {
        return 125;
    }else if (indexPath.section == 1)
    {
        if (!self.dataSource.count) {
            return 55;
        }
        if (self.dataSource.count >= indexPath.row) {
            WeiMiInviteCommentLayout* layout = self.dataSource[indexPath.row];
            return layout.cellHeight;
        }
    }
    return 55;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return self.tableHeaderView;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 45;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {//跳转至圈子详情
        
//        WeiMiCircleDetailVC *vc = [[WeiMiCircleDetailVC alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 0 && indexPath.row == 1)//跳转至用户详情
    {
        WeiMiOtherUsersVC *vc = [[WeiMiOtherUsersVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
//        [[WeiMiPageSkipManager communityRT] open:@"WeiMiOtherUsersVC"];
    }
//    else if(indexPath.section == 1)
//    {
//        WeiMiRQDetailVC *vc = [[WeiMiRQDetailVC alloc] init];
//        vc.params = @{@"hasAnswer":@"yes",@"isAn":@"no"};
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        if (indexPath.section == 0 && indexPath.row != 0) {
            [cell setSeparatorInset:UIEdgeInsetsMake(0, SCREEN_WIDTH, 0, 0)];
            return;
        }
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {

        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - layout
- (void)viewDidLayoutSubviews
{
    
//    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH, _leftBTN.bottom > SCREEN_HEIGHT ? _leftBTN.bottom +10 : SCREEN_HEIGHT + 10);
    
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
}

/// cell 配置
- (void)confirgueCell:(WeiMiInviteCommentCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    WeiMiInviteCommentLayout* cellLayout = self.dataSource[indexPath.row];
    cell.cellLayout = cellLayout;
    //事件回调
    [self callbackWithCell:cell];
}

/// cell回调事件
- (void)callbackWithCell:(WeiMiInviteCommentCell *)cell {
    
    //点赞
    WS(weakSelf);
    cell.clickedZanButtonCallback = ^(WeiMiInviteCommentCell* cell, UIButton *btn) {
        SS(strongSelf);
        [strongSelf zanCommentWithDisId:cell.cellLayout.statusModel.model.disId zanBtn:btn];
    };
    
    //评论帖子
    cell.clickedCommentButtonCallback = ^(WeiMiInviteCommentCell* cell) {
        __strong typeof(weakSelf) sself = weakSelf;
        [sself commentWithCell:cell];
    };
    
    //点击了回复评论
    cell.clickedReCommentCallback = ^(WeiMiInviteCommentCell* cell,WeiMiCommentListReplayModel* model) {
        SS(strongSelf);
        [strongSelf reCommentWithCell:cell commentModel:model];
    };
    
    //头像点击
    cell.clickedAvatarCallback = ^(WeiMiInviteCommentCell* cell) {
        SS(strongSelf);
        [strongSelf showAvatarWithCell:cell];
    };

}

#pragma mark - CellActions
///查看头像
- (void)showAvatarWithCell:(WeiMiInviteCommentCell *)cell {
    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.model.memberName]];
}

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

    WeiMiInviteCommentStatusModel* statusModel = layout.statusModel.model;
    statusModel.isLike = isLike;
    layout = [self layoutWithStatusModel:statusModel index:cell.indexPath.row];
    [self.dataSource replaceObjectAtIndex:cell.indexPath.row withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:cell.indexPath.row inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

//开始评论
- (void)commentWithCell:(WeiMiInviteCommentCell *)cell  {
    self.postComment.memberName = [WeiMiUserCenter sharedInstance].userInfoDTO.userName;
    self.postComment.tomemberId = @"";
    self.postComment.index = cell.indexPath.row;
    
    WeiMiInviteCommentLayout* layout = [self.dataSource objectAtIndex:cell.indexPath.row];
    if (layout) {
        self.postComment.disId = layout.statusModel.model.disId;
    }
    self.chatBar.inputTextView.placeholder = @"评论帖子";
    if (![self.chatBar.inputTextView isFirstResponder]) {
        
        [self.chatBar.inputTextView becomeFirstResponder];
    }
}

//开始回复评论
- (void)reCommentWithCell:(WeiMiInviteCommentCell *)cell commentModel:(WeiMiCommentListReplayModel *)commentModel {
    self.postComment.memberName = [WeiMiUserCenter sharedInstance].userInfoDTO.userName;
    self.postComment.tomemberId = commentModel.tomemberId;
    self.postComment.index = commentModel.index;
    self.postComment.disId = commentModel.disId;
    self.chatBar.inputTextView.placeholder = [NSString stringWithFormat:@"回复%@:",commentModel.memberName];
    
    if (![self.chatBar.inputTextView isFirstResponder]) {
        [self.chatBar.inputTextView becomeFirstResponder];
    }
}

//查看头像
//- (void)showAvatarWithCell:(TableViewCell *)cell {
//    [LWAlertView shoWithMessage:[NSString stringWithFormat:@"点击了头像:%@",cell.cellLayout.statusModel.name]];
//}



- (WeiMiInviteCommentLayout *)layoutWithStatusModel:(WeiMiCommentListDTO *)dto index:(NSInteger)index {
    WeiMiInviteCommentLayout* layout = [[WeiMiInviteCommentLayout alloc] initWithStatusModel:dto
                                                           index:index
                                                   dateFormatter:self.dateFormatter];
    return layout;
}

//发表评论
- (void)postCommentWithCommentModel:(WeiMiCommentListReplayModel *)model {
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
    [newCommentLists addObject:model];
    WeiMiCommentListDTO* statusModel = layout.statusModel;
    statusModel.commentArr = newCommentLists;
    layout = [self layoutWithStatusModel:statusModel index:model.index];
    [self.dataSource replaceObjectAtIndex:model.index withObject:layout];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:model.index inSection:1]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    //如果是最后一个cell 需要滚动至最底层
    if (model.index == _dataSource.count - 1) {
        [self.tableView scrollToBottom];

    }
}


@end
