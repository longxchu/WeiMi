//
//  WeiMiCommunityMsgSetVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommunityMsgSetVC.h"
#import "WeiMiBaseTableView.h"
#import "UISwitch+CustomColor.h"
#import "WeiMiUtil.h"

@interface WeiMiCommunityMsgSetVC()<UITableViewDelegate, UITableViewDataSource>
{
    /**数据源*/
    NSArray *_titleArr;
}
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UILabel *notiOpenLabel;

@end

@implementation WeiMiCommunityMsgSetVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _titleArr = @[
                      @[@"帖子被回复", @"回帖被回复", @"评论被回复"],
                      @[@"陌生人打招呼通知"],
                      @[@"私信黑名单"],
                      ];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"消息设置";
    WS(weakSelf);
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Getter
- (UILabel *)notiOpenLabel
{
    if (!_notiOpenLabel) {
        _notiOpenLabel = [[UILabel alloc] init];
        _notiOpenLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _notiOpenLabel.textColor = kGrayColor;
        _notiOpenLabel.text = @"未开启";
    }
    return _notiOpenLabel;
}

- (UISwitch *)cellSwitch
{
    UISwitch *__cellSwitch = [UISwitch defaultSwitch];
    [__cellSwitch addTarget:self action:@selector(onSwitcher:) forControlEvents:UIControlEventTouchUpInside];
    return __cellSwitch;
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

- (UILabel *)notiLabelWithText:(NSString *)text
{
    UILabel * __notiLabel = [[UILabel alloc] init];
    __notiLabel.font = [UIFont fontWithName:@"Arial" size:13];
    __notiLabel.textAlignment = NSTextAlignmentLeft;
    __notiLabel.textColor = kGrayColor;
    //    __notiLabel.text = @"如果您要关闭或开启新消息通知,请在iphone的”设置“-”通知“中,找到”“唯蜜 进行更改";
    __notiLabel.numberOfLines = 2;
    //设置缩进
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 20;
    style.headIndent = 20;//左缩进
    style.tailIndent = -20;//右缩进
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,text.length)];
    __notiLabel.attributedText = attrStr;
    return __notiLabel;
}

#pragma mark - Actions
- (void)onSwitcher:(UISwitch *)switcher
{
    //    (indexPath.section + 1) * 8888 + indexPath.row
    NSUInteger tag = switcher.tag;
    if (!switcher.on) {
        if (tag == 8888 + 0) {
            [self presentSheet:@"帖子被回复 关"];
        }else if (tag == 8888 + 1)
        {
            [self presentSheet:@"回帖被回复 关"];
            
        }else if (tag == 8888 + 2)
        {
            [self presentSheet:@"评论被回复 关"];
            
        }else if (tag == 2*8888 + 0)
        {
            [self presentSheet:@"陌生人打招呼 关"];
            
        }else if (tag == 3*8888 + 0)
        {
            [self presentSheet:@"免时段打扰 关"];
            
        }
        return;
    }
    
    if (tag == 8888 + 0) {
        [self presentSheet:@"帖子被回复 开"];
    }else if (tag == 8888 + 1)
    {
        [self presentSheet:@"回帖被回复 开"];
        
    }else if (tag == 8888 + 2)
    {
        [self presentSheet:@"评论被回复 开"];
        
    }else if (tag == 2*8888 + 0)
    {
        [self presentSheet:@"陌生人打招呼 开"];
        
    }else if (tag == 3*8888 + 0)
    {
        [self presentSheet:@"免时段打扰 开"];
        
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
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
        
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        
        
        if (indexPath.section == 3) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if (indexPath.section != 2) {
            UISwitch *switcher = [UISwitch defaultSwitch];
            switcher.tag = (indexPath.section + 1) * 8888 + indexPath.row;
            [cell.contentView addSubview:switcher];
            [switcher addTarget:self action:@selector(onSwitcher:) forControlEvents:UIControlEventTouchUpInside];
            [switcher mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-20);
            }];
        }
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == _titleArr.count -1) {
        
        [[WeiMiPageSkipManager communityRouter] skipIntoVC:@"WeiMiCommunityBlackListVC"];
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
