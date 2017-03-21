//
//  WeiMiLogInVC.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiLogInVC.h"
#import "WeimiLoginInputView.h"
#import "WeiMiUserDefaultConfig.h"

#import "WeiMiLoginRequest.h"
#import "WeiMiLoginResponse.h"

#import "WeiMiMainViewController.h"
@interface WeiMiLogInVC()<UITextFieldDelegate>

@property (nonatomic, strong) WeiMiLoginInputView *cellPhoneInputView;
@property (nonatomic, strong) WeiMiLoginInputView *passWordInputView;
@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIScrollView *scrollBGView;

@property (nonatomic, strong) UIButton *freeRegisterBtn;
@property (nonatomic, strong) UIButton *forgetPwdBtn;
@property (nonatomic, strong) UIButton *thirdLogin;

@property (nonatomic, strong) UIButton *weiXinBtn;
@property (nonatomic, strong) UIButton *weiBoBtn;
@property (nonatomic, strong) UIButton *qqBtn;

@end

@implementation WeiMiLogInVC

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:YES];
    [self.view addSubview:self.scrollBGView];
    self.scrollBGView.frame = self.contentFrame;
    
    [self.scrollBGView addSubview:self.cellPhoneInputView];
    [self.scrollBGView addSubview:self.passWordInputView];
    [self.scrollBGView addSubview:self.loginBtn];
    [self.scrollBGView addSubview:self.freeRegisterBtn];
    [self.scrollBGView addSubview:self.forgetPwdBtn];
//    [self.view addSubview:self.thirdLogin];
//    [self.view addSubview:self.weiXinBtn];
//    [self.view addSubview:self.weiBoBtn];
//    [self.view addSubview:self.qqBtn];
   
    [self.view setNeedsUpdateConstraints];
    self.view.backgroundColor = kWhiteColor;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)initNavgationItem
{
    self.title = @"登录";
    WS(weakSelf);
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        SS(strongSelf);
        
        NSArray *viewcontrollers=self.navigationController.viewControllers;
        if (viewcontrollers.count>1) {
            if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                //push方式
                [strongSelf BackToLastNavi];
            }
        }
        else{
            //present方式
            [strongSelf dismissViewControllerAnimated:YES completion:nil];

        }
    }];
}

- (WeiMiLoginInputView *)cellPhoneInputView
{
    if (!_cellPhoneInputView) {
        
        _cellPhoneInputView = [[WeiMiLoginInputView alloc] init];
        _cellPhoneInputView.delegate = self;
    }
    return _cellPhoneInputView;
}

- (UIScrollView *)scrollBGView
{
    if (!_scrollBGView) {
        
        _scrollBGView = [[UIScrollView alloc]  init];
        _scrollBGView.showsVerticalScrollIndicator = NO;
        _scrollBGView.showsHorizontalScrollIndicator = NO;
        _scrollBGView.scrollEnabled = YES;
    }
    return _scrollBGView;
}

