//
//  WeiMiExchangeResultVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiExchangeResultVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiNotifiEmptyView.h"
#import <UIImageView+WebCache.h>


@interface WeiMiExchangeResultVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    
    NSArray *_imgArr;

}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;

@end

@implementation WeiMiExchangeResultVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@[@"section0", @"section0"],
                        @[@"您的本次兑换已经成功，请进入您的账户查收"],
                        @[@"订单编号：2143141234141414134"]];
        _imgArr = @[@"icon_talk",
                    @"icon_bell",
                    @"icon_news"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    _tableView.tableHeaderView = self.notiView;
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
    self.title = @"兑换结果";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];

}

#pragma mark - Getter
- (WeiMiNotifiEmptyView *)notiView
{
    if (!_notiView) {
        _notiView = [[WeiMiNotifiEmptyView alloc] init];
        _notiView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
        [_notiView setViewWithImg:@"_icon_succeed" title:@"恭喜您兑换成功"];
        _notiView.backgroundColor = kWhiteColor;
    }
    return _notiView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
//        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
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
    return _dataSource.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ((NSArray *)_dataSource[section]).count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = WeiMiSystemFontWithpx(22);
        cell.textLabel.numberOfLines = 0;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
    }
    if (indexPath.section == 0 && indexPath.row == 0) {
//        cell.imageView.image = [UIImage imageNamed:@"weimiQrCode"];
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:_dto.imgURL] placeholderImage:[UIImage imageNamed:@"weimiQrCode"]];
        cell.textLabel.text = _dto.title;
    }else if (indexPath.section == 0 && indexPath.row == 1)
    {
        cell.textLabel.text = [NSString stringWithFormat:@"兑换价格：%@趣币", _dto.vouPrice];
        cell.detailTextLabel.font = WeiMiSystemFontWithpx(22);
        cell.detailTextLabel.text = @"订单状态：成功";
    }
    else if (indexPath.section != 0)
    {
        cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
