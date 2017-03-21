//
//  WeiMiMyCollectionVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/14.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCollectionVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiSegmentView.h"
#import "WeiMiNotifiEmptyView.h"
#import "WeiMiRefreshComponents.h"

// ---------- category
#import "UIButton+CenterImageAndTitle.h"
#import <UIImageView+WebCache.h>

// ---------- DTO
#import "WeiMiGoodsDTO.h"
#import "WeiMiCardsDTO.h"
//---------- request
#import "WeiMiMyCollectionListRequest.h"
#import "WeiMiMyCollectionListResponse.h"
#import "WeiMiCollectionDeleteRequest.h"

typedef NS_ENUM(NSInteger, TABLEVIEWTYPE)
{
    TABLEVIEWTYPE_GOODS,
    TABLEVIEWTYPE_CARDS,
};
@interface WeiMiMyCollectionVC()<UITableViewDelegate, UITableViewDataSource, WeiMiSegmentViewDelegate>
{
//    /**数据源*/
//    NSMutableArray *_goodsData;
//    NSMutableArray *_cardsData;
    TABLEVIEWTYPE _tableType;
    __block BOOL _editFlag;
    NSMutableArray *_selectedGoodsArr;
    NSMutableArray *_selectedCardsArr;
    BOOL _selectAllTag;
    
    NSInteger _currentGoodsPage;
    NSInteger _currentCardsPage;

}

@property (nonatomic, strong) WeiMiSegmentView *segView;
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIButton *selectedAllBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIButton *goAnyWhereBtn;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;

@property (nonatomic, strong)    NSMutableArray *goodsData;
@property (nonatomic, strong)    NSMutableArray *cardsData;
@end

@implementation WeiMiMyCollectionVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tableType = TABLEVIEWTYPE_GOODS;
        _goodsData = [NSMutableArray new];
        _cardsData = [NSMutableArray new];
        _selectedGoodsArr = [NSMutableArray new];
        _selectedCardsArr = [NSMutableArray new];
        
        _currentCardsPage = 1;
        _currentGoodsPage = 1;
//        WeiMiGoodsDTO *dto = [[WeiMiGoodsDTO alloc] init];
//        [_goodsData addObjectsFromArray:@[dto, dto, dto, dto]];
        
//        WeiMiCardsDTO *dtoCards = [[WeiMiCardsDTO alloc] init];
//        [_cardsData addObjectsFromArray:@[dtoCards, dtoCards, dtoCards, dtoCards]];
        
        [self addObserver:self forKeyPath:@"goodsData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld  context:NULL];
        [self addObserver:self forKeyPath:@"cardsData" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"goodsData"];
    [self removeObserver:self forKeyPath:@"cardsData"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.notiView];
    
    [self.contentView addSubview:self.goAnyWhereBtn];
    _notiView.hidden = YES;
    _goAnyWhereBtn.hidden = YES;
    
    [self.view setNeedsUpdateConstraints];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getCollectionListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:_tableType == TABLEVIEWTYPE_GOODS ? @"1":@"2" pageIndex:_tableType == TABLEVIEWTYPE_GOODS ? _currentGoodsPage:_currentCardsPage pageSize:10 isRefresh:YES];
    }];
    
    //下拉刷新
    _tableView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        _currentGoodsPage = 1;
        _currentCardsPage = 1;
        if (_tableType == TABLEVIEWTYPE_GOODS) {
            [_goodsData removeAllObjects];
        }else if (_tableType == TABLEVIEWTYPE_CARDS)
        {
            [_cardsData removeAllObjects];
        }
        [self getCollectionListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:_tableType == TABLEVIEWTYPE_GOODS ? @"1":@"2" pageIndex:_tableType == TABLEVIEWTYPE_GOODS ? _currentGoodsPage:_currentCardsPage pageSize:10 isRefresh:YES];
    }];
    
    [self getCollectionListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:_tableType == TABLEVIEWTYPE_GOODS ? @"1":@"2" pageIndex:_tableType == TABLEVIEWTYPE_GOODS ? _currentGoodsPage : _tableType == TABLEVIEWTYPE_GOODS ? _currentGoodsPage:_currentCardsPage pageSize:10 isRefresh:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)changeNavBar
{
    [self.navigationController.navigationBar setBarTintColor:HEX_RGB(SEC_COLOR_HEX)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor}];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"我的收藏";
    
    self.navigationItem.titleView = self.segView;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:@"icon_back" action:^{
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    
    [self AddRightBtn:@"编辑" normal:nil selected:nil action:^{
        SS(strongSelf);
 
        [strongSelf.tableView setEditing:!_editFlag animated:YES];
        if (!_editFlag) {
            
            _tableView.frame = [self visibleBoundsShowNav:YES showTabBar:YES];
            [strongSelf.view addSubview:self.selectedAllBtn];
            [strongSelf.view addSubview:self.deleteBtn];
            if (_selectedAllBtn) {
                [_selectedAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.left.mas_equalTo(15);
                    make.bottom.mas_equalTo(-TAB_BAR_HEIGHT/2 + 35/2);
                    make.size.mas_equalTo(CGSizeMake(55, 35));
                }];
            }
            
            if (_deleteBtn) {
                [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.mas_equalTo(-15);
                    make.centerY.mas_equalTo(_selectedAllBtn);
                    make.size.mas_equalTo(CGSizeMake(100, GetAdapterHeight(35)));
                }];
            }
            
        }else
        {
            _tableView.frame = [self visibleBoundsShowNav:YES showTabBar:NO];
            [self.selectedAllBtn removeFromSuperview];
            [self.deleteBtn removeFromSuperview];
        }
        _editFlag = !_editFlag;
    }];
}

