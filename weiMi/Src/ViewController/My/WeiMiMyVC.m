//
//  WeiMiMyVC.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/4.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyVC.h"
#import "WeiMiBaseTableView.h"
#import "UIColor+WeiMiUIColor.h"
#import "WeiMiMyHPHeaderCell.h"
#import "WeiMIMyHPItemsCell.h"
#import "WeiMiUserCenter.h"
#import "WeiMiLoginVC.h"
#import "AppDelegate.h"
#import "WeiMiCommunityReplyMeMsgVC.h"
//--------VC
#import "WeiMiCommunityMessageVC.h"
//------- request
#import "WeiMiChangeAvaterRequest.h"


#define TABLE_BG_COLOR      (0xEEEEEE)
#define TEXT_COLOR          (0x302F2F)

@interface WeiMiMyVC()<UITableViewDelegate, UITableViewDataSource, WeiMiMyHPItemsCellDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    /**图片数据源*/
    NSArray *_imgSource;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@end

@implementation WeiMiMyVC

- (instancetype)init
{
    if (self = [super init]) {
        _dataSource = @[
                        @[@"head"],
                        @[@"items"],
                        @[@"积分商城",@"我的礼物",@"我的收藏",@"优惠券"],
                        @[@"我的订单",@"地址管理"],
                        @[@"关于我们",@"关于微信",@"客服中心",@"App推荐"],
                        ];
        
        _imgSource = @[
                       @[@"head"],
                       @[@"items"],
                       @[@"icon_shangcheng",
                         @"icon_liwu",
                         @"mine_icon_shoucang",
                         @"icon_youhuijuang"],
                       @[@"icon_dingdan",
                         @"icon_dizhi"],
                       @[@"icon_guanyu",
                         @"icon_weixin",
                         @"mine_icon_kefu",
                         @"icon_tuijian"],
                       ];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tabBarController.tabBar setHidden:NO];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    
    [self.contentView addSubview:self.tableView];
    
    [self.view setNeedsUpdateConstraints];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)initNavgationItem
{
    self.title = @"我的";
    
    [self AddLeftBtn:nil normal:@"icon_message" selected:@"icon_message'" action:^{
//        UPRouterOptions *options = [UPRouterOptions routerOptions];
//        options.hidesBottomBarWhenPushed = YES;
//        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMessageVC" options:options];
        
        WeiMiCommunityMessageVC *vc = [[WeiMiCommunityMessageVC alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    

    [self AddRightBtn:nil normal:@"icon_set" selected:@"icon_set" action:^{
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiSettingVC" options:options];
    
    }];
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(TABLE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - WeiMiMyHPItemsCellDelegate
- (void)cell:(WeiMiMyHPItemsCell *)cell didSelectedAtIndex:(NSInteger)index
{
    
    if (![[WeiMiUserCenter sharedInstance] isLogin]) {//未登录
        [WeiMiPageSkipManager skipIntoLoginVC:self];
        return;
    }
    if (index == 0) {//我的等级
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMyLevelVC" options:options];
    }
    else if (index == 2) {//我的积分
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMyCreditVC" options:options];
    }else if (index == 1)//我的帖子
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMyPostsVC" options:options];
    }
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
    
    if (indexPath.section == 0) {
        WS(weakSelf);
        static NSString *cellID = @"headerCell";
        WeiMiMyHPHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiMyHPHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.onClickButtonHandler = ^(HEADERBUTTONTYPE type){
                SS(strongSelf);
                switch (type) {
                    case HEADERBUTTONTYPE_LOGIN:
                    {
//                        [self.navigationController hidesBottomBarWhenPushed];
//                        [self.APP.mineRouter open:@"WeiMiLogInVC"];
//                        [WeiMiPageSkipManager presentIntoLoginVC:strongSelf completion:nil];
                        [WeiMiPageSkipManager skipIntoLoginVC:strongSelf];
                    }
                        break;
                    case HEADERBUTTONTYPE_REGISTER:
                    {
                        [self.APP.mineRouter open:@"WeiMiRegisterVC"];
                    }
                        break;
                        
                    default:
                        break;
                }
            };
        }
        
        cell.isLogin = [WeiMiUserCenter sharedInstance].isLogin;
        
        if (cell.isLogin) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        [cell setViewWithDTO:[WeiMiUserCenter sharedInstance].userInfoDTO];
        return cell;
    }else if (indexPath.section == 1)
    {
        static NSString *cellID = @"itemCell";
        WeiMiMyHPItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[WeiMiMyHPItemsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.delegate = self;

        }
        [cell setNeedsLayout];
        [cell layoutIfNeeded];
        return cell;
    }
    else
    {
        static NSString *cellID = @"commomCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            cell.textLabel.textColor = HEX_RGB(TEXT_COLOR);
            
            if(indexPath.section == 2 && indexPath.row == 1) {//我的礼物
                UILabel *rightTitleLB = [[UILabel alloc] init];
                rightTitleLB.tag = 10*indexPath.section + indexPath.row;
                rightTitleLB.textAlignment = NSTextAlignmentLeft;
                rightTitleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
                rightTitleLB.textColor = kRedColor;
                rightTitleLB.text = @"敬请期待";
                [cell.contentView addSubview:rightTitleLB];
                
                
                [rightTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.mas_equalTo(-10);
                    make.centerY.mas_equalTo(cell);
                }];
            }
        }

        cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
        cell.imageView.image = [UIImage imageNamed:_imgSource[indexPath.section][indexPath.row]];
        return cell;
    }

    return nil;
}
#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 97;
    }else if (indexPath.section == 1)
    {
        return 132/2;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (![[WeiMiUserCenter sharedInstance] isLogin] && indexPath.section != 4) {//未登录
        [WeiMiPageSkipManager skipIntoLoginVC:self];
        return;
    }
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        if ([WeiMiUserCenter sharedInstance].isLogin) {
            [WeiMiPageSkipManager skipIntoPersonalInfoVC:self];
        }
   
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
//        [WeiMiPageSkipManager skipIntoCreditShoppingVC:self];
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiCreditShopVC" options:options];
    }else if (indexPath.section == 2 && indexPath.row == 1)
    {
//        [WeiMiPageSkipManager skipIntoMyGiftVC:self];
//        UPRouterOptions *options = [UPRouterOptions routerOptions];
//        options.hidesBottomBarWhenPushed = YES;
//        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMyGiftVC" options:options];
    }else if (indexPath.section == 2 && indexPath.row == 2)
    {
//        [WeiMiPageSkipManager skipIntoMyCollectionVC:self];
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMyCollectionVC" options:options];
        
    }else if (indexPath.section == 2 && indexPath.row == 3)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiPrivilegeVC" options:options];

    }else if (indexPath.section == 3 && indexPath.row == 0)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMyOrderVC" options:options];
    }else if (indexPath.section == 3 && indexPath.row == 1)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiRecAddressVC" options:options];
    }else if (indexPath.section == 4 && indexPath.row == 0)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiAboutUSVC" options:options];
    }else if (indexPath.section == 4 && indexPath.row == 1)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiCareUSVC" options:options];
    }
    else if (indexPath.section == 4 && indexPath.row == 2)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiServiceCenterVC" options:options];
    }else if (indexPath.section == 4 && indexPath.row == 3)
    {
        UPRouterOptions *options = [UPRouterOptions routerOptions];
        options.hidesBottomBarWhenPushed = YES;
        [[WeiMiPageSkipManager mineRouter] intoVC:@"WeiMiMyGiftVC" options:options];
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

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}


@end
