//
//  WeiMiExchangeRecordVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiExchangeRecordVC.h"
#import "WeiMiBaseTableView.h"
#import "UIButton+CenterImageAndTitle.h"
#import "WeiMiCreditExchangeCell.h"
#import "WeiMiNotifiEmptyView.h"

#import "WeiMiExchangeDetailVC.h"
#import "WeiMiRefreshComponents.h"

//----- request
//#import "WeiMiCreditRecordRequest.h"
//#import "WeiMiCreditRecordResponse.h"

#import "WeiMiCreditExchangeListRequest.h"
#import "WeiMiCreditExchangeListResponse.h"

#define kTextColor      (0x4ECDC7)
#define kHeaderBGColor  (0xF7F7F7)
@interface WeiMiExchangeRecordVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{

//    NSMutableArray *_dataSource;
    __block NSInteger _currentPage;

}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiEmptyView;
@property (nonatomic, strong) UIButton *goExChangeBTN;
/**数据源*/
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation WeiMiExchangeRecordVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dataSource = [NSMutableArray new];
        _currentPage = 1;
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
    
    [_tableView addSubview:self.notiEmptyView];
    [_tableView addSubview:self.goExChangeBTN];
    [_tableView setNeedsUpdateConstraints];
    
    _notiEmptyView.hidden = YES;
    _goExChangeBTN.hidden = YES;

    //上拉刷新
    _tableView.mj_footer = [WeiMiRefreshComponents defaultFooterWithRefreshingBlock:^{
        
        [self getCreditRecord:[WeiMiUserCenter sharedInstance].userInfoDTO.tel pageIndex:_currentPage pageSize:10];
    }];
    
    [self getCreditRecord:[WeiMiUserCenter sharedInstance].userInfoDTO.tel pageIndex:_currentPage pageSize:10];
    
    [self addObserver:self forKeyPath:@"dataSource" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"dataSource"];
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
    self.title = @"兑换记录";
    WS(weakSelf);
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
}

#pragma mark - Getter
- (UIButton *)goExChangeBTN
{
    if (!_goExChangeBTN) {
        
        _goExChangeBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goExChangeBTN setTitle:@"去兑换" forState:UIControlStateNormal];
        [_goExChangeBTN setTitleColor:kWhiteColor forState:UIControlStateNormal];
        _goExChangeBTN.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_goExChangeBTN setBackgroundImage:[UIImage imageNamed:@"btn_pre"] forState:UIControlStateNormal];
        [_goExChangeBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _goExChangeBTN;
}

- (WeiMiNotifiEmptyView *)notiEmptyView
{
    if (!_notiEmptyView) {
        _notiEmptyView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiEmptyView setViewWithImg:@"icon_list" title:@"您没有可用奖品哦~\n快去兑换吧!"];
    };
    return _notiEmptyView;
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

#pragma mark - Network


//---- 获取积分列表
- (void)getCreditRecord:(NSString *)phone pageIndex:(NSInteger)index pageSize:(NSInteger)pageSize
{
    WeiMiCreditExchangeListRequest *request = [[WeiMiCreditExchangeListRequest alloc] initWithMemberId:phone pageIndex:index pageSize:pageSize];
    WeiMiCreditExchangeListResponse *response = [[WeiMiCreditExchangeListResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [[self mutableArrayValueForKey:@"dataSource"] addObjectsFromArray:response.dataArr];
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

#pragma mark - KVO
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    id _oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    id _newValue = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (![_newValue isEqual:_oldValue])
    {
        //有变动
        if ([keyPath isEqualToString:@"dataSource"]) {
            if (_dataSource.count == 0) {
                _notiEmptyView.hidden = NO;
                _goExChangeBTN.hidden = NO;
            }else
            {
                _notiEmptyView.hidden = YES;
                _goExChangeBTN.hidden = YES;
            }
            return;
        }
    }
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    WS(weakSelf);
    [self presentSheet:@"去兑换吧~" complete:^{
        SS(strongSelf);
        [strongSelf BackToLastNavi];

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
    
    WeiMiCreditExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];    if (!cell) {
        cell = [[WeiMiCreditExchangeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    
    [cell setViewWithCreditDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
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
    
    WeiMiExchangeDetailVC *vc = [[WeiMiExchangeDetailVC alloc] init];
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

}

- (void)updateViewConstraints
{
    [_notiEmptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
    
    [_goExChangeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(130, 34));
        make.top.mas_equalTo(_notiEmptyView.mas_bottom).offset(10);
    }];
    [super updateViewConstraints];
}

@end
