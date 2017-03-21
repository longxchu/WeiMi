//
//  WeiMiHotRecommendCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHotRecommendCell.h"
#import "WeiMiHotMoudleCell.h"
#import "WeiMiCommonHeader.h"
#import "WeiMiBaseTableView.h"

//------ vc


@interface WeiMiHotRecommendCell()<WeiMiCommonHeaderDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong) WeiMiCommonHeader *headerView;
@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@end
@implementation WeiMiHotRecommendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _dataSource = [[NSMutableArray alloc] init];
        [self.contentView addSubview:self.tableView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (WeiMiCommonHeader *)headerView
{
    if (!_headerView) {
        
        _headerView = [[WeiMiCommonHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (WeiMiBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
//        _tableView.frame = CGRectMake(0, 0, self.width, self.height);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (void)setViewWithDTOs:(NSArray *)dtos
{
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:dtos];
    [_tableView reloadData];
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
    static NSString *cellID = @"hotMouduleCell";
    WeiMiHotMoudleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiHotMoudleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    
    return cell;
}
#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
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
    
//    UPRouterOptions *options = [UPRouterOptions routerOptions];
//    options.hidesBottomBarWhenPushed = YES;
//    [[WeiMiPageSkipManager communityRT] map:@"WeiMiInvitationVC" toController:NSClassFromString(@"WeiMiInvitationVC") withOptions:options];
//    [[WeiMiPageSkipManager communityRT] open:@"WeiMiInvitationVC"];
    OnClickedItemBtn block = self.onClickedItemBtn;
    if (block) {
        block();
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

#pragma mark - WeiMiCommonHeader
- (void)didSelectedBtn
{
    OnClickedChangeBtn block = self.onClickedChangeBtn;
    if (block) {
        block();
    }
}

#pragma mark - Constraints
- (void)updateConstraints
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    [super updateConstraints];
}


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