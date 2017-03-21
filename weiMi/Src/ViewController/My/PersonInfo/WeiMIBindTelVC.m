//
//  WeiMIBindTelVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMIBindTelVC.h"
#import "WeiMiBaseTableView.h"
#import "UILabel+NotiLabel.h"
#import "WeiMiUserCenter.h"
#import "WeiMiNotifiEmptyView.h"

#define kSendCodeBtnColor     (0x00B7EE)
@interface WeiMIBindTelVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSMutableArray *_imageSource;
    NSUInteger _downTime;
    
    NSString *_phoneNum;
    NSString *_verifyNum;
}

@property (nonatomic, strong) WeiMiBaseTableView *tableView;

@property (nonatomic, strong) UIButton *bindBtn;
@property (nonatomic, strong) UIButton *sendVerifyBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UILabel *notiLabel;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;


@end

@implementation WeiMIBindTelVC

- (instancetype)init
{
    self = [super init];
    if (self) {

        _dataSource = @[@[@"请输入您的手机号"],
                        @[@"请输入验证码"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    _notiLabel = [UILabel defaultNotiLabelWithTitle:nil];
    [_notiLabel sizeToFit];
    [self.footerView addSubview:_notiLabel];
    [self.footerView addSubview:self.bindBtn];
    
    [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
    }];
    
    [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(43);
        make.top.mas_equalTo(_notiLabel.mas_bottom).offset(10);
    }];
    
    _footerView.backgroundColor = kClearColor;
    _tableView.tableFooterView = _footerView;
    
    [self.view setNeedsUpdateConstraints];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"绑定手机";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        [strongSelf.APP.mineRouter open:[NSString stringWithFormat:@"WeiMiModifyNameVC/%@", _name]];


        [strongSelf BackToLastNavi];
    }];
    
}