- (WeiMiLoginInputView *)passWordInputView
{
    if (!_passWordInputView) {
        
        _passWordInputView = [[WeiMiLoginInputView alloc] init];
        _passWordInputView.delegate = self;
        _passWordInputView.keyboardType = UIKeyboardTypeDefault;
        _passWordInputView.secureTextEntry = YES;
        _passWordInputView.title = @"密码";
    }
    return _passWordInputView;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.borderColor = HEX_RGB(BASE_COLOR_HEX).CGColor;
        _loginBtn.layer.borderWidth = 1.0f;
        _loginBtn.layer.cornerRadius = 3.0f;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
//        [_loginBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
//        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_loginBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)freeRegisterBtn
{
    if (!_freeRegisterBtn) {
        
        _freeRegisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _freeRegisterBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_freeRegisterBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_freeRegisterBtn setTitle:@"免费注册" forState:UIControlStateNormal];
        [_freeRegisterBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        //        [_loginBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_freeRegisterBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _freeRegisterBtn;
}

- (UIButton *)forgetPwdBtn
{
    if (!_forgetPwdBtn) {
        
        _forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_forgetPwdBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        _forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPwdBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];

        [_forgetPwdBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPwdBtn;
}

- (UIButton *)thirdLogin
{
    if (!_thirdLogin) {
        
        _thirdLogin = [UIButton buttonWithType:UIButtonTypeCustom];
        [_thirdLogin setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
        _thirdLogin.titleLabel.font = [UIFont systemFontOfSize:14];
        [_thirdLogin setTitle:@"第三方登录" forState:UIControlStateNormal];
        [_thirdLogin setTitleColor:HEX_RGB(BASE_TEXT_COLOR) forState:UIControlStateNormal];

    }
    return _thirdLogin;
}

- (UIButton *)weiBoBtn
{
    if (!_weiBoBtn) {
        _weiBoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiBoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_weiBoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_weiBoBtn setBackgroundImage:[UIImage imageNamed:@"icon_weibo"] forState:UIControlStateNormal];
        [_weiBoBtn setBackgroundImage:[UIImage imageNamed:@"icon_weibo"] forState:UIControlStateSelected];
        [_weiBoBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weiBoBtn;
}

- (UIButton *)weiXinBtn
{
    if (!_weiXinBtn) {
        _weiXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _weiXinBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_weiXinBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_weiXinBtn setBackgroundImage:[UIImage imageNamed:@"icon_wechat"] forState:UIControlStateNormal];
        [_weiXinBtn setBackgroundImage:[UIImage imageNamed:@"icon_wechat"] forState:UIControlStateSelected];
        [_weiXinBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _weiXinBtn;
}

- (UIButton *)qqBtn
{
    if (!_qqBtn) {
        _qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _qqBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_qqBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_qqBtn setBackgroundImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateNormal];
        [_qqBtn setBackgroundImage:[UIImage imageNamed:@"icon_qq"] forState:UIControlStateSelected];
        [_qqBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qqBtn;
}

#pragma mark - Actions
- (void)onBtn:(UIButton *)sender
{
    if (sender == _loginBtn) {
        
        NSString *phoneNum = _cellPhoneInputView.inputFiled.text;
        NSString *pwd = _passWordInputView.inputFiled.text;
        if (![NSString isNullOrEmpty:phoneNum] && ![NSString isNullOrEmpty:pwd])
        {
//            [WeiMiUserDefaultConfig currentConfig].token = @"mada";
            [self registeWithPhone:phoneNum password:pwd];

        }else if([NSString isNullOrEmpty:phoneNum])
        {
            [self presentSheet:@"请输入您的账号"];
        }else if([NSString isNullOrEmpty:pwd])
        {
            [self presentSheet:@"请输入您的密码"];
        }
    }else if (sender == self.freeRegisterBtn)
    {
        [self.APP.mineRouter open:@"WeiMiRegisterVC"];
    }else if (sender == self.forgetPwdBtn)//忘记密码
    {
        [self.APP.mineRouter open:@"WeiMiForgetPwdVC"];
    }
}

//----登录
- (void)registeWithPhone:(NSString *)phone password:(NSString *)password
{
    WeiMiLoginRequest *request = [[WeiMiLoginRequest alloc] initWithMemberId:phone password:password];
    request.showHUD = YES;
    WS(weakSelf);
    WeiMiLoginResponse *response = [[WeiMiLoginResponse alloc] init];
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSDictionary *result = EncodeDicFromDic(request.responseJSONObject, @"result");
        if (result) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            
            [response parseResponse:result];
            
            [strongSelf presentSheet:@"登录成功" complete:^{
//                [strongSelf BackToLastNavi];
                
                NSArray *viewcontrollers=self.navigationController.viewControllers;
                if (viewcontrollers.count>1) {
                    if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
                        //push方式
                        [strongSelf BackToLastNavi];
                    }
                }
                else{
                    //present方式
                    [strongSelf dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:LOG_SELECT object:@"2"];
                }
            }];
        }else
        {
            [strongSelf presentSheet:@"登录失败"];
        }
        
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}
#pragma mark - UITextField
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    for (UIView *view in self.cellPhoneInputView.subviews) {
        [view resignFirstResponder];
    }
    
    for (UIView *view in self.passWordInputView.subviews) {
        [view resignFirstResponder];
    }
}

#pragma mark - Constraints
- (void)viewDidLayoutSubviews
{
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH,  SCREEN_HEIGHT + 10);
    
    [super viewDidLayoutSubviews];
}

- (void)updateViewConstraints
{
    [_cellPhoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.centerX.mas_equalTo(self.view);
//        make.left.mas_equalTo(60);
//        make.right.mas_equalTo(-60);
//        make.centerY.mas_equalTo(self.view).offset(-100);
//        make.height.mas_equalTo(25);
        
        make.height.mas_equalTo(_passWordInputView);
        make.left.mas_equalTo(_passWordInputView);
        make.width.mas_equalTo(_passWordInputView);
        make.bottom.mas_equalTo(_passWordInputView.mas_top).offset(-20);
    }];
    
    [_passWordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
//        make.centerX.mas_equalTo(self.view);
//        make.left.mas_equalTo(60);
//        make.right.mas_equalTo(-60);
//        make.centerY.mas_equalTo(self.view).offset(-60);
        make.height.mas_equalTo(25);
        make.left.mas_equalTo(60);
        make.width.mas_equalTo(SCREEN_WIDTH - 120);
        make.bottom.mas_equalTo(_loginBtn.mas_top).offset(-20);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(SCREEN_HEIGHT/2 - STATUS_BAR_HEIGHT -NAV_HEIGHT);
        make.centerX.mas_equalTo(_passWordInputView);
//        make.width.mas_equalTo(SCREEN_WIDTH - 120);
        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(SCREEN_WIDTH - 90), 32));//75
    }];
    
    [_freeRegisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(_passWordInputView);
        make.top.mas_equalTo(_loginBtn.mas_bottom).offset(15);
        make.right.mas_equalTo(self.view.mas_centerX);
    }];
    
    [_forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_passWordInputView);
        make.top.mas_equalTo(_loginBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_centerX);
    }];
    
//    [_thirdLogin mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(_loginBtn.mas_bottom).offset(GetAdapterHeight(85));
//        make.centerX.mas_equalTo(self.view);
//        make.left.right.mas_equalTo(0);
//    }];
//    
//    [@[_weiBoBtn, _weiXinBtn, _qqBtn] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:40.0f leadSpacing:80 tailSpacing:80];
//    [@[_weiBoBtn, _weiXinBtn, _qqBtn] mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.mas_equalTo(_thirdLogin.mas_bottom).offset(GetAdapterHeight(48));
//        make.height.mas_equalTo(_weiXinBtn.mas_width);
//    }];
    
    [super updateViewConstraints];
}



@end
