//
//  WeiMiMoreCommentVC.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMoreCommentVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiNotifiEmptyView.h"
#import "WeiMiRefreshComponents.h"
#import "WeiMiGoodsDetailCommentCell.h"
// ---------- request
#import "WeiMiProductCommentListRequest.h"
#import "WeiMiProductCommentListResponse.h"

@interface WeiMiMoreCommentVC ()<UITableViewDelegate, UITableViewDataSource>
{
    __block NSInteger _currentPage;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
//提示为空
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *commentDataSource;

@end

@implementation WeiMiMoreCommentVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _commentDataSource = [NSMutableArray new];
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
    //    _notiView.hidden = YES;
    //    _goAnyWhereBtn.hidden = YES;
    
    [self.view setNeedsUpdateConstraints];
    
    [self addObserver:self forKeyPath:@"cardsData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    
    //    WeiMiCardsDTO *dtoCards = [[WeiMiCardsDTO alloc] init];
    //    [[self mutableArrayValueForKey:@"cardsData"] addObjectsFromArray:@[dtoCards, dtoCards, dtoCards, dtoCards]];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getCommentListWithProductId:self.productId pageIndex:_currentPage pageSize:10];
    }];
    
    //下拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        
        _currentPage = 1;
        [_commentDataSource removeAllObjects];
        [self getCommentListWithProductId:self.productId pageIndex:_currentPage pageSize:10];
    }];
    
    [self getCommentListWithProductId:self.productId pageIndex:_currentPage pageSize:10];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"cardsData"];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"更多评论";
    
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

- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"icon_heart" title:@"暂时没有评论"];
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
            if (_commentDataSource.count == 0) {
                _notiView.hidden = NO;
            }else
            {
                _notiView.hidden = YES;
            }
            return;
        }
    }
}

#pragma mark - Network
/// 评论列表
- (void)getCommentListWithProductId:(NSString *)productId pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiProductCommentListRequest *request = [[WeiMiProductCommentListRequest alloc] initWithProductId:productId pageIndex:index pageSize:pageSize];
    WeiMiProductCommentListResponse *res = [[WeiMiProductCommentListResponse alloc] init];
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);

        [res parseResponse:request.responseJSONObject];
        if (res.dataArr.count) {
            [_commentDataSource addObjectsFromArray:res.dataArr];

            
            _currentPage ++;
            [_tableView.mj_footer endRefreshing];
            [strongSelf.tableView reloadData];

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
    return _commentDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"cell_2";
    
    WeiMiGoodsDetailCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiGoodsDetailCommentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setViewWithDTO:safeObjectAtIndex(_commentDataSource, indexPath.row)];
    
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
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}


@end