- (BOOL)controllerWillPopHandler
{
    if (_phoneNum) {
        [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMIBindTelVC" params:@[_phoneNum]];
    }
    return YES;
}

#pragma mark -Actions
- (void)onButton:(UIButton *)sender
{
    if (sender == _sendVerifyBtn)
    {
        [self presentSheet:@"验证码为：1234 "];
        sender.selected = !sender.selected;
        if (_downTime == 0) {
            _downTime = 60;
            [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
    }else if (sender == _bindBtn)
    {
        if (_verifyNum && _phoneNum) {
            if ([_phoneNum isValidMobile]) {
                
                self.notiView = [[WeiMiNotifiEmptyView alloc] init];
                [self.notiView setViewWithImg:@"_icon_succeed" title:@"绑定成功"];
                self.notiView.backgroundColor = kWhiteColor;
                self.view.backgroundColor = self.tableView.backgroundColor;
                [self.tableView removeFromSuperview];
                [self.view addSubview:self.notiView];
                [self.notiView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.mas_equalTo(STATUS_BAR_HEIGHT + NAV_HEIGHT + 20);
                    make.left.mas_equalTo(10);
                    make.right.mas_equalTo(-10);
                    make.height.mas_equalTo(GetAdapterHeight(150));
                }];
                [self presentSheet:@"绑定成功"];
//                [WeiMiUserCenter sharedInstance].userInfoDTO.tel = _phoneNum;

            }else
            {
                [self presentSheet:@"输入的手机号不正确"];
            }

        }else
        {
            self.notiLabel.text = @"对不起，您输入的验证码有误";
        }

    }

}

- (void)updateTimeDown
{
    if (_downTime != 0) {
        _downTime --;
        [_sendVerifyBtn setUserInteractionEnabled:NO];
        [_sendVerifyBtn setTitle:[NSString stringWithFormat:@" 重新获取(%ld) ", _downTime] forState:UIControlStateNormal];
    }
    else
    {
        if (_timer.isValid) {
            [self.timer invalidate];
            _sendVerifyBtn.selected = NO;
            [_sendVerifyBtn setUserInteractionEnabled:YES];
            [_sendVerifyBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - Getter
- (UIView *)footerView
{
    if (!_footerView) {
        
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    }
    return _footerView;
}

- (UITextField *)textFiledFAC
{
    UITextField *textFiled = [[UITextField alloc] init];
    textFiled.borderStyle = UITextBorderStyleNone;
    textFiled.textAlignment = NSTextAlignmentLeft;
    textFiled.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
    textFiled.delegate = self;
    textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    return textFiled;
}

- (NSTimer *)timer
{
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTimeDown) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIButton *)bindBtn
{
    if (!_bindBtn) {
        _bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bindBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_bindBtn setTitle:@"绑定" forState:UIControlStateNormal];
        [_bindBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_bindBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _bindBtn;
}

- (UIButton*)sendVerifyBtn
{
    if (!_sendVerifyBtn) {
        
        _sendVerifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendVerifyBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        [_sendVerifyBtn sizeToFit];
        _sendVerifyBtn.layer.masksToBounds = YES;
        _sendVerifyBtn.layer.cornerRadius = 3.0f;
        [_sendVerifyBtn setBackgroundImage:[UIImage imageWithColor:HEX_RGB(kSendCodeBtnColor)] forState:UIControlStateNormal];
        [_sendVerifyBtn setBackgroundImage:[UIImage imageWithColor:kGrayColor] forState:UIControlStateSelected];
        [_sendVerifyBtn setTitle:@" 发送验证码 " forState:UIControlStateNormal];
        [_sendVerifyBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        //        [_loginBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_sendVerifyBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendVerifyBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [WeiMiBaseTableView tableView];
        _tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
        _tableView.scrollToHidenKeyBorad = YES;
        _tableView.frame = self.contentFrame;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    
    if (range.location>=18)
    {
        //        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField.tag == 8888 + 0) {
            
            _phoneNum = textField.text;
        }else if (textField.tag == 8888 + 1)
        {
            _verifyNum = textField.text;
        }
        return  NO;
    }
    else
    {
        if (textField.tag == 8888 + 0) {
            
            _phoneNum = [textField.text stringByAppendingString:string];
        }else if (textField.tag == 8888 + 1)
        {
            _verifyNum = [textField.text stringByAppendingString:string];
        }
        return YES;
    }
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
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        
        UITextField *textFiled = self.textFiledFAC;
        textFiled.placeholder = _dataSource[indexPath.section][indexPath.row];
        textFiled.tag = 8888 + indexPath.section;
        textFiled.keyboardType = UIKeyboardTypeNumberPad;
        textFiled.delegate = self;
        [cell.contentView addSubview:textFiled];
        
        UIButton *sendCodeBtn;
        if (indexPath.section == 1) {
            sendCodeBtn = self.sendVerifyBtn;
            [cell.contentView addSubview:sendCodeBtn];
            [sendCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.mas_equalTo(-10);
                make.centerY.mas_equalTo(cell);
                make.width.mas_equalTo(100);
                make.top.mas_equalTo(5);
                make.bottom.mas_equalTo(-5);
            }];
        }
        
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(cell);
            make.left.mas_equalTo(15);
            if (!sendCodeBtn) {
                make.right.mas_equalTo(-15);
            }else
            {
                make.right.mas_equalTo(sendCodeBtn.mas_left).offset(-10);
            }
        }];

        
    }
    
    return cell;
}

#pragma mark - UITabelViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    if (section == 1) {
//        
//        _notiLabel = [UILabel defaultNotiLabelWithTitle:nil];
//        [_notiLabel sizeToFit];
//        [self.footerView addSubview:_notiLabel];
//        [self.footerView addSubview:self.bindBtn];
//        
//        [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(20);
//            make.left.right.mas_equalTo(0);
//        }];
//        
//        [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.mas_equalTo(15);
//            make.right.mas_equalTo(-15);
//            make.height.mas_equalTo(43);
//            make.top.mas_equalTo(_notiLabel.mas_bottom).offset(10);
//        }];
//        
//        _footerView.backgroundColor = kClearColor;
//        return _footerView;
//    }
//    return nil;
//}


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
