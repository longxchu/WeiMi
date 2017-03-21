//
//  WeiMiCommunitySysNotiVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommunitySysNotiVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiNotifiEmptyView.h"
#import <OHActionSheet.h>
#import "UILabel+NotiLabel.h"
#import "WeiMiSysNotiCell.h"
#import "WeiMiAdviceVC.h"
@interface WeiMiCommunitySysNotiVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiEmptyView;

@property (nonatomic, strong) UIButton *leftBTN;
@property (nonatomic, strong) UIButton *rightBTN;

@end

@implementation WeiMiCommunitySysNotiVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"在线客服",
                        @"系统通知",
                        @"我的消息"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = HEX_RGB(0xEAEAEA);

    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    
    [self.contentView addSubview:self.notiEmptyView];
    self.notiEmptyView.hidden = YES;
    
//    [self.contentView addSubview:self.leftBTN];
    [self.contentView addSubview:self.rightBTN];
    
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
    self.title = @"系统通知";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
    [self AddRightBtn:nil normal:@"icon_more_black" selected:nil action:^{
        
        SS(strongSelf);

        [OHActionSheet showFromView:self.view title:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"清空聊天记录",@"拨打客服热线"] completion:^(OHActionSheet *sheet, NSInteger buttonIndex) {
            
            switch (buttonIndex) {
                case 1:
                {
                    [[Routable sharedRouter] openExternal:@"tel://10086"];
                }
                    break;
                case 0:
                {
                    [strongSelf presentSheet:@"清空成功"];
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
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (WeiMiNotifiEmptyView *)notiEmptyView
{
    if (!_notiEmptyView) {
        _notiEmptyView = [[WeiMiNotifiEmptyView alloc] init];
        [_notiEmptyView setViewWithImg:@"com_sysNoti_icon_massage" title:@"亲，你还没有收到系统通知哦"];
    };
    return _notiEmptyView;
}

//- (UIButton *)leftBTN
//{
//    if (!_leftBTN) {
//        _leftBTN = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_leftBTN setTitle:@"帮助中心" forState:UIControlStateNormal];
//        [_leftBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
//        _leftBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
//        _leftBTN.backgroundColor = kWhiteColor;
//        [_leftBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _leftBTN;
//}

- (UIButton *)rightBTN
{
    if (!_rightBTN) {
        _rightBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBTN setTitle:@"意见反馈" forState:UIControlStateNormal];
        [_rightBTN setTitleColor:kBlackColor forState:UIControlStateNormal];
        _rightBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _rightBTN.backgroundColor = kWhiteColor;
        [_rightBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBTN;
}


#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (_rightBTN == sender) {
        WeiMiAdviceVC *vc = [[WeiMiAdviceVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    WeiMiSysNotiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiSysNotiCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 42.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerViewId = @"headerViewId";
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerViewId];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:headerViewId];
        headerView.backgroundColor = kGreenColor;

        UILabel *label = [UILabel footerNotiLabelWithTitle:@"2016-09-09" textAlignment:NSTextAlignmentCenter];
        label.backgroundColor = [UIColor clearColor];
        label.font = WeiMiSystemFontWithpx(20);
        [headerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(headerView).insets(UIEdgeInsetsMake(10, 0, 0, 0));
        }];
    }
    return headerView;
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
        make.left.mas_equalTo(self.view).offset(10);
        make.right.mas_equalTo(self.view).offset(-10);
        make.height.mas_equalTo(GetAdapterHeight(200));
    }];
    
//    [_rightBTN] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:1.0f leadSpacing:0 tailSpacing:0];
    [_rightBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_tableView.mas_bottom).offset(1);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [super updateViewConstraints];
}

@end
