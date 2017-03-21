//
//  WeiMiCreditExchangeVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditExchangeVC.h"
#import "WeiMiBaseTableView.h"
#import "UIButton+CenterImageAndTitle.h"
#import "WeiMiCreditExchangeCell.h"
#import "WeiMiRefreshComponents.h"

//----- VC
#import "WeiMiExchangeVC.h"
//----- request
#import "WeiMiCreditExchangeRequest.h"
#import "WeiMiCreditExchangeResponse.h"

#define kTextColor      (0x4ECDC7)
#define kHeaderBGColor  (0xF7F7F7)
@interface WeiMiCreditExchangeVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSMutableArray *_dataSource;
    __block NSInteger _currentPage;

}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) WeiMiBaseView *headerBGView;
@property (nonatomic, strong) UIButton *headerLeftBTN;
@property (nonatomic, strong) UIButton *headerRightBTN;
@property (nonatomic, strong) UIImageView *rightArrow;

@property (nonatomic, strong) NSArray *User;

@end

@implementation WeiMiCreditExchangeVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentPage = 1;
        _dataSource = [NSMutableArray new];
//        WeiMiCreditExchangeDTO *dto = [[WeiMiCreditExchangeDTO alloc] init];
//        [_dataSource addObjectsFromArray:@[dto, dto, dto]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    _tableView.tableHeaderView  = self.headerBGView;
    
    [_headerBGView addSubview:self.headerLeftBTN];
    [_headerBGView addSubview:self.headerRightBTN];
    [_headerBGView addSubview:self.rightArrow];
    
    [_headerLeftBTN setTitle:[NSString stringWithFormat:@"%@积分",EncodeStringFromDic(self.params, @"creditNum")] forState:UIControlStateNormal];
    
    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getExchangeListWithSortStr:nil pageIndex:_currentPage pageSize:10];
    }];

    [self getExchangeListWithSortStr:nil pageIndex:_currentPage pageSize:10];

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
    self.title = @"积分兑换";
    WS(weakSelf);
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];

}

#pragma mark - Getter
- (UIImageView *)rightArrow
{
    if (!_rightArrow) {
        
        _rightArrow = [[UIImageView alloc] init];
        _rightArrow.image = [UIImage imageNamed:@"icon_back_right"];
        [_rightArrow sizeToFit];
    }
    return _rightArrow;
}

- (WeiMiBaseView *)headerBGView
{
    if (!_headerBGView) {
        _headerBGView = [[WeiMiBaseView alloc] init];
        _headerBGView.backgroundColor = HEX_RGB(kHeaderBGColor);
        _headerBGView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    }
    return _headerBGView;
}

- (UIButton *)headerLeftBTN
{
    if (!_headerLeftBTN) {
        
        _headerLeftBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerLeftBTN sizeToFit];
        [_headerLeftBTN setTitle:@"0积分" forState:UIControlStateNormal];
        [_headerLeftBTN setTitleColor:HEX_RGB(kTextColor) forState:UIControlStateNormal];
        _headerLeftBTN.titleLabel.font = [UIFont boldSystemFontOfSize:kFontSizeWithpx(22)];
        [_headerLeftBTN setImage:[UIImage imageNamed:@"icon_rmb-0"] forState:UIControlStateNormal];
        [_headerLeftBTN setImage:[UIImage imageNamed:@"icon_rmb-0"] forState:UIControlStateHighlighted];
    }
    return _headerLeftBTN;
}

- (UIButton *)headerRightBTN
{
    if (!_headerRightBTN) {
        
        _headerRightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headerRightBTN sizeToFit];
        [_headerRightBTN setTitle:@"兑换记录" forState:UIControlStateNormal];
        [_headerRightBTN setTitleColor:kGrayColor forState:UIControlStateNormal];
        _headerRightBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_headerRightBTN setImage:[UIImage imageNamed:@"icon_jilu"] forState:UIControlStateNormal];
        [_headerRightBTN setImage:[UIImage imageNamed:@"icon_jilu"] forState:UIControlStateHighlighted];
        [_headerRightBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerRightBTN;
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

#pragma mark - Network
//---- 获取积分列表
- (void)getExchangeListWithSortStr:(NSString *)strSort pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiCreditExchangeRequest *request = [[WeiMiCreditExchangeRequest alloc] initWithStrSort:strSort pageIndex:index pageSize:pageSize];
    WeiMiCreditExchangeResponse *response = [[WeiMiCreditExchangeResponse alloc] init];
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

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiExchangeRecordVC"];
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
    WS(weakSelf);
    WeiMiCreditExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        SS(strongSelf);
        cell = [[WeiMiCreditExchangeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor
        
        
        cell.onButtonHandler = ^{
            WeiMiExchangeVC *vc = [[WeiMiExchangeVC alloc] init];
            vc.dto = safeObjectAtIndex(_dataSource, indexPath.row);
            vc.currentCredit = EncodeNumberFromDic(self.params, @"creditNum").integerValue;
            [strongSelf.navigationController pushViewController:vc animated:YES];
        };
    }
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    return cell;
}


#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
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
    
//    [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiExchangeVC"];
    WeiMiExchangeVC *vc = [[WeiMiExchangeVC alloc] init];
    vc.dto = safeObjectAtIndex(_dataSource, indexPath.row);
    vc.currentCredit = EncodeNumberFromDic(self.params, @"creditNum").integerValue;
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
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [_headerLeftBTN horizontalCenterImageAndTitle];
    [_headerRightBTN horizontalCenterImageAndTitle];
}

- (void)updateViewConstraints
{
    [_headerLeftBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_headerBGView);
        make.left.mas_equalTo(15);
    }];
    
    [_rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_headerBGView);
        make.right.mas_equalTo(-5);

    }];
    
    [_headerRightBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.mas_equalTo(_headerBGView);
        make.right.mas_equalTo(_rightArrow.mas_left);
    }];
    [super updateViewConstraints];
}


@end
