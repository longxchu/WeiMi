//
//  WeiMiMyPostsVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyPostsVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiNotifiEmptyView.h"
#import "WeiMiRefreshComponents.h"
//帖子详情
#import "WeiMiInvitationVC.h"
// ---------- category
#import "UIButton+CenterImageAndTitle.h"
// ---------- DTO
#import "WeiMiCardsDTO.h"
// ---------- request
#import "WeiMiMyInvitationRequest.h"
#import "WeiMiMyInvitationResponse.h"

typedef NS_ENUM(NSInteger, TABLEVIEWTYPE)
{
    TABLEVIEWTYPE_GOODS,
    TABLEVIEWTYPE_CARDS,
};
@interface WeiMiMyPostsVC()<UITableViewDelegate, UITableViewDataSource>
{
//    /**数据源*/
//    NSMutableArray *_cardsData;
    __block NSInteger _currentPage;

}


@property (nonatomic, strong) WeiMiBaseTableView *tableView;
//提示为空
@property (nonatomic, strong) UIButton *goAnyWhereBtn;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;

/**数据源*/
@property (nonatomic, strong) NSMutableArray *cardsData;
@end

@implementation WeiMiMyPostsVC

- (instancetype)init
{
    self = [super init];
    if (self) {

        _cardsData = [NSMutableArray new];
        _currentPage = 1;

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    [self.tableView addSubview:self.notiView];
    [self.tableView addSubview:self.goAnyWhereBtn];
//    _notiView.hidden = YES;
//    _goAnyWhereBtn.hidden = YES;
    
    [self.view setNeedsUpdateConstraints];
    
    [self addObserver:self forKeyPath:@"cardsData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
//    WeiMiCardsDTO *dtoCards = [[WeiMiCardsDTO alloc] init];
//    [[self mutableArrayValueForKey:@"cardsData"] addObjectsFromArray:@[dtoCards, dtoCards, dtoCards, dtoCards]];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getNewestActWithpageIndex:_currentPage pageSize:10];
    }];
    
    //下拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        
        _currentPage = 1;
        [_cardsData removeAllObjects];
        [self getNewestActWithpageIndex:_currentPage pageSize:10];
    }];
    
    [self getNewestActWithpageIndex:_currentPage pageSize:10];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"cardsData"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"我的帖子";
    
    WS(weakSelf);
    [self AddLeftBtn:nil normal:@"icon_back" selected:@"icon_back" action:^{
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
}

#pragma mark - Getter
- (WeiMiBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (UIButton *)goAnyWhereBtn
{
    if (!_goAnyWhereBtn) {
        
        _goAnyWhereBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _goAnyWhereBtn.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        _goAnyWhereBtn.layer.masksToBounds = YES;
        _goAnyWhereBtn.layer.cornerRadius = 3.0f;
        _goAnyWhereBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_goAnyWhereBtn setTitle:@"去逛逛" forState:UIControlStateNormal];
        [_goAnyWhereBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_goAnyWhereBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goAnyWhereBtn;
}

- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"icon_heart" title:@"您还没有发过贴"];
    }
    return _notiView;
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
        if ([keyPath isEqualToString:@"cardsData"]) {
            if (_cardsData.count == 0) {
                _notiView.hidden = NO;
                _goAnyWhereBtn.hidden = NO;
            }else
            {
                _notiView.hidden = YES;
                _goAnyWhereBtn.hidden = YES;
            }
            return;
        }
    }
}

#pragma mark - Network
//---- 我的帖子列表
- (void)getNewestActWithpageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiMyInvitationRequest *request = [[WeiMiMyInvitationRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel pageIndex:index pageSize:pageSize];
    WeiMiMyInvitationResponse *response = [[WeiMiMyInvitationResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [[self mutableArrayValueForKey:@"cardsData"] addObjectsFromArray:response.dataArr];
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


#pragma mark - Common
/* set cell selected actions*/
#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cardsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        // 帖子详情cell
    static NSString *cellID = @"cardsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *view = [UIView new];
        view.backgroundColor = kClearColor;
        cell.selectedBackgroundView = view;
        //        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        /// 添加标题label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 7777 + indexPath.row;
        titleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.right.mas_offset(-10);
        }];
        
        
        
        //添加评论数量btn
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 9999 + indexPath.row;
        button.backgroundColor = kWhiteColor;
        [button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        button.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        [button setTitle:@"更多体验社" forState:UIControlStateNormal];
        [button setTitleColor:kGrayColor forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"icon_comment"] forState:UIControlStateNormal];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -2.5, 0, 2.5)];
        //        [button addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.mas_equalTo(-15);
            make.bottom.mas_equalTo(-10);
            make.height.mas_offset(23);
        }];
        
        /// 添加tagLabel
        UILabel *tagLabel = [[UILabel alloc] init];
        tagLabel.layer.backgroundColor = HEX_RGB(0xD2D3D4).CGColor;
        tagLabel.layer.masksToBounds = YES;
        tagLabel.layer.cornerRadius = 3.0f;
        tagLabel.tag = 8888 + indexPath.row;
        tagLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.textColor = kWhiteColor;
        [cell.contentView addSubview:tagLabel];
        [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.bottom.mas_equalTo(-10);
            make.height.mas_offset(GetAdapterHeight(25));
            make.right.mas_equalTo(button.mas_left).offset(-10);
        }];
    }
    
    UILabel *titleLabel = [cell.contentView viewWithTag:7777 + indexPath.row];
    if (titleLabel) {
        titleLabel.text = ((WeiMiHotCommandDTO *)safeObjectAtIndex(_cardsData, indexPath.row)).infoTitle;
    }
    
    UILabel *tagLabel = [cell.contentView viewWithTag:8888 + indexPath.row];
    if (tagLabel) {
        NSString *text = ((WeiMiHotCommandDTO *)safeObjectAtIndex(_cardsData, indexPath.row)).createTime;
        CGSize size = [text returnSize:[UIFont systemFontOfSize:14]];
        [tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.mas_offset(size.width+10);
        }];
        tagLabel.text = text;
    }
    
    UIButton *commentBTN = [cell.contentView viewWithTag:9999 + indexPath.row];
    if (commentBTN) {
        NSString *commentNum = [NSString stringWithFormat:@"%ld", (long)((WeiMiHotCommandDTO *)safeObjectAtIndex(_cardsData, indexPath.row)).dianzan];
        [commentBTN setTitle:commentNum forState:UIControlStateNormal];
    }
    
    return cell;
}



#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 10;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除点击背景颜色
    
    WeiMiInvitationVC *vc = [[WeiMiInvitationVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.popWithBaseNavColor = NO;
    vc.dto = safeObjectAtIndex(_cardsData, indexPath.row);
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
#pragma mark - Constraints
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    
    
    if (_notiView) {
        
        [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.tableView);
            make.width.mas_equalTo(self.tableView).multipliedBy(0.5);
            make.bottom.mas_equalTo(self.tableView.mas_centerY).offset(-20);
        }];
    }
    
    if (_goAnyWhereBtn) {
        [_goAnyWhereBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.tableView);
            make.top.mas_equalTo(self.tableView.mas_centerY).offset(20);
            make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(130), GetAdapterHeight(35)));
        }];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

}


@end
