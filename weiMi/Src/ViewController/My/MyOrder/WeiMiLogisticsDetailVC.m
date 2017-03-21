//
//  WeiMiLogisticsDetailVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLogisticsDetailVC.h"
#import "WeiMiBaseTableView.h"
#import "UILabel+NotiLabel.h"
#import "WeiMiBaseView.h"
#import "WeiMiLogisticsInfoCell.h"
#import "WeiMiLogisticsStatusCell.h"

@interface WeiMiLogisticsDetailVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    
    NSString *_title;
    NSString *_date;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) WeiMiBaseView *headerBGView;
@property (nonatomic, strong) UILabel *notiLabel;

@end

@implementation WeiMiLogisticsDetailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"在线客服",
                        @"系统通知",
                        @"我的消息"];
        _title = @"派送中：货物已经由上海市发往北京.";
        _date = @"2016年9月20日";
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
    self.title = @"物流详情";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        [strongSelf BackToLastNavi];
    }];
    
}

#pragma mark - Getter
- (WeiMiBaseView *)headerBGView
{
    if (!_headerBGView) {
        _headerBGView = [[WeiMiBaseView alloc] init];
        _headerBGView.backgroundColor = kWhiteColor;
        [_headerBGView addSubview:self.notiLabel];
    }
    return _headerBGView;
}

- (UILabel *)notiLabel
{
    if (!_notiLabel) {
        _notiLabel = [UILabel defaultNotiLabelWithTitle:@"物流跟踪"];
        _notiLabel.frame = CGRectMake(10, 0, SCREEN_WIDTH, 45);
        _notiLabel.backgroundColor = kWhiteColor;
        _notiLabel.font = WeiMiSystemFontWithpx(22);
        _notiLabel.textAlignment = NSTextAlignmentLeft;
        _notiLabel.textColor = kBlackColor;
    }
    return _notiLabel;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView groupTableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Util
- (NSMutableAttributedString *)getPhoneAttr:(NSString *)tel
{
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"手机: " attributes:@{
                                                                    NSFontAttributeName:WeiMiSystemFontWithpx(20)}];
    NSMutableAttributedString *suffStr = [[NSMutableAttributedString alloc] initWithString:tel attributes:@{
                                                            NSFontAttributeName:WeiMiSystemFontWithpx(20),
                                                NSForegroundColorAttributeName:HEX_RGB(0x3A9CC),
                                                            NSStrokeColorAttributeName:HEX_RGB(0x3A9CC),
                                            NSUnderlineStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                                                                                }];
    [attStr appendAttributedString:suffStr];
    return attStr;
}

#pragma mark - Actions

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _dataSource.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {//快递员信息
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
            cell.detailTextLabel.numberOfLines = 0;
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
        }
        
        if (indexPath.section == 0) {
            cell.textLabel.text = @"派件员:贾贝贝";
            cell.detailTextLabel.attributedText = [self getPhoneAttr:@"13055424951"];
            cell.imageView.image = [UIImage imageNamed:@"icon_qq"];
        }else if (indexPath.section == 1)
        {
            cell.textLabel.text = @"物流状态:已签收";
            cell.detailTextLabel.text = @"运单号:222222222222\n信息来源:中通物流";
            cell.imageView.image = [UIImage imageNamed:@"icon_qq"];
        }
        return cell;
    }else if (indexPath.section == 1)//物流信息
    {
        static NSString *cellID = @"WeiMiLogisticsInfoCell";
        WeiMiLogisticsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (!cell) {
            cell = [[WeiMiLogisticsInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            [cell setNeedsUpdateConstraints];
            [cell updateFocusIfNeeded];
        }
        return cell;
    }
    
    NSString *cellID = [NSString stringWithFormat:@"WeiMiLogisticsStatusCell_%ld_%ld", (long)indexPath.section, (long)indexPath.row];
    WeiMiLogisticsStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        
        if (_dataSource.count == 1) {
            cell = [[WeiMiLogisticsStatusCell alloc]initWithStatus:YinzhiDirectoryCellStatus_single reuseIdentifier:cellID];
        }else
        {
            if (indexPath.row == 0) {
                cell = [[WeiMiLogisticsStatusCell alloc]initWithStatus:YinzhiDirectoryCellStatus_upper reuseIdentifier:cellID];
            }else if (indexPath.row == _dataSource.count - 1)
            {
                cell = [[WeiMiLogisticsStatusCell alloc]initWithStatus:YinzhiDirectoryCellStatus_bottom reuseIdentifier:cellID];
            }else
            {
                cell = [[WeiMiLogisticsStatusCell alloc]initWithStatus:YinzhiDirectoryCellStatus_mid reuseIdentifier:cellID];
            }
        }
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setViewWithTitle:_title date:_date];
    return cell;
    
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 190/2;
    }else if (indexPath.section == 1)
    {
        return 208/2;
    }
    return [WeiMiLogisticsStatusCell getHeightWithTitle:_title date:_date];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 45;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return self.headerBGView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 38, 0, 0)];
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
