//
//  WeiMiCircleRecommendCell.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCircleRecommendCell.h"
#import "WeiMiCircleMouleCell.h"
#import "WeiMiCommonHeader.h"
#import "WeiMiBaseTableView.h"
#import "UIButton+CenterImageAndTitle.h"

@interface WeiMiCircleRecommendCell()<WeiMiCommonHeaderDelegate,UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *_dataSource;
}

@property (nonatomic, strong) WeiMiCommonHeader *headerView;
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIButton *bottomBtn;

@end

@implementation WeiMiCircleRecommendCell

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

#pragma mark - Setter
- (void)setViewWithDTOs:(NSArray *)dtos;
{
    [_dataSource removeAllObjects];
    [_dataSource addObjectsFromArray:dtos];
    [_tableView reloadData];
}

#pragma mark -Getter
- (WeiMiCommonHeader *)headerView
{
    if (!_headerView) {
        
        _headerView = [[WeiMiCommonHeader alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        _headerView.delegate = self;
        [_headerView setTitle:@"圈子推荐"];
    }
    return _headerView;
}

- (UIButton *)bottomBtn
{
    if (!_bottomBtn) {
        
        _bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bottomBtn.backgroundColor = kWhiteColor;
        _bottomBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        _bottomBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_bottomBtn setTitle:@"更多圈子" forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
        [_bottomBtn setImage:[UIImage imageNamed:@"icon_listmore"] forState:UIControlStateNormal];
        [_bottomBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtn horizontalCenterTitleAndImage];
    }
    return _bottomBtn;
}

- (WeiMiBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        //        _tableView.frame = CGRectMake(0, 0, self.width, self.height);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = self.bottomBtn;
    }
    return _tableView;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)button
{
    OnMoreCircleBtn block = self.onMoreCircleBtn;
    if (block) {
        block();
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
    static NSString *cellID = @"circelMoudleCell";
    WeiMiCircleMouleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[WeiMiCircleMouleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.onCareBtnHandler = self.onCareBtnInCellHandler;
        if(self.hiddenBtn){
            cell.careButton.hidden = YES;
        }
    }
    [cell setViewWithDTO:safeObjectAtIndex(_dataSource, indexPath.row)];
    
    return cell;
}
#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 61;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OnItemHandler handler = self.onItemHandler;
    if (handler) {
        handler(indexPath.row);
    }
//    UPRouterOptions *options = [UPRouterOptions routerOptions];
//    options.hidesBottomBarWhenPushed = YES;
//    [[WeiMiPageSkipManager communityRT] map:@"WeiMiCircleDetailVC/:popWithBaseNavColor" toController:NSClassFromString(@"WeiMiCircleDetailVC") withOptions:options];
//    [[WeiMiPageSkipManager communityRT] open:@"WeiMiCircleDetailVC/yes"];
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
