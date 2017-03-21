//
//  WeiMiOrderUnpayVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/15.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiOrderUnpayVC.h"
#import "WeiMiBaseTableView.h"
#import "UILabel+NotiLabel.h"
#import "UIButton+CenterImageAndTitle.h"
#import "WeiMiBillInfoCell.h"
#import "WeiMiGoodsAllPriceCell.h"
#import <OHAlertView.h>
#import <NSMutableAttributedString+OHAdditions.h>
#import "WeiMiOrderUnPayGoodsCell.h"


#define kBottomViewColor   (0xF8F8F8)

@interface WeiMiOrderUnpayVC()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_imgArr;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiBaseView *bottomView;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *deadLineLB;

@end


@implementation WeiMiOrderUnpayVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"section1",
                        @"section2",
                        @"section3"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.leftBtn];
    [self.bottomView addSubview:self.rightBtn];
    [self.bottomView addSubview:self.deadLineLB];

//    _tableView.frame = self.contentFrame;
    
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
- (UILabel *)deadLineLB
{
    if (!_deadLineLB) {
        
        _deadLineLB = [[UILabel alloc] init];
        _deadLineLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _deadLineLB.textAlignment = NSTextAlignmentLeft;
        _deadLineLB.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _deadLineLB.numberOfLines = 2;
        _deadLineLB.attributedText = [self attrStrWithHour:@"23" minute:@"54"];
        [_deadLineLB sizeToFit];
    }
    return _deadLineLB;
}

- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [_leftBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        //        [_leftBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"purple_border_btn"] forState:UIControlStateNormal];
        //        [_leftBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateSelected];
        [_leftBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitle:@"付款" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        //        [_rightBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"purple_border_btn"] forState:UIControlStateNormal];
        //        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"gray_btn"] forState:UIControlStateSelected];
        [_rightBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (WeiMiBaseView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[WeiMiBaseView alloc] init];
        _bottomView.backgroundColor = HEX_RGB(kBottomViewColor);
    }
    return _bottomView;
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

#pragma mark - utils
- (NSMutableAttributedString *)attrStrWithActualPay:(CGFloat)actualPay orderTime:(NSString *)orderTime
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"实付款: " attributes:@{
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(22)],
                                        NSForegroundColorAttributeName:kBlackColor}];
    NSAttributedString *sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%.2f\n", actualPay] attributes:@{
                                    NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(25)], NSForegroundColorAttributeName:kRedColor}];
    [attString appendAttributedString:sufStr];
    
    sufStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"下单时间: %@", orderTime] attributes:@{
                                        NSFontAttributeName:[UIFont systemFontOfSize:kFontSizeWithpx(20)]}];
    [attString appendAttributedString:sufStr];

    return attString;
}

- (NSMutableAttributedString *)attrStrWithHour:(NSString *)hour minute:(NSString *)minute
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"付款剩余时间\n" attributes:@{
                                NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(20)],
                    NSForegroundColorAttributeName:kGrayColor}];
    NSMutableAttributedString *sufStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@小时", hour] attributes:@{
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(20)], NSForegroundColorAttributeName:kGrayColor}];
    [sufStr setFont:WeiMiSystemFontWithpx(25) range:NSMakeRange(0, hour.length)];
    [sufStr setTextColor:kBlackColor range:NSMakeRange(0, hour.length)];
    [attString appendAttributedString:sufStr];
    
    sufStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@分钟", minute] attributes:@{
                                        NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(20)],
                                                          NSForegroundColorAttributeName:kGrayColor}];
    [sufStr setAttributes:@{ NSFontAttributeName:WeiMiSystemFontWithpx(25),
                            NSForegroundColorAttributeName:kBlackColor} range:NSMakeRange(0, minute.length)];
