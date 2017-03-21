//
//  WeiMiPrivilegeVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/27.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPrivilegeVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiPrivilegeCell.h"
#import <OHAlertView.h>
#import "WeiMiRefreshComponents.h"
//------ request
#import "WeiMiMyCouponListRequest.h"
#import "WeiMiMyCouponListResponse.h"
//兑换代金券
#import "WeiMiExchangeCouponRequest.h"

#define TABLE_BG_COLOR      (0xF6F6F6)
static NSString *kReuseViewID = @"reuseViewID";
static NSString *kCellID = @"cellID";

@interface WeiMiPrivilegeVC()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
{
    /**数据源*/
    NSMutableArray *_dataSource;
    
    __block NSInteger _currentPage;
}

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UITextField *searchField;
@property (nonatomic, strong) UIButton *addBtn;

@end

@implementation WeiMiPrivilegeVC

- (instancetype)init
{
    if (self = [super init]) {
        _dataSource = [NSMutableArray new];
//        WeiMiPrivilegeDTO *dto_1 = [[WeiMiPrivilegeDTO alloc] init];
//        WeiMiPrivilegeDTO *dto_2 = [[WeiMiPrivilegeDTO alloc] init];
//        dto_2.timeOut = YES;
//        [_dataSource addObjectsFromArray:@[dto_1, dto_2]];
        _currentPage = 1;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kWhiteColor;

    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.collectionView];
    self.collectionView.frame = self.contentFrame;
    
    [self.view setNeedsUpdateConstraints];
    
    //上拉刷新
    _collectionView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getCardListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:@"0" pageIndex:_currentPage pageSize:10];
    }];
    
    //下拉刷新
    _collectionView.mj_header = [WeiMiRefreshComponents defaultHeaderWithRefreshingBlock:^{
        _currentPage = 1;
        [_dataSource removeAllObjects];
        [self getCardListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:@"0" pageIndex:_currentPage pageSize:10];
    }];
    
    [self getCardListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:@"0" pageIndex:_currentPage pageSize:10];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"我的优惠券";
    WS(weakSelf);
    [self AddLeftBtn:nil normal:@"icon_back" selected:@"icon_back" action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
}

#pragma mark - Getter
- (UITextField *)searchField
{
    if (!_searchField) {
        _searchField = [[UITextField alloc] init];
        _searchField.borderStyle =  UITextBorderStyleRoundedRect;
        _searchField.placeholder = @"请输入优惠券密码";
        _searchField.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _searchField.returnKeyType = UIReturnKeyDone;
        _searchField.delegate = self;
    }
    return _searchField;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addBtn setTitleColor:HEX_RGB(0xDE4E4D) forState:UIControlStateNormal];
        [_addBtn setTitle:@"添加" forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(self.view.width/3, GetAdapterHeight(180));
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        //        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, GetAdapterHeight(40));
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.backgroundColor = HEX_RGB(TABLE_BG_COLOR);
        _collectionView.dataSource = self;
        _collectionView.delaysContentTouches = NO;
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.scrollEnabled = YES;
        [_collectionView registerClass:[WeiMiPrivilegeCell class] forCellWithReuseIdentifier:kCellID];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewID];
    }
    return _collectionView;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    if (_searchField.text) {
        WS(weakSelf);
//        [OHAlertView showAlertWithTitle:nil message:@"添加成功" cancelButton:@"确定" otherButtons:nil buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
//            SS(strongSelf);
//            WeiMiPrivilegeDTO *dto_1 = [[WeiMiPrivilegeDTO alloc] init];
//            [_dataSource addObject:dto_1];
//            [strongSelf.collectionView reloadData];
//        }];
//        return;
        
        [weakSelf exChnageWithStrCode:_searchField.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"] && textField.text) {
        [self exChnageWithStrCode:_searchField.text];
        
        return NO;
    }
    return YES;
}

#pragma mark - Network
//---- 获取我的优惠券列表
- (void)getCardListWithMemberId:(NSString *)memberId isAble:(NSString *)isAble pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{

    WeiMiMyCouponListRequest *request = [[WeiMiMyCouponListRequest alloc] initWithMemberId:memberId isAble:isAble pageIndex:index pageSize:pageSize];
    request.showHUD = YES;
    WeiMiMyCouponListResponse *response = [[WeiMiMyCouponListResponse alloc] init];
    
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [_dataSource addObjectsFromArray:response.dataArr ];
            _currentPage ++;
            [strongSelf.collectionView reloadData];
            [_collectionView.mj_footer endRefreshing];
        }else
        {
            if ([_collectionView.mj_footer isRefreshing]) {
                [_collectionView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        [_collectionView.mj_header endRefreshing];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_collectionView.mj_footer endRefreshing];
        [_collectionView.mj_header endRefreshing];
        
    }];
    
}

//兑换代金券
- (void)exChnageWithStrCode:(NSString *)password
{
    WeiMiExchangeCouponRequest *request = [[WeiMiExchangeCouponRequest alloc] initWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel strCode:password];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {

            [strongSelf presentSheet:@"兑换成功"];
            _currentPage = 1;
            [_dataSource removeAllObjects];
            [self getCardListWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel isAble:@"0" pageIndex:_currentPage pageSize:10];
        }else if ([result isEqualToString:@"2"])
        {
            [strongSelf presentSheet:@"兑换数量已满，不能再兑换"];
        }else if ([result isEqualToString:@"3"])
        {
            [strongSelf presentSheet:@"已经兑换过，不能重复兑换"];
        }else if ([result isEqualToString:@"4"])
        {
            [strongSelf presentSheet:@"兑换码错误"];
        }
    
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}

#pragma mark - WeiMiMyHPItemsCellDelegate

#pragma mark - UITableViewDataSource
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WeiMiPrivilegeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *headerView =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kReuseViewID forIndexPath:indexPath];
        
        [headerView addSubview:self.searchField];
        [headerView addSubview:self.addBtn];
        
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.bottom.mas_equalTo(0);
            make.width.mas_equalTo(60);
        }];
        [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(headerView);
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(35);
            make.right.mas_equalTo(_addBtn.mas_left);
        }];
        return headerView;
    }
    return nil;
}

#pragma mark - Delegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH - 20, 118);
}

#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{

    return CGSizeMake(SCREEN_WIDTH, 55);
}
@end
