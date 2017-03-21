//
//  WeiMiMakeSureOrderVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMakeSureOrderVC.h"
#import "WeiMiBaseTableView.h"
#import "UILabel+NotiLabel.h"
#import "UIButton+CenterImageAndTitle.h"
#import "WeiMiBillInfoCell.h"
#import "WeiMiSureOrderGoodsInfoCell.h"
#import <OHAlertView.h>
#import <NSMutableAttributedString+OHAdditions.h>
#import "WeiMiSureGoodsCell.h"
#import "UITextView+Placeholder.h"
#import "WeiMiPaymentView.h"                                 
#define kBottomViewColor   (0xF8F8F8)

@interface WeiMiMakeSureOrderVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>
{
    /**数据源*/
    NSArray *_imgArr;
    
    CGSize _lastCellSize;
    
    BOOL _isAliPay;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) WeiMiBaseView *bottomView;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *deadLineLB;
@property (nonatomic, strong) UITextView *leaveMsgView;

@property (nonatomic, strong) UILabel *tagFAC;
@property (nonatomic, strong) UIButton *selectButtonFAC;

@end

@implementation WeiMiMakeSureOrderVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastCellSize = CGSizeZero;
        _isAliPay = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.rightBtn];
    [self.bottomView addSubview:self.deadLineLB];
    
    //    _tableView.frame = self.contentFrame;
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
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
    self.title = @"确认订单";
//    self.popWithBaseNavColor = YES;
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
- (UIButton *)selectButtonFAC
{
    UIButton *BTN = [UIButton buttonWithType:UIButtonTypeCustom];
    BTN.titleLabel.font = [UIFont systemFontOfSize:16];
    //    [BTN setTitle:@"设为默认地址" forState:UIControlStateNormal];
    //    [BTN setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];
    [BTN setImage:[UIImage imageNamed:@"icon_circle"] forState:UIControlStateNormal];
    [BTN setImage:[UIImage imageNamed:@"icon_ball_pre"] forState:UIControlStateSelected];
    //    [BTN addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    [BTN sizeToFit];

    return BTN;
}

- (UILabel *)tagFAC
{
    UILabel *deadLineLB = [[UILabel alloc] init];
    deadLineLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
    deadLineLB.textAlignment = NSTextAlignmentLeft;
    deadLineLB.textColor = kWhiteColor;
    deadLineLB.text = @"荐";
    [deadLineLB sizeToFit];
    return deadLineLB;
}
- (UITextView *)leaveMsgView
{
    if (!_leaveMsgView) {
        _leaveMsgView = [[UITextView alloc] init];
        _leaveMsgView.placeholder = @"给我们留言";
        _leaveMsgView.delegate = self;
        _leaveMsgView.font = WeiMiSystemFontWithpx(20);
        _leaveMsgView.backgroundColor = HEX_RGB(0xF2F2F0);
        _leaveMsgView.layer.masksToBounds = YES;
        _leaveMsgView.layer.cornerRadius = 5.0f;
    }
    return _leaveMsgView;
}
- (UILabel *)deadLineLB
{
    if (!_deadLineLB) {
        
        _deadLineLB = [[UILabel alloc] init];
        _deadLineLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(20)];
        _deadLineLB.textAlignment = NSTextAlignmentLeft;
        _deadLineLB.textColor = HEX_RGB(BASE_TEXT_COLOR);
        _deadLineLB.numberOfLines = 2;
        _deadLineLB.attributedText = [self attrStrWithPrice:@"23.00"];
        [_deadLineLB sizeToFit];
    }
    return _deadLineLB;
}


- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_rightBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = WeiMiSystemFontWithpx(22);
        [_rightBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        //        [_rightBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"purple_btn_pre"] forState:UIControlStateNormal];
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

- (NSMutableAttributedString *)attrStrWithPrice:(NSString *)str
{
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"应付" attributes:@{
                                                                                                                      NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(22)],
                                                                                                                      NSForegroundColorAttributeName:kGrayColor}];
    NSMutableAttributedString *sufStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@", str] attributes:@{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:kFontSizeWithpx(22)], NSForegroundColorAttributeName:kRedColor}];
    [attString appendAttributedString:sufStr];
    
    return attString;
}
#pragma mark - Actions
- (void)onButton:(UIButton *)sender
{
    WeiMiPaymentView *payAlert = [[WeiMiPaymentView alloc] init];
    payAlert.title = @"请输入支付密码";
    payAlert.detail = @"提现";
    payAlert.amount= 10;
    [payAlert show];
    payAlert.completeHandle = ^(NSString *inputPwd) {
        NSLog(@"密码是%@",inputPwd);
    };

}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    //    ShouldChangeTextHandler block = self.shouldChangeTextHandler;
    //    if (block) {
    //        block(textView.contentSize);
    //    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (CGSizeEqualToSize(_lastCellSize, CGSizeZero)) {
        _lastCellSize = CGSizeMake(SCREEN_WIDTH, GetAdapterHeight(100));
        
    }
    [_tableView beginUpdates];
    [_tableView endUpdates];
    
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 5;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.section == 0)
    {
        static NSString *cellID = @"section1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            //收货人
            UILabel *nameLB = [[UILabel alloc] init];
            nameLB.tag = 6666*indexPath.section + 6666*(indexPath.row + 1);
            nameLB.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(22)];
            nameLB.textAlignment = NSTextAlignmentLeft;
            nameLB.textColor = kBlackColor;
            [cell.contentView addSubview:nameLB];
            [nameLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(33);
                make.bottom.mas_equalTo(cell.mas_centerY).offset(-10);
                make.right.mas_equalTo(-10);
            }];
            
            //收货地址
            UILabel *addressLB = [[UILabel alloc] init];
            addressLB.tag = 6666*indexPath.section + 7777*(indexPath.row + 1);
            addressLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
            addressLB.textAlignment = NSTextAlignmentLeft;
            addressLB.numberOfLines = 2;
            [cell.contentView addSubview:addressLB];
            [addressLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(nameLB);
                make.top.mas_equalTo(nameLB.mas_bottom).offset(5);
                make.right.mas_equalTo(-10);
            }];
        }
        
        UILabel *nameLB = [cell viewWithTag:6666*indexPath.section + 6666*(indexPath.row + 1)];
        if (nameLB) {
            nameLB.text = @"收货人:宋zhi      1332232323";
        }
        
        UILabel *addressLB = [cell viewWithTag:6666 *indexPath.section + 7777*(indexPath.row + 1)];
        if (addressLB) {
            addressLB.text = @"送货人地址:北京昌平区六环业内巴巴爸爸公寓";
        }
        
        return cell;
    }else if (indexPath.section == 1)
    {
        static NSString *cellID = @"section_1";
        WeiMiSureGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiSureGoodsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            
        }
        return cell;
    }
    else if (indexPath.section == 2 && (indexPath.row == 0 || indexPath.row == 1))
    {
        NSString *cellID = @"section2_0";
        if (indexPath.row == 1) {
            cellID = @"section2_1";
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            cell.detailTextLabel.textColor = kGrayColor;
            cell.detailTextLabel.numberOfLines = 0;
            
            UIButton *BTN = self.selectButtonFAC;
            BTN.userInteractionEnabled = NO;
            BTN.tag = 8888*indexPath.section + indexPath.row;
            [cell.contentView addSubview:BTN];
            [BTN mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-20);
            }];
            
            if (indexPath.row == 0) {
                BTN.selected = YES;
                
                //tag
                UILabel *tag = self.tagFAC;
                tag.backgroundColor = kRedColor;
                [cell.contentView addSubview:tag];
                [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(BTN.mas_left).offset(-10);
                }];
            }else if (indexPath.row == 1)
            {
                //tag
                UILabel *tag = self.tagFAC;
                tag.backgroundColor = HEX_RGB(0xFF9836);
                tag.text = @"新";
                [cell.contentView addSubview:tag];
                [tag mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.centerY.mas_equalTo(cell);
                    make.right.mas_equalTo(BTN.mas_left).offset(-10);
                }];
            }
            
        }
        
        if (indexPath.row == 0) {
            cell.textLabel.text = @"支付宝";
            
        }else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"微信支付";
        }
        
        
        UIButton *BTN = [cell viewWithTag:8888*indexPath.section + indexPath.row];
        if (BTN) {
            if (indexPath.row == 0) {
                BTN.selected = _isAliPay ? YES:NO;
            }else
            {
                BTN.selected = _isAliPay ? NO:YES;
            }
        }
        
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 2)
    {
        static NSString *cellID = @"section2_2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
            cell.textLabel.text = @"促销";
            //包邮tag
            UILabel *tagLB = [[UILabel alloc] init];
            tagLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(20)];
            tagLB.textAlignment = NSTextAlignmentCenter;
            tagLB.text = @"包邮";
            tagLB.textColor = kWhiteColor;
            tagLB.backgroundColor = HEX_RGB(0xF7C319);
            tagLB.layer.masksToBounds = YES;
            tagLB.layer.cornerRadius = 3.0f;
            [tagLB sizeToFit];
            [cell addSubview:tagLB];
            [tagLB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-20);
                make.centerY.mas_equalTo(cell.textLabel);
                make.height.mas_equalTo(GetAdapterHeight(22));
                make.width.mas_equalTo(tagLB.mas_height).multipliedBy(2.05f);
            }];
            
        }
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 3)
    {
        static NSString *cellID = @"section2_3";
        WeiMiSureOrderGoodsInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[WeiMiSureOrderGoodsInfoCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
            
        }
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 4)
    {
        static NSString *cellID = @"section2_4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
            [cell.contentView addSubview:self.leaveMsgView];
            [_leaveMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(cell).insets(UIEdgeInsetsMake(15, 10, 15, 10));
            }];
        }
 
        return cell;
    }
    
    static NSString *cellID = @"section0";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        
    }
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 174/2;
    }else if (indexPath.section == 1)
    {
        return 110;
    }else if (indexPath.section == 2 && (indexPath.row == 0 || indexPath.row == 1 ||indexPath.row == 2 ))
    {
        return 45;
    }else if (indexPath.section == 2 && (indexPath.row == 0 || indexPath.row == 3))
    {
        return 124;
    }
    else if (indexPath.section == 2 && indexPath.row == 4)
    {
        if (_lastCellSize.height == 0) {
            return 70;
        }
        return _lastCellSize.height;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 30;
    }
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 0.1;
    }
    return 10.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return [UILabel footerNotiLabelWithTitle:@"支付方式" textAlignment:NSTextAlignmentLeft];
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2 && (indexPath.row == 0 || indexPath.row == 1)) {
        UIButton *sender = [[tableView cellForRowAtIndexPath:indexPath] viewWithTag:8888*indexPath.section + indexPath.row];
        if (sender) {
            sender.selected = !sender.selected;
            if (sender.tag == 8888 * 2) {
                _isAliPay = sender.selected ? YES:NO;
            }else
            {
                _isAliPay = sender.selected ? NO:YES;
            }
            [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:2], [NSIndexPath indexPathForRow:1 inSection:2]] withRowAnimation:UITableViewRowAnimationNone];
        }
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

- (void)updateViewConstraints
{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(_bottomView.mas_top);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT+NAV_HEIGHT);
    }];
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(GetAdapterHeight(60));
    }];
    
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(_rightBtn.mas_height).multipliedBy(2.875);
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(_bottomView);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    
    [_deadLineLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(_bottomView);
    }];
    [super updateViewConstraints];
}

@end
