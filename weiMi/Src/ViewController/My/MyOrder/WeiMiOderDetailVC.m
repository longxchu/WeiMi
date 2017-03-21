//
//  WeiMiOderDetail.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/8.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOderDetailVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiOrderDetailHeaderView.h"
#import "WeiMiOrderGoodInfoCell.h"
#import "WeiMiOrderTransportInfoCell.h"
#import "UIButton+CenterImageAndTitle.h"
#import "WeiMiOrderInfoCell.h"
#import <OHAlertView.h>

typedef NS_ENUM(NSInteger, ORDERSTATUS)
{
    ORDERSTATUS_SUCCESS,//交易成功
    ORDERSTATUS_WAITREC,//待收货
};

@interface WeiMiOderDetailVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_imgArr;
    ORDERSTATUS _orderStatus;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiOrderDetailHeaderView *headerView;
@property (nonatomic, strong) UIButton *contactServiceBTN;
@property (nonatomic, strong) UIButton *commentBTN;
@property (nonatomic, strong) UIButton *aftermarketBTN;
@property (nonatomic, strong) UIView *bottomBgView;

@end


@implementation WeiMiOderDetailVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dataSource = @[@"北京市正常签收,感谢使用水电费水电费是粉色发大厦大是大非",
                        @"收货人：袁杰姐"];
        _imgArr = @[@"icon_car",
                    @"icon_map"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    NSInteger _tradeStatus = EncodeNumberFromDic(self.params, @"trade").integerValue;
    if (_tradeStatus == 0) {

    }else if (_tradeStatus == 1)//交易成功
    {
        _orderStatus = ORDERSTATUS_SUCCESS;
    }else if (_tradeStatus == 2)
    {
        _orderStatus = ORDERSTATUS_WAITREC;
    }
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    _tableView.frame = self.contentFrame;
    _tableView.tableHeaderView = self.headerView;
    
    [self.contentView addSubview:self.bottomBgView];
    [self.bottomBgView addSubview:self.commentBTN];
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
    self.title = @"订单详情";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        if (_saveName) {
        //            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiModifyNameVC" params:@[_name]];
        //        }
        [strongSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (UIButton *)commentBTN
{
    if (!_commentBTN) {
        _commentBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentBTN.titleLabel.font = WeiMiSystemFontWithpx(20);
        [_commentBTN sizeToFit];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        if (_orderStatus == ORDERSTATUS_SUCCESS) {
            [_commentBTN setTitle:@"评价" forState:UIControlStateNormal];

        }else if (_orderStatus == ORDERSTATUS_WAITREC)
        {
            [_commentBTN setTitle:@"查看物流" forState:UIControlStateNormal];
        }
        [_commentBTN setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        [_commentBTN setBackgroundImage:[UIImage imageNamed:@"purple_border_btn"] forState:UIControlStateNormal];
        [_commentBTN setBackgroundImage:[UIImage imageNamed:@"purple_border_btn"] forState:UIControlStateSelected];
        [_commentBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentBTN;
}

- (UIView *)bottomBgView
{
    if (!_bottomBgView) {
        _bottomBgView  = [[UIView alloc] init];
        _bottomBgView.backgroundColor = kWhiteColor;
    }
    return _bottomBgView;
}

- (UIButton *)contactServiceBTN
{
    if (!_contactServiceBTN) {
        _contactServiceBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        _contactServiceBTN.userInteractionEnabled = NO;
        [_contactServiceBTN setTitle:@"联系客服" forState:UIControlStateNormal];
        [_contactServiceBTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _contactServiceBTN.titleLabel.font = WeiMiSystemFontWithpx(20);
        [_contactServiceBTN setImage:[UIImage imageNamed:@"icon_phone"] forState:UIControlStateNormal];
        [_contactServiceBTN setImage:[UIImage imageNamed:@"icon_phone"] forState:UIControlStateHighlighted];
    }
    return _contactServiceBTN;
    
}

- (UIButton *)aftermarketBTN
{
    if (!_aftermarketBTN) {
        _aftermarketBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        if (_orderStatus == ORDERSTATUS_WAITREC) {
            [_aftermarketBTN setTitle:@"退款" forState:UIControlStateNormal];
        }else if (_orderStatus == ORDERSTATUS_SUCCESS)
        {
//            [_aftermarketBTN setTitle:@"申请售后" forState:UIControlStateNormal];
        }
        [_aftermarketBTN sizeToFit];
        [_aftermarketBTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
        _aftermarketBTN.titleLabel.font = WeiMiSystemFontWithpx(20);
        //[_aftermarketBTN setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateNormal];
        //[_aftermarketBTN setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateHighlighted];
        [_aftermarketBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _aftermarketBTN;
    
}

- (WeiMiOrderDetailHeaderView *)headerView
{
    if (!_headerView) {
        
        _headerView = [[WeiMiOrderDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
        if (_orderStatus == ORDERSTATUS_SUCCESS) {
            [_headerView setTitle:@"交易成功"];
        }else if(_orderStatus == ORDERSTATUS_WAITREC)
        {
            [_headerView setTitle:@"卖家已发货\n还剩5天14时自动确认"];
            [_headerView setBGImage:@"orderBanner"];
        }
    }
    return _headerView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
    }
    return _tableView;
}

#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == _commentBTN) {
        if (_orderStatus == ORDERSTATUS_SUCCESS) {
            [[WeiMiPageSkipManager mineRT] open:@"WeMiCommentOrderVC"];

        }else if (_orderStatus == ORDERSTATUS_WAITREC)
        {
            [[WeiMiPageSkipManager mineRT] open:@"WeiMiLogisticsDetailVC"];
        }
    }else if (sender == _aftermarketBTN)
    {
        if (_orderStatus == ORDERSTATUS_WAITREC)//等待收货
        {
            [[WeiMiPageSkipManager mineRT] open:@"WeiMiRefundVC"];//退款
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_orderStatus == ORDERSTATUS_SUCCESS) {
        return 2;
    }else if (_orderStatus == ORDERSTATUS_WAITREC)
    {
        return 3;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (_orderStatus == ORDERSTATUS_SUCCESS) {
            return 2;
        }else if (_orderStatus == ORDERSTATUS_WAITREC)
        {
            return 1;
        }
    }else if (section == 1)
    {
        return 3;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        
        static NSString *cellID = @"cell_0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.detailTextLabel.numberOfLines = 0;
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = WeiMiSystemFontWithpx(22);
            if (indexPath.section == 0 && indexPath.row == 0) {
                if (_orderStatus == ORDERSTATUS_SUCCESS) {
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    cell.textLabel.textColor = HEX_RGB(0x268E1E);
                    cell.detailTextLabel.font = WeiMiSystemFontWithpx(20);
                    cell.detailTextLabel.textColor = kGrayColor;
                }else if (_orderStatus == ORDERSTATUS_WAITREC)
                {
                    cell.textLabel.font = WeiMiSystemFontWithpx(22);
                    cell.detailTextLabel.font = WeiMiSystemFontWithpx(22);
                }
                
            }else if (indexPath.section == 0 && indexPath.row == 1)
            {
                cell.detailTextLabel.font = WeiMiSystemFontWithpx(22);

            }
            
        }
        if (indexPath.section == 0) {
            
            if (_orderStatus == ORDERSTATUS_SUCCESS) {
                
                cell.imageView.image = [UIImage imageNamed:safeObjectAtIndex(_imgArr, indexPath.row)];
                cell.textLabel.text = safeObjectAtIndex(_dataSource, indexPath.row);
                if (indexPath.row == 0) {
                    cell.detailTextLabel.text = @"2016-06-03 09:44:13";
                }else
                {
                    cell.detailTextLabel.text = @"收货地址：blablababababa";
                }
            }else if (_orderStatus == ORDERSTATUS_WAITREC)
            {
                cell.imageView.image = [UIImage imageNamed:safeObjectAtIndex(_imgArr, 1)];
                cell.textLabel.text = safeObjectAtIndex(_dataSource, 1);
                cell.detailTextLabel.text = @"收货地址：blablababababa";
            }

        }
        
        return cell;

    }else if (indexPath.section == 1 && indexPath.row == 0)
    {
        static NSString *cellID = @"cell_1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            
            UIView *bgView = [[UIView alloc] init];
            bgView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
            [cell.contentView addSubview:bgView];
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(40);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(120);
            }];
            
            WeiMiOrderGoodInfoCell *subCell = [[WeiMiOrderGoodInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WeiMiOrderGoodInfoCell"];
            [bgView addSubview:subCell];
            [subCell mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.mas_equalTo(0);
                make.left.right.mas_equalTo(0);
                make.height.mas_equalTo(80);
            }];
            
            
            [bgView addSubview:self.aftermarketBTN];
            [_aftermarketBTN mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.bottom.right.mas_equalTo(-10);
                make.height.mas_equalTo(25);
            }];
        }
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 1)
    {
        static NSString *cellID = @"WeiMiOrderTransportInfoCell";
        WeiMiOrderTransportInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiOrderTransportInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0)//订单信息
    {
        static NSString *cellID = @"WeiMiOrderTransportInfoCell";
        WeiMiOrderInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiOrderInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        return cell;
    }
    //联系客服
    static NSString *cellID = @"common_cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        
        if (indexPath.section == 1 && indexPath.row == 2) {
            [cell.contentView addSubview:self.contactServiceBTN];
            [_contactServiceBTN mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(cell);
            }];
        }
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        return 160;
    }
    else if (indexPath.section == 1 && indexPath.row == 1)
    {
        return 68;
    }
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        return 45;
    }else if (indexPath.section == 0)
    {
        return 70;
    }
    return 125;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1 && indexPath.row == 2) {
        [OHAlertView showAlertWithTitle:nil message:@"亲, 小二在线时间为9:00~21:00, 是否拨打电话捏？" cancelButton:@"拨打" otherButtons:@[@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[Routable sharedRouter] openExternal:@"tel://10086"];
            }
        }];
    }
    if (_orderStatus == ORDERSTATUS_SUCCESS && indexPath.section == 0 && indexPath.section == 0)
    {
        [[WeiMiPageSkipManager mineRT] open:@"WeiMiLogisticsDetailVC"];
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
    [_contactServiceBTN horizontalCenterTitleAndImageLeft];
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + NAV_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_bottomBgView.mas_top);
    }];
    
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(GetAdapterHeight(50));
    }];
    
    [_commentBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_bottomBgView);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(_bottomBgView).multipliedBy(0.6);
    }];
}


@end