#pragma mark - Getter
- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiView setViewWithImg:@"icon_heart" title:@"您还没有收藏的商品"];
    }
    return _notiView;
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

- (UIButton *)selectedAllBtn
{
    if (!_selectedAllBtn) {
        
        _selectedAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectedAllBtn.backgroundColor = kWhiteColor;
        _selectedAllBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        [_selectedAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_selectedAllBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
        [_selectedAllBtn setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
        [_selectedAllBtn setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
        [_selectedAllBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedAllBtn;
}



- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.layer.cornerRadius = 3.0f;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
- (WeiMiSegmentView *)segView
{
    if (!_segView) {
        _segView = [[WeiMiSegmentView alloc] initWithFrame:CGRectMake(0, 0, GetAdapterHeight(150), 50) titleArray:@[@"商品", @"帖子"] defaultSelectIndex:0 delegate:self];
        _segView.delegate = self;
    }
    return _segView;
}

- (WeiMiBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.frame = self.contentFrame;
        _tableView.allowsSelection = YES;
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Common
/* set cell selected actions*/
- (void)setCellSelected:(BOOL)selected
{
    if (selected) {
        NSMutableArray *tempArr = _goodsData;
        if (_tableType == TABLEVIEWTYPE_CARDS) {
            tempArr = _cardsData;
            for (int i = 0; i < _goodsData.count; i++) {
                
            }
        } else {
            
        }
        WS(weakSelf);
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            SS(strongSelf);
            [strongSelf tableView:strongSelf.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0]];
            [strongSelf.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        }];
    }else {
        WS(weakSelf);
        NSMutableArray *tempArr = _goodsData;
        if (_tableType == TABLEVIEWTYPE_CARDS) {
            tempArr = _cardsData;
        }
        [tempArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            SS(strongSelf);
            [strongSelf.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] animated:YES];
            [strongSelf tableView:strongSelf.tableView didDeselectRowAtIndexPath:[NSIndexPath indexPathForItem:idx inSection:0] ];
        }];
    }
}

#pragma mark - Network
//---- 获取积收藏列表
- (void)getCollectionListWithMemberId:(NSString *)memberId isAble:(NSString *)isAble pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize isRefresh:(BOOL) isFresh
{
    if (!isFresh) {//不是刷新只是切换
        if ([isAble isEqualToString:@"1"] && index > 1) {//产品
            [_tableView reloadData];
            return;
        }else if ([isAble isEqualToString:@"2"] && index > 1)//帖子
        {
            [_tableView reloadData];
            return;
        }
    }
    WeiMiMyCollectionListRequest *request = [[WeiMiMyCollectionListRequest alloc] initWithMemberId:memberId isAble:isAble pageIndex:index pageSize:pageSize];
    request.showHUD = YES;
    WeiMiMyCollectionListResponse *response = [[WeiMiMyCollectionListResponse alloc] init];

    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            if ([isAble isEqualToString:@"1"]) {
                [response parseResponse:result isGoods:YES];
                [_goodsData addObjectsFromArray:response.dataArr ];
                _currentGoodsPage ++;
            }else if ([isAble isEqualToString:@"2"])
            {
                [response parseResponse:result isGoods:NO];
                [_cardsData addObjectsFromArray:response.dataArr];
                _currentCardsPage ++;
            }
//            [strongSelf.tableView reloadData];
            [_tableView.mj_footer endRefreshing];
        }else
        {
            if ([_tableView.mj_footer isRefreshing]) {
                [_tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [strongSelf.tableView reloadData];

        [_tableView.mj_header endRefreshing];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
        [_tableView.mj_header endRefreshing];

    }];
        
}


/// 删除帖子/商品收藏
- (void)getCollectionDeleteWithCollectId:(NSString *)collectId
{
    WeiMiCollectionDeleteRequest *request = [[WeiMiCollectionDeleteRequest alloc] initWithCollectId:collectId];
    request.showHUD = YES;
    
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            [strongSelf configDelete];
            [strongSelf presentSheet:@"删除成功"];
        }else
        {
            [strongSelf presentSheet:@"删除失败"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

#pragma mark - Utils
- (void)configDelete
{
    NSMutableIndexSet *set = [[NSMutableIndexSet alloc] init];
    if (_tableType == TABLEVIEWTYPE_GOODS) {
        
        if (!_selectedGoodsArr.count) {
            return;
        }
        for (NSIndexPath *path in _selectedGoodsArr) {
            [set addIndex:path.row];
        }
        [_goodsData removeObjectsAtIndexes:set];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:_selectedGoodsArr withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [_selectedGoodsArr removeAllObjects];
        
        if (!_goodsData.count) {
            [self hiddenEmptyGoods:NO];
        }
        
    }else
    {
        for (NSIndexPath *path in _selectedCardsArr) {
            [set addIndex:path.row];
        }
        [self.tableView beginUpdates];
        [_cardsData removeObjectsAtIndexes:set];
        [self.tableView deleteRowsAtIndexPaths:_selectedCardsArr withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
        [_selectedCardsArr removeAllObjects];
        
        if (!_cardsData.count) {
            [self hiddenEmptyCards:NO];
        }
    }
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == self.selectedAllBtn) {//全选按钮
        
        sender.selected = !sender.selected;
        _selectAllTag = sender.selected;
        if (!_selectAllTag) {
            [_selectedGoodsArr removeAllObjects];
            [_selectedCardsArr removeAllObjects];
            
        }
        [self setCellSelected:_selectAllTag];

    }else if (sender == self.deleteBtn)//删除按钮
    {
        if (_tableType == TABLEVIEWTYPE_GOODS) {//商品
            for (NSIndexPath *path in _selectedGoodsArr) {
                WeiMiGoodsDTO *dto = safeObjectAtIndex(_goodsData, path.row);
                if (dto) {
                    [self getCollectionDeleteWithCollectId:dto.collectId];
                }
            }
        }else//帖子
        {
            for (NSIndexPath *path in _selectedCardsArr) {
                WeiMiMFInvitationListDTO *dto = safeObjectAtIndex(_cardsData, path.row);
                if (dto) {
                    [self getCollectionDeleteWithCollectId:dto.collectId];
                }
            }
        }
        
    }
}

- (void)hiddenEmptyGoods:(BOOL)hidden
{
    self.notiView.hidden = hidden;
    self.goAnyWhereBtn.hidden = hidden;
    [_notiView setViewWithImg:@"icon_heart" title:@"您还没有收藏的商品"];
}

- (void)hiddenEmptyCards:(BOOL)hidden
{
    self.notiView.hidden = hidden;
    self.goAnyWhereBtn.hidden = hidden;
    [_notiView setViewWithImg:@"icon_heart" title:@"您还没有收藏的帖子"];
}

#pragma mark - WeiMiSegmentViewDelegate
- (void)didSelectedAtIndex:(NSUInteger)index
{
    _selectAllTag = NO;
    _selectedAllBtn.selected = NO;
    [self setCellSelected:NO];
    if (index == 0) {//点击了商品
        
        _tableType = TABLEVIEWTYPE_GOODS;

        [self hiddenEmptyCards:YES];
//        [self hiddenEmptyGoods:YES];
//        if (!_goodsData.count) {
//            [self hiddenEmptyGoods:NO];
//        }else
//        {
//            [self hiddenEmptyGoods:YES];
//        }
    }else if (index == 1)//点击了帖子
    {
        _tableType = TABLEVIEWTYPE_CARDS;
        
        [self hiddenEmptyGoods:YES];

//        [self hiddenEmptyCards:YES];
//        if (!_cardsData.count) {
//            [self hiddenEmptyCards:NO];
//        }else
//        {
//            [self hiddenEmptyCards:YES];
//        }
    }
    
    [self getCollectionListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:_tableType == TABLEVIEWTYPE_GOODS ? @"1":@"2" pageIndex:_tableType == TABLEVIEWTYPE_GOODS ? _currentGoodsPage : _currentCardsPage pageSize:10 isRefresh:NO];
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
        if ([keyPath isEqualToString:@"goodsData"]) {
            if (_goodsData.count == 0) {
//                [self changeToEmptyShoppingCart:YES];
//                [_hotGoodsCollection reloadData];
                [self hiddenEmptyGoods:NO];
            }else
            {
                [self hiddenEmptyGoods:YES];
//                [self changeToEmptyShoppingCart:NO];
            }
        }else if ([keyPath isEqualToString:@"cardsData"])
        {
            if (_cardsData.count == 0) {

                [self hiddenEmptyCards:NO];
            }else
            {
               [self hiddenEmptyCards:YES];
            }
        }
    }
}


#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tableType == TABLEVIEWTYPE_GOODS) {
        return _goodsData.count;
    }
    return _cardsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 商品详细cell
    if (_tableType == TABLEVIEWTYPE_GOODS) {
        static NSString *cellID = @"goodsCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            /// 添加标题label
            UILabel *titleLabel = [[UILabel alloc] init];
            titleLabel.tag = 7777 + indexPath.row;
            titleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(21)];
            titleLabel.textAlignment = NSTextAlignmentLeft;
            titleLabel.numberOfLines = 2;
            titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            [cell.contentView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(cell.imageView.mas_right).offset(10);
                make.top.mas_equalTo(10);
                make.right.mas_offset(-10);
            }];

            /// 添加详情label
            UILabel *detailLabel = [[UILabel alloc] init];
            detailLabel.tag = 9999 + indexPath.row;
            detailLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
            detailLabel.textAlignment = NSTextAlignmentLeft;
            detailLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            [cell.contentView addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.mas_equalTo(titleLabel);
                make.bottom.mas_equalTo(-10);
                make.right.mas_offset(-10);
            }];
        }
        
        WeiMiGoodsDTO *dto = safeObjectAtIndex(_goodsData, indexPath.row);
        UILabel *titleLabel = [cell.contentView viewWithTag:7777 + indexPath.row];
        if (titleLabel) {
            titleLabel.text = dto.titleStr;
        }
        
        UILabel *detailLabel = [cell.contentView viewWithTag:9999 + indexPath.row];
        if (detailLabel) {
            detailLabel.text = [NSString stringWithFormat:@"$ %@元",dto.priceStr];//dto.priceStr;
        }
        
        cell.imageView.image = WEIMI_IMAGENAMED(@"weimiQrCode");
        //重绘image大小来 调整imageView大小
        CGSize itemSize = CGSizeMake(65, 65);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cell.imageView.image drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.imageURL)] options:SDWebImageRetryFailed progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image) {
                cell.imageView.image = image;

                //重绘image大小来 调整imageView大小
                CGSize itemSize = CGSizeMake(65, 65);
                UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
                [cell.imageView.image drawInRect:imageRect];
                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
        }];
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:WEIMI_IMAGEREMOTEURL(dto.imageURL)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                //重绘image大小来 调整imageView大小
//                CGSize itemSize = CGSizeMake(65, 65);
//                UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//                CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//                [cell.imageView.image drawInRect:imageRect];
//                cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
//            }
//        }];
        
        return cell;
    }
    
    // 帖子详情cell
    static NSString *cellID = @"cardsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        UIView *view = [UIView new];
        view.backgroundColor = kClearColor;
        cell.selectedBackgroundView = view;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        /// 添加标题label
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.tag = 7777 + indexPath.row;
        titleLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(21)];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.numberOfLines = 2;
        titleLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        [cell.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.right.mas_offset(-10);
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
        }];
        
        //添加评论数量btn
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 9999 + indexPath.row;
        button.backgroundColor = kWhiteColor;
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
    }
    
    UILabel *titleLabel = [cell.contentView viewWithTag:7777 + indexPath.row];//标题
    if (titleLabel) {
        titleLabel.text = ((WeiMiMFInvitationListDTO *)safeObjectAtIndex(_cardsData, indexPath.row)).infoTitle;
    }
    
    UILabel *tagLabel = [cell.contentView viewWithTag:8888 + indexPath.row];//标签
    if (tagLabel) {
        NSString *text = ((WeiMiMFInvitationListDTO *)safeObjectAtIndex(_cardsData, indexPath.row)).dzscription;
        CGSize size = [text returnSize:[UIFont systemFontOfSize:14]];
        [tagLabel mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.width.mas_offset(size.width+10);
        }];
        tagLabel.text = text;
    }
    
    UIButton *commentBTN = [cell.contentView viewWithTag:9999 + indexPath.row];//评论数
    if (commentBTN) {
        NSString *commentNum = ((WeiMiMFInvitationListDTO *)safeObjectAtIndex(_cardsData, indexPath.row)).pinglun;
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

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_tableType == TABLEVIEWTYPE_GOODS) {
        [_selectedGoodsArr removeObject:indexPath];
    } else {
        [_selectedCardsArr removeObject:indexPath];
    }
    
    NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
    for (id obj in subviews) {
        if ([obj isKindOfClass:[UIControl class]]) {
            
            for (id subview in [obj subviews]) {
                if ([subview isKindOfClass:[UIImageView class]]) {
                    
                    [subview setValue:[HEX_RGB(BASE_COLOR_HEX) colorWithAlphaComponent:0.9] forKey:@"tintColor"];
                    [subview setValue:[UIImage imageNamed:@"icon_circle"] forKey:@"image"];
                    break;
                }
                
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 去除点击背景颜色
    if (tableView.isEditing) {
        if (_tableType == TABLEVIEWTYPE_GOODS) {
            [_selectedGoodsArr addObject:indexPath];
        }else
        {
            [_selectedCardsArr addObject:indexPath];
        }
        NSArray *subviews = [[tableView cellForRowAtIndexPath:indexPath] subviews];
        
        for (id obj in subviews) {
            if ([obj isKindOfClass:[UIControl class]]) {
                
                for (id subview in [obj subviews]) {
                    if ([subview isKindOfClass:[UIImageView class]]) {
                        
                        [subview setValue:[HEX_RGB(BASE_COLOR_HEX) colorWithAlphaComponent:0.9] forKey:@"tintColor"];
                        [subview setValue:[UIImage imageNamed:@"icon_ball_pre"] forKey:@"image"];
                        break;
                    }
                    
                }
            }
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
- (void)updateViewConstraints
{
    [super updateViewConstraints];
    

    if (_notiView) {
        
        [_notiView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.view);
            make.width.mas_equalTo(self.view).multipliedBy(0.5);
            make.bottom.mas_equalTo(self.view.mas_centerY).offset(-20);
        }];
    }
    
    if (_goAnyWhereBtn) {
        [_goAnyWhereBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerX.mas_equalTo(self.view);
            make.top.mas_equalTo(self.view.mas_centerY).offset(20);
            make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(130), GetAdapterHeight(35)));
        }];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    if (_selectedAllBtn) {
        [_selectedAllBtn horizontalCenterImageAndTitle];
    }
}

@end
