//
//  WeiMiCommunityMessageVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommunityMessageVC.h"
#import "WeiMiBaseTableView.h"
#import "UISwitch+CustomColor.h"
#import "WeiMiUtil.h"
#import "WeiMiCommunityMsgSetVC.h"
#import "WeiMiCommunityReplyMeMsgVC.h"
#import "WeiMiCommunitySysNotiVC.h"
#import "OHAlertView.h"

@interface WeiMiCommunityMessageVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_imgArr;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@end

@implementation WeiMiCommunityMessageVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"回复我的",
                        @"系统通知",
                        @"商城客服"];
        _imgArr = @[@"com_msg_icon_huifuwode",
                    @"com_msg_icon_wodehaoyou",
                    @"com_msg_icon_moshengren",
                    @"com_msg_icon_xitongtongzhi",
                    @"com_msg_icon_kefu",];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    
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
    self.title = @"消息";
    self.popWithBaseNavColor = YES;
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
//    [self AddRightBtn:nil normal:@"icon_set_black" selected:@"icon_set_black" action:^{
//        
////        [[WeiMiPageSkipManager communityRouter] skipIntoVC:@"WeiMiCommunityMsgSetVC"];
//        WeiMiCommunityMsgSetVC *vc = [[WeiMiCommunityMsgSetVC alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
    
}

#pragma mark - Getter
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Actions

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
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        cell.imageView.image = [UIImage imageNamed:safeObjectAtIndex(_imgArr, indexPath.row)];
        cell.textLabel.text = safeObjectAtIndex(_dataSource, indexPath.row);
        
    }
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
    
    switch (indexPath.row) {
        case 0:
        {
//            WeiMiCommunityReplyMeMsgVC
//            [[WeiMiPageSkipManager communityRT] open:@"WeiMiCommunityReplyMeMsgVC"];
            
            WeiMiCommunityReplyMeMsgVC *vc = [[WeiMiCommunityReplyMeMsgVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
//        case 3:
//        {
//            [[WeiMiPageSkipManager communityRT] open:@"WeiMiCommunitySysNotiVC"];
//        }
//            break;
        case 1:
        {
//                        [[WeiMiPageSkipManager communityRT] open:@"WeiMiCommunitySysNotiVC"];
            WeiMiCommunitySysNotiVC *vc = [[WeiMiCommunitySysNotiVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
//            [[WeiMiPageSkipManager communityRT] open:@"WeiMiStrangerVC"];
            [OHAlertView showAlertWithTitle:nil message:@"亲, 小二在线时间为9:00~21:00, 是否拨打电话捏？" cancelButton:@"拨打" otherButtons:@[@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    [[Routable sharedRouter] openExternal:@"tel://10086"];
                }
            }];
        }
            break;
        default:
            break;
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
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
}


@end
