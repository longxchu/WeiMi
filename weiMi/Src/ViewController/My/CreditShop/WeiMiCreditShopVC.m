//
//  WeiMiCreditShopVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCreditShopVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiCreditShopCell.h"
#import "WeiMiCreditShopCell.h"
#import "WeiMiCreditExchangeVC.h"
#import "WeiMiPersonalCreditRequest.h"
//----- Request
//积分任务
#import "WeiMiCreditTaskRequest.h"
#import "WeiMiCreditTaskResponse.h"

static const CGFloat kHeaderLabelH = 35.0f;
@interface WeiMiCreditShopVC()<UITableViewDelegate, UITableViewDataSource>
{
    /**数据源*/
    NSMutableArray *_dataSource;
    NSString *_creditNum;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIImageView *headerView;



@end

@implementation WeiMiCreditShopVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.tableHeaderView = self.headerView;
    
    [self.view setNeedsUpdateConstraints];
    [self getCreditNumWithMemberId:[WeiMiUserCenter sharedInstance].userInfoDTO.tel];
    [self getCreditList];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor =YES;
    self.title = @"积分商城";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UILabel *)headerTitleWithText:(NSString *)text
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, NAV_HEIGHT+STATUS_BAR_HEIGHT, SCREEN_WIDTH, kHeaderLabelH);
    label.backgroundColor = HEX_RGB(BASE_TEXT_COLOR);
    label.textColor = kGrayColor;
    label.backgroundColor = kWhiteColor;
    label.font = [UIFont systemFontOfSize:15];

    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 20;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,text.length)];
    label.attributedText = attrStr;
    return label;
}
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
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}

- (UIImageView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIImageView alloc] init];
        _headerView.image = [UIImage imageNamed:@"banner"];
        _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, GetAdapterHeight(93));
        
        //积分商城图片点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [_headerView addGestureRecognizer:tap];
        //打开imageView的用户交互
        _headerView.userInteractionEnabled = YES;
    }
    return _headerView;
}



//图片点击事件实现
- (void)handleTap:(UITapGestureRecognizer *)tap {
    [[WeiMiPageSkipManager mineRT] open:[NSString stringWithFormat:@"WeiMiCreditExchangeVC/%@", _creditNum]];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Actions

#pragma mark - NetWork
//---- 获取积分列表
- (void)getCreditList
{
    WeiMiCreditTaskRequest *request = [[WeiMiCreditTaskRequest alloc] init];
    WeiMiCreditTaskResponse *response = [[WeiMiCreditTaskResponse alloc] init];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = request.responseJSONObject;
        NSInteger count = EncodeArrayFromDic(result, @"result").count;
        if (count) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            [_dataSource addObject:response.newbieArr];
            [_dataSource addObject:response.commonArr];
            [strongSelf.tableView reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
    }];
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_dataSource[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = [NSString stringWithFormat:@"creditShopCell_%ld_%ld", indexPath.section, indexPath.row];
    WeiMiCreditShopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiCreditShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        [cell setNeedsLayout];
        [cell layoutIfNeeded];
    }
    [cell setViewWithDTO:safeObjectAtIndex(safeObjectAtIndex(_dataSource, indexPath.section), indexPath.row)];
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeaderLabelH;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    WeiMiCreditShopCell *cell = (WeiMiCreditShopCell *)[tableView cellForRowAtIndexPath:indexPath];
//    cell.clickBtnOn = !cell.clickBtnOn;
    
//    [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiExchangeVC"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return [self headerTitleWithText:@"新手任务"];
    }else if (section == 1)
    {
        return [self headerTitleWithText:@"日常任务"];
    }
    return nil;
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


@end
