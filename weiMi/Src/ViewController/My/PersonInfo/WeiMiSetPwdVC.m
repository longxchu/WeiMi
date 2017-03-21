//
//  WeiMiSetPwdVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiSetPwdVC.h"
#import "WeiMiBaseTableView.h"
#import "WeiMiUserCenter.h"
#import "WeiMiNotifiEmptyView.h"

//------- request
#import "WeiMiChangePassWordRequest.h"
@interface WeiMiSetPwdVC ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    /**数据源*/
    NSArray *_dataSource;
    NSArray *_placeHolderArr;
    
    NSString *_newPwd;
    NSString *_surePwd;
    
    BOOL _setSuccess;
}

@property (nonatomic, strong) UIButton *bindBtn;
@property (nonatomic, strong) WeiMiBaseTableView *tableView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic, strong) WeiMiNotifiEmptyView *notiView;


@end

@implementation WeiMiSetPwdVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _dataSource = @[@"新密码:",
                        @"确认密码:"];
        _placeHolderArr = @[@"6-18位字符",
                            @"再输一次密码"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    
    [self.contentView addSubview:self.tableView];
    
    [self.footerView addSubview:self.bindBtn];
    [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(43);
        make.top.mas_equalTo(30);
    }];
    self.footerView.backgroundColor = kClearColor;
    _tableView.tableFooterView = self.footerView;
    
    [self.view setNeedsUpdateConstraints];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initNavgationItem
{
    [super initNavgationItem];
    self.title = @"设置密码";
    WS(weakSelf);
    
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        SS(strongSelf);
        //        [strongSelf.APP.mineRouter open:[NSString stringWithFormat:@"WeiMiModifyNameVC/%@", _name]];
        if (_setSuccess) {
            [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiSetPwdVC" params:@[@1]];
        }
        
        [strongSelf BackToLastNavi];
    }];
    
}

- (BOOL)controllerWillPopHandler
{
    if (_setSuccess) {
        [[WeiMiPageSkipManager mineRouter] callBackToVC:@"WeiMiSetPwdVC" params:@[@1]];
    }
    return YES;
}

#pragma mark -Actions
- (void)onButton:(UIButton *)sender
{
    if (_newPwd.length < 6 || _surePwd.length < 6) {
        [self presentSheet:@"密码长度需要大于等于6位哦"];
    }
    if (_newPwd && _surePwd) {
        if ([_newPwd isEqualToString:_surePwd]) {
            
//            [self changePwdWithPhone:[WeiMiUserCenter sharedInstance].userInfoDTO.tel password:_newPwd verifyCode:<#(NSString *)#>];
        }else{
            [self presentSheet:@"两次输入不一致！"];
        }
    }else
    {
        [self presentSheet:@"输入不正确"];
    }
}


#pragma mark - Getter
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

- (UIButton *)bindBtn
{
    if (!_bindBtn) {
        _bindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bindBtn.titleLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        _bindBtn.frame = CGRectMake(15, 15, SCREEN_WIDTH - 30, 45);
        //        _addAddressBtn.layer.masksToBounds = YES;
        //
        //        _addAddressBtn.layer.cornerRadius = 3.0f;
        [_bindBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_bindBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateNormal];
        [_bindBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_bindBtn addTarget:self action:@selector(onButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bindBtn;
}

- (UIView *)footerView
{
    if (!_footerView) {
        
        _footerView = [[UIView alloc] init];
        _footerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 220);
    }
    return _footerView;
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

#pragma mark - Util
- (void)setSuccessChnagedActions
{
    self.notiView = [[WeiMiNotifiEmptyView alloc] init];
    [self.notiView setViewWithImg:@"_icon_succeed" title:@"修改成功"];
    self.notiView.backgroundColor = kWhiteColor;
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.notiView];
    [self.notiView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(STATUS_BAR_HEIGHT + NAV_HEIGHT + 20);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.mas_equalTo(150);
    }];
    
    [self presentSheet:@"修改成功"];
    _setSuccess = YES;
    [WeiMiUserCenter sharedInstance].userInfoDTO.password = _newPwd;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changePwd" object:nil];

}

#pragma mark - NetWork
- (void)changePwdWithPhone:(NSString *)phone password:(NSString *)password verifyCode:(NSString *)code
{
    WeiMiChangePassWordRequest *request = [[WeiMiChangePassWordRequest alloc] initWithMemberId:phone password:password verifyCode:code];
    request.showHUD = YES;
    WS(weakSelf);
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            
            [strongSelf setSuccessChnagedActions];
//            [strongSelf presentSheet:@"修改成功" complete:^{
//                [strongSelf BackToLastNavi];
//            }];
        }else
        {
            [strongSelf presentSheet:@"修改失败"];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSLog(@"%@", textField.text);
    if (range.location>=18)
    {
//        textField.text = [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (textField.tag == 8888 + 0) {
            
            _newPwd = textField.text;
        }else if (textField.tag == 8888 + 1)
        {
            _surePwd = textField.text;
        }
        return  NO;
    }
    else
    {
        if (textField.tag == 8888 + 0) {
            
            _newPwd = [textField.text stringByAppendingString:string];
        }else if (textField.tag == 8888 + 1)
        {
            _surePwd = [textField.text stringByAppendingString:string];
        }
        return YES;
    }
}

#pragma mark - Actions


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
    static NSString *cellID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:kFontSizeWithpx(22)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.textLabel.textColor = HEX_RGB(BASE_TEXT_COLOR);
        //        cell.detailTextLabel.textColor = kGrayColor;
        cell.textLabel.text = _dataSource[indexPath.row];
        
        UITextField *textFiled = self.textFiledFAC;
        textFiled.placeholder = _placeHolderArr[indexPath.row];
        textFiled.tag = 8888 + indexPath.row;
        textFiled.keyboardType = UIKeyboardTypeNumberPad;
        textFiled.secureTextEntry = YES;
        textFiled.delegate = self;
        [cell.contentView addSubview:textFiled];
    
        
        [textFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(cell);
            make.left.mas_equalTo(cell.textLabel.mas_right).offset(20);
            make.right.mas_equalTo(-15);

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
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    [self.footerView addSubview:self.bindBtn];
//    [_bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(43);
//        make.top.mas_equalTo(30);
//    }];
//    self.footerView.backgroundColor = kClearColor;
//    return self.footerView;
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
