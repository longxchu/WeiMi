//
//  WeiMiMyCreditVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyCreditVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiMyCreditHeaderView.h"
#import "UILabel+NotiLabel.h"
#import "WeiMiRefreshComponents.h"
//-------- request
#import "WeiMiPersonalCreditRequest.h"
#import "WeiMiCreditRecordRequest.h"
#import "WeiMiCreditRecordResponse.h"

@interface WeiMiMyCreditVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSMutableArray *_dataSource;
    __block NSInteger _currentPage;
    NSString *_creditNum;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) UILabel *rightLabelFAC;

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) WeiMiMyCreditHeaderView *creditView;
@property (nonatomic, strong) UIButton *exchangeBtn;
@property (nonatomic, strong) UILabel *notiLabel;

@end

@implementation WeiMiMyCreditVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
//        _dataSource = @[@"兑换礼品",
//                        @"系统通知",
//                        @"我的消息"];
        _dataSource = [NSMutableArray new];
        _currentPage = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    _tableView.tableHeaderView = self.bgView;

    [_bgView addSubview:self.creditView];
    [_bgView addSubview:self.exchangeBtn];
//    self.notiLabel = [UILabel footerNotiLabelWithTitle:@"最近30天积分记录" textAlignment:NSTextAlignmentLeft];
//    [_bgView addSubview:_notiLabel];
    
    [self.view setNeedsUpdateConstraints];
    
    [self getCreditNumWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel];
    
    //上拉刷新
//    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
//        
//        [self getCreditRecord:[WeiMiUserCenter sharedInstance].userInfoDTO.tel pageIndex:_currentPage pageSize:10];
//    }];
//    
//    [self getCreditRecord:[WeiMiUserCenter sharedInstance].userInfoDTO.tel pageIndex:_currentPage pageSize:10];
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
    self.title = @"我的积分";
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = _tableView.backgroundColor;
        _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 455/2);
    }
    return _bgView;
}

- (WeiMiMyCreditHeaderView *)creditView
{
    if (!_creditView) {
        _creditView = [[WeiMiMyCreditHeaderView alloc] init];
        _creditView.backgroundColor = kWhiteColor;
        _creditView.frame = CGRectMake(10, 6, SCREEN_WIDTH - 20, GetAdapterHeight(150));
        
        _creditView.onIntroBTNHandler = ^{
            [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiCreditIntroVC"];
        };
    }
    return _creditView;
}

- (UIButton *)exchangeBtn
{
    if (!_exchangeBtn) {
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBtn.titleLabel.font = WeiMiSystemFontWithpx(22);
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_exchangeBtn setTitle:@"兑换商品" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_exchangeBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_exchangeBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_exchangeBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _exchangeBtn;
}

- (UILabel *)rightLabelFAC
{
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
    detailLabel.textAlignment = NSTextAlignmentRight;
    detailLabel.textColor = HEX_RGB(0xEE8E31);
    
    return detailLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}


#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == _exchangeBtn) {
        NSLog(@"%@",_creditNum);
        [[WeiMiPageSkipManager mineRT] open:[NSString stringWithFormat:@"WeiMiCreditExchangeVC/%@", _creditNum]];
    }
}
#pragma mark - NetWork
// -------- 获得个人积分
- (void)getCreditNumWithMemberId:(NSString *)phone
{
    WeiMiPersonalCreditRequest *request = [[WeiMiPersonalCreditRequest alloc] initWithMemberId:phone];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
//        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        _creditNum = result;
        if (result) {
            [_creditView setCreditNum:result];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

//---- 获取积分列表
- (void)getCreditRecord:(NSString *)phone pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiCreditRecordRequest *request = [[WeiMiCreditRecordRequest alloc] initWithMemberId:phone pageIndex:index pageSize:pageSize];
    WeiMiCreditRecordResponse *response = [[WeiMiCreditRecordResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [_dataSource addObjectsFromArray:response.dataArr];
            [strongSelf.tableView reloadData];
            
            _currentPage ++;
            [_tableView.mj_footer endRefreshing];
        }else
        {
            [_tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        [_tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        cell.detailTextLabel.textColor = kGrayColor;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
       
        UILabel *label = [self rightLabelFAC];
        [label sizeToFit];
        label.tag = 8888 + indexPath.row;
        [cell.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(cell);
            make.right.mas_equalTo(-20);
        }];
    }
    
//    WeiMiMyCreditDTO *dto = safeObjectAtIndex(_dataSource, indexPath.row);
//    cell.textLabel.text = dto.isAble;
//    cell.detailTextLabel.text = dto.createTime;
//    
//    UILabel *label = [cell viewWithTag:8888 + indexPath.row];
//    if (label) {
//        label.text = dto.integrate;
//    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
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
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat height = _exchangeBtn.bottom + _notiLabel.height + 20;
    _bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    _tableView.tableHeaderView = self.bgView;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)updateViewConstraints
{
    [_exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(_bgView);
        make.size.mas_equalTo(CGSizeMake(258/2, 35));
        make.top.mas_equalTo(_creditView.mas_bottom).offset(20);
    }];
    
    [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(_bgView).offset(-10);
        make.right.mas_equalTo(0);
    }];
    
    [super updateViewConstraints];
}

@end
