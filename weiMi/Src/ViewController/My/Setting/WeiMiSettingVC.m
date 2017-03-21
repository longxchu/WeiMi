//
//  WeiMiSettingVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSettingVC.h"
#import "WeiMiBaseTableView.h"
#import "UINavigationController+StatuBarStyle.h"
#import "UISwitch+CustomColor.h"
#import "WeiMiSystemInfo.h"
#import "WeiMiMessageSetting.h"
#import "WeiMiUserCenter.h"
#import "WeiMiBaseRequest.h"
@interface WeiMiSettingVC()<UITableViewDelegate, UITableViewDataSource>
{
    /**数据源*/
    NSMutableArray *_titleArr;
    /**是否登录*/
    BOOL _isLogin;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UILabel *notiLabel;
@property (nonatomic, strong) UIButton *logoutBtn;
@property (nonatomic, strong) UISwitch * cellSwitch;

@end

@implementation WeiMiSettingVC


- (instancetype)init
{
    self = [super init];
    if (self) {
        _isLogin = YES;
        _titleArr = [NSMutableArray arrayWithArray:@[
//                                                     @[@"新消息设置"],
                                                     @[@"3G/4G浏览高清图片"],
                                                     @[@"清空缓存"],
                                                     @[@"给应用评分"],
                                                     @[@""],
                                                     ]];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    if (![WeiMiUserCenter sharedInstance].isLogin) {
        
        [_titleArr removeLastObject];
    }
    [self.view setNeedsUpdateConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.popWithBaseNavColor = YES;
    self.title = @"通用设置";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UISwitch *)cellSwitch
{
    if (!_cellSwitch) {
        _cellSwitch = [UISwitch defaultSwitch];
        [_cellSwitch addTarget:self action:@selector(onSwitcher:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cellSwitch;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
//        [_tableView setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

- (UIButton *)logoutBtn
{
    if (!_logoutBtn) {
        
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutBtn.frame = CGRectMake(0, 0, self.view.width, 50);
        [_logoutBtn setTitle:@"退出当前账号" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:kRedColor forState:UIControlStateNormal];
        _logoutBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(21)];
        _logoutBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [_logoutBtn addTarget:self action:@selector(onLogoutBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _logoutBtn;
}

- (UILabel *)notiLabel
{
    if (!_notiLabel) {
        
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.font = [UIFont fontWithName:@"Arial" size:13];
        _notiLabel.textAlignment = NSTextAlignmentLeft;
        _notiLabel.textColor = kGrayColor;
        _notiLabel.text = @"    开启此功能将会耗费更多流量哦~";
    }
    return _notiLabel;
}

#pragma mark - Actions
- (void)onSwitcher:(UISwitch *)switcher
{
    if (!switcher.on) {
        [self presentSheet:@"关闭高清浏览"];
        return;
    }
    [self presentSheet:@"开启高清浏览"];
}

- (void)onLogoutBtn
{
    [self presentSheet:@"退出登录成功"];
    [[WeiMiUserCenter sharedInstance] clearUserInfo];
    _isLogin = NO;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (!_isLogin) {
        return _titleArr.count - 1;
    }
    return _titleArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_titleArr[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        if (indexPath.section == 2) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(21)];
        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        
        if (indexPath.section == 3) {
            [cell.contentView addSubview:self.logoutBtn];
        }else if (indexPath.section == 0)
        {
            [cell.contentView addSubview:self.cellSwitch];
            [_cellSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-20);
            }];
        }
    }

    if (indexPath.section == 4) {
        return cell;
    }
    cell.textLabel.text = _titleArr[indexPath.section][indexPath.row];
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 38;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 - 1) {
        
        if (IOS8_OR_LATER) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            
            WS(weakSelf);
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定清空" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[[WeiMiBaseRequest alloc] init] clearAllCache];
                [weakSelf presentSheet:@"清空成功"];
            }];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action];
            [alert addAction:cancel];
            
            [self presentViewController:alert animated:YES completion:nil];
        }
        else
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认清空", nil];
            [alertView show];
        }
    }else if (indexPath.section == 0)
    {
        [WeiMiPageSkipManager skipIntoMessageSettingVC:self];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return self.notiLabel;
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