//    [sufStr addAttribute:NSFontAttributeName value:[NSNumber numberWithFloat:kFontSizeWithpx(25)] range:NSMakeRange(0, minute.length)];
//    [sufStr addAttribute:NSForegroundColorAttributeName value:kBlackColor range:NSMakeRange(0, minute.length)];
    [attString appendAttributedString:sufStr];
    
    return attString;
}
#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    if (sender.tag == 6666*2 + 7777*(_dataSource.count + 2)) {
        [OHAlertView showAlertWithTitle:nil message:@"亲, 小二在线时间为9:00~21:00, 是否拨打电话捏？" cancelButton:@"拨打" otherButtons:@[@"取消"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            if (buttonIndex == 0) {
                [[Routable sharedRouter] openExternal:@"tel://10086"];
            }
        }];
    }else if (sender == _leftBtn)
    {
        [[WeiMiPageSkipManager mineRT] open:@"WeiMiRefundVC"];

    }else if (sender == _rightBtn)
    {
        
    }
 
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return _dataSource.count + 2;
    }else if (section == 3) {
        return 3;
    }else if (section == 4)
    {
        return 2;
    }
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellID = @"section0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
            
        }
        cell.textLabel.text = @"订单号：2000234234";
        return cell;
    }else if (indexPath.section == 1)
    {
        static NSString *cellID = @"section1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            
            UILabel *nameLB = [[UILabel alloc] init];
            nameLB.tag = 6666*indexPath.section + 6666*(indexPath.row + 1);
            nameLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
            nameLB.textAlignment = NSTextAlignmentLeft;
            nameLB.textColor = kBlackColor;
            [cell.contentView addSubview:nameLB];
            [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(33);
                make.bottom.mas_equalTo(cell.mas_centerY).offset(-5);
                make.right.mas_equalTo(-10);
            }];
            
            UIButton *addressBTN = [UIButton buttonWithType:UIButtonTypeCustom];
            addressBTN.tag = 6666*indexPath.section + 7777*(indexPath.row + 1);
            addressBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
            addressBTN.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [addressBTN setTitle:@"保存" forState:UIControlStateNormal];
            [addressBTN setTitleColor:kGrayColor forState:UIControlStateNormal];
            [addressBTN setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
            [cell.contentView addSubview:addressBTN];
            [addressBTN mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(20);
                make.top.mas_equalTo(cell.mas_centerY).offset(5);
                make.right.mas_equalTo(-10);
            }];
            [addressBTN horizontalCenterImageAndTitle];
        }
        
        UILabel *nameLB = [cell viewWithTag:6666*indexPath.section + 6666*(indexPath.row + 1)];
        if (nameLB) {
            nameLB.text = @"宋至   134543534";
        }
        
        UIButton *addressBTN = [cell viewWithTag:6666 *indexPath.section + 7777*(indexPath.row + 1)];
        if (addressBTN) {
            [addressBTN setTitle:@"北京昌平区六环业内巴巴爸爸公寓" forState:UIControlStateNormal];
        }
        
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        static NSString *cellID = @"section2:0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.font = WeiMiSystemFontWithpx(22);
        }
        cell.imageView.image = [UIImage imageNamed:@"icon_map"];
        cell.textLabel.text = @"京东";
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == _dataSource.count + 1)
    {
        static NSString *cellID = @"section2:-1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        }
        
        UIButton *contactBTN = [UIButton buttonWithType:UIButtonTypeCustom];
        contactBTN.layer.borderWidth = 0.5f;
        contactBTN.layer.borderColor = kGrayColor.CGColor;
        contactBTN.layer.cornerRadius = 3.0f;
        contactBTN.tag = 6666*indexPath.section + 7777*(indexPath.row + 1);
        contactBTN.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
        [contactBTN setTitle:@"联系客服" forState:UIControlStateNormal];
        [contactBTN setTitleColor:kGrayColor forState:UIControlStateNormal];
        [contactBTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:contactBTN];
        [contactBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(cell).insets(UIEdgeInsetsMake(15, 15, 15, 15));
        }];
    
        return cell;
    }else if (indexPath.section == 2)
    {
        static NSString *cellID = @"section2_2";
        WeiMiOrderUnPayGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiOrderUnPayGoodsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
            //        cell.detailTextLabel.textColor = kGrayColor;
//            cell.textLabel.text = safeObjectAtIndex(_dataSource, indexPath.row - 1);
            
        }
        return cell;
    }
    else if (indexPath.section == 3 && indexPath.row != 2)
    {
        static NSString *cellID = @"section3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            if (indexPath.row == 0) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            }else
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            }
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            cell.detailTextLabel.textColor = kGrayColor;
            cell.detailTextLabel.numberOfLines = 0;
//            cell.textLabel.text = safeObjectAtIndex(_dataSource, indexPath.row);

        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"支付方式";
            cell.detailTextLabel.text = @"在线支付";

        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"配送方式";
            cell.detailTextLabel.text = @"送货日期: 工作日、双休日与假日均可送货";
        }
        return cell;
    }else if (indexPath.section == 3 && indexPath.row == 2)
    {
        static NSString *cellID = @"section3";
        WeiMiBillInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiBillInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            
        }
        return cell;
    }else if (indexPath.section == 4 && indexPath.row == 0)
    {
        static NSString *cellID = @"section4_0";
        WeiMiGoodsAllPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiGoodsAllPriceCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            
        }
        return cell;
    }else if (indexPath.section == 4 && indexPath.row == 1)
    {
        static NSString *cellID = @"section4_1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.detailTextLabel.numberOfLines = 0;
        }
        cell.detailTextLabel.attributedText = [self attrStrWithActualPay:296.88 orderTime:@"2016年12月21日"];
        return cell;
    }
    
    static NSString *cellID = @"section0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        cell.textLabel.text = safeObjectAtIndex(_dataSource, indexPath.row);
        
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 45;
    }else if (indexPath.section == 1)
    {
        return 174/2;
    }else if (indexPath.section == 3 && indexPath.row == 0)
    {
        return 55;
    }else if (indexPath.section == 3 && indexPath.row == 1)
    {
        return 80;
    }else if (indexPath.section == 3 && indexPath.row == 2)
    {
        return 232/2;
    }else if (indexPath.section == 4 && indexPath.row == 0)
    {
        return 124;
    }else if (indexPath.section == 2 && indexPath.row == _dataSource.count + 1)
    {
        return 65;
    }else if (indexPath.section == 2 && indexPath.row == 0)
    {
        return 55;
    }else if (indexPath.section == 2)
    {
        return 110;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
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

- (void)updateViewConstraints
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_bottomView.mas_top);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT+NAV_HEIGHT);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(GetAdapterHeight(57));
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(_bottomView).multipliedBy(0.5);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_bottomView);
        make.width.mas_greaterThanOrEqualTo(70);
    }];
    
    [_leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(_rightBtn);
        make.right.mas_equalTo(_rightBtn.mas_left).offset(-15);
        make.centerY.mas_equalTo(_rightBtn);
        make.width.mas_equalTo(_rightBtn);

    }];
    
    [_deadLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(_bottomView);
    }];
    [super updateViewConstraints];
}

@end
