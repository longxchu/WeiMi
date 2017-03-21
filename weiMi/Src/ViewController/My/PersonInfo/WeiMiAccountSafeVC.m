//
//  WeiMiAccountSafeVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiAccountSafeVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiUserCenter.h"
#import "UILabel+NotiLabel.h"
#import <OHAlertView.h>

@interface WeiMiAccountSafeVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSMutableArray *_imageSource;
    NSString *_telNum;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) UILabel *footerLabelFAC;
@property (nonatomic, strong) UIButton *bindBtnFAC;
@property (nonatomic, strong) UILabel *detailLabelFAC;

@end

@implementation WeiMiAccountSafeVC

- (instancetype)init
{
    self = [super init];
    if (self) {
//        _dataSource = @[@[@"手机号"],
//                        @[@"密码"],
//                        @[@"腾讯QQ",@"新浪微博",@"微信"]];
        _dataSource = @[@[@"手机号"],
                        @[@"密码"]];
        
        _imageSource = [NSMutableArray arrayWithArray:@[@[@"未绑定"],
                                                        @[@"去设置"],
                                                        @[@"icon_qq",@"icon_weibo",@"icon_wechat"]]];
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
    self.title = @"账号与安全";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
//                [strongSelf.APP.mineRouter open:[NSString stringWithFormat:@"WeiMiModifyNameVC/%@", _name]];
        
        [strongSelf BackToLastNavi];
    }];
    
}

#pragma mark -Actions
- (void)onButton:(UIButton *)sender
{
    WS(weakSelf);
    if(sender.tag == 60)
    {
        [OHAlertView showAlertWithTitle:@"绑定QQ" message:@"绑定后您可以使用QQ登陆唯蜜生活哦~" cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            SS(strongSelf);
            if (buttonIndex == 1) {
                [strongSelf setButtonSelected:sender];
            }
        }];
    }else if(sender.tag == 61)
    {
        [OHAlertView showAlertWithTitle:@"绑定微博" message:@"绑定后您可以使用微博登陆唯蜜生活哦~" cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            SS(strongSelf);
            if (buttonIndex == 1) {
                [strongSelf setButtonSelected:sender];
            }
        }];
    }else if(sender.tag == 62)
    {
        [OHAlertView showAlertWithTitle:@"绑定微信" message:@"绑定后您可以使用微信登陆唯蜜生活哦~" cancelButton:@"取消" otherButtons:@[@"确定"] buttonHandler:^(OHAlertView *alert, NSInteger buttonIndex) {
            SS(strongSelf);
            if (buttonIndex == 1) {
                [strongSelf setButtonSelected:sender];
            }
        }];
    }
    
}

- (void)setButtonSelected:(UIButton *)button
{
    if (!button.selected) {
        button.layer.borderColor = kGrayColor.CGColor;
    }else
    {
        button.layer.borderColor = HEX_RGB(0xf38855).CGColor;
        
    }
    button.selected = !button.selected;
}

#pragma mark - Getter
- (UIButton *)bindBtnFAC
{
    UIButton *bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bindBtn sizeToFit];
    bindBtn.layer.borderColor = HEX_RGB(0xf38855).CGColor;
    bindBtn.layer.masksToBounds = YES;
    bindBtn.layer.borderWidth = 1.0f;
    bindBtn.layer.cornerRadius = 3.0f;
    bindBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [bindBtn setTitleColor:HEX_RGB(0xf38855) forState:UIControlStateNormal];
    [bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [bindBtn setTitleColor:kGrayColor forState:UIControlStateSelected];
    [bindBtn setTitle:@"已绑定" forState:UIControlStateSelected];
//    [bindBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
    [bindBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    return bindBtn;
}

- (UILabel *)detailLabelFAC
{
    UILabel *rightTitleLB = [[UILabel alloc] init];
    rightTitleLB.textAlignment = NSTextAlignmentRight;
    rightTitleLB.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
    rightTitleLB.textColor = kRedColor;
    return rightTitleLB;
}

- (UILabel *)footerLabelFAC
{
    UILabel *notiLabel = [[UILabel alloc] init];
    notiLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    notiLabel.textColor = kGrayColor;
    notiLabel.numberOfLines = 2;
    notiLabel.textAlignment = NSTextAlignmentLeft;
    notiLabel.font = [UIFont fontWithName:@"Arial" size:14];
    return notiLabel;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.backgroundColor = HEX_RGB(BASE_BG_COLOR);
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
//    static NSString *cellID = @"accountSafeCell";
    NSString *cellID = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        
        if (indexPath.section == 2) {
            cell.imageView.image = [UIImage imageNamed:_imageSource[indexPath.section][indexPath.row]];
            
            UIButton *button = self.bindBtnFAC;
            button.tag = 20 *(indexPath.section +1)+ indexPath.row;
            [cell.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.centerY.mas_equalTo(cell);
                make.right.mas_equalTo(-10);
                make.width.mas_greaterThanOrEqualTo(60);
            }];
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *detailLabel = self.detailLabelFAC;
            detailLabel.tag = 8888 *(indexPath.section +1)+ indexPath.row;
            [cell.contentView addSubview:detailLabel];
            [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.center.mas_equalTo(cell);
                make.right.mas_equalTo(-10);
            }];
            
            if (indexPath.section != 2) {
                detailLabel.text = _imageSource[indexPath.section][indexPath.row];
            }
            
            if (indexPath.section == 0) {
                
                if ([WeiMiUserCenter sharedInstance].userInfoDTO.tel) {
                    detailLabel.text =  [WeiMiUserCenter sharedInstance].userInfoDTO.tel;
                    detailLabel.textColor = kBlackColor;
//                    cell.userInteractionEnabled = NO;
                }
                
                [[WeiMiPageSkipManager mineRouter] configCallBack:@"WeiMIBindTelVC/:tel" block:^(NSDictionary *params) {
                    detailLabel.text =  EncodeStringFromDic(params, @"tel");
                    detailLabel.textColor = kBlackColor;
                    
                    [WeiMiUserCenter sharedInstance].userInfoDTO.tel = detailLabel.text;
                }];
            }else if (indexPath.section == 1)
            {
                if ([WeiMiUserCenter sharedInstance].userInfoDTO.password) {
                    detailLabel.text =  @"安全";
                    detailLabel.textColor = kBlackColor;
                }
                [[WeiMiPageSkipManager mineRouter] configCallBack:@"WeiMiSetPwdVC/:success" block:^(NSDictionary *params) {
                    detailLabel.text = @"安全";
                    detailLabel.textColor = kBlackColor;
                }];
            }
        }

    }
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];

    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2 || section == 0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }else if (section == 2)
    {
        return 60;
    }
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
       
        return [UILabel footerNotiLabelWithTitle:@"您可以通过昵称和密码登陆" textAlignment:NSTextAlignmentCenter];
    }else if (section == 2)
    {
        return [UILabel footerNotiLabelWithTitle:@"账号绑定只用于快速登录，未经过您允许，唯蜜生活绝对不会用作其他用途" textAlignment:NSTextAlignmentCenter];
    }
    return nil;
}

- (NSAttributedString *)getAttr:(NSString *)str
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10.0f;
    style.headIndent = 10.0f;
    style.tailIndent = -5.0f;
    return [[NSAttributedString alloc] initWithString:str attributes:@{NSParagraphStyleAttributeName:style}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMIBindTelVC"];

    }else if (indexPath.section == 1)
    {
        [[WeiMiPageSkipManager mineRouter] skipIntoVC:@"WeiMiSetPwdVC"];
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
