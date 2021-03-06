//
//  WeiMiForgetPwdVC.m
//  weiMi
//
//  Created by 梁宪松 on 2016/12/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiForgetPwdVC.h"
#import "WeimiLoginInputView.h"
#import "WeiMiUserDefaultConfig.h"
#import "NSTimer+Add.h"
#import "NSString+Utilities.h"
//------------reqeust
#import "WeiMiPassWorldRequest.h"
#import "WeiMiRegisterRequest.h"
#import "WeiMiCheckExistRequest.h"
#import "YTKChainRequest.h"
#import "WeiMiChangePassWordRequest.h"

@interface WeiMiForgetPwdVC ()<UITextFieldDelegate, YTKChainRequestDelegate>
{
    NSUInteger _downTime;
}

@property (nonatomic, strong) WeiMiLoginInputView *cellPhoneInputView;
@property (nonatomic, strong) WeiMiLoginInputView *verifyCodeInputView;
@property (nonatomic, strong) WeiMiLoginInputView *passWordInputView;

@property (nonatomic, strong) UIScrollView *scrollBGView;

@property (nonatomic, strong) UIButton *downCountBtn;

@property (nonatomic, strong) UIButton *okBtn;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation WeiMiForgetPwdVC

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

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_downTime == 0) {
        [self.timer pauseTimer];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentFrame = [self visibleBoundsShowNav:YES showTabBar:NO];
    [self.view addSubview:self.scrollBGView];
    self.scrollBGView.frame = self.contentFrame;
    
    [self.scrollBGView addSubview:self.passWordInputView];
    [self.scrollBGView addSubview:self.verifyCodeInputView];
    [self.scrollBGView addSubview:self.cellPhoneInputView];
    
    [self.scrollBGView addSubview:self.okBtn];
    [self.scrollBGView addSubview:self.downCountBtn];
    
    [self.view setNeedsUpdateConstraints];
    
    self.view.backgroundColor = kWhiteColor;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)initNavgationItem
{
    self.title = @"忘记密码";
    WS(weakSelf);
    [self AddLeftBtn:nil normal:@"icon_back" selected:nil action:^{
        
        [weakSelf BackToLastNavi];
    }];
}

#pragma mark - Getter
- (NSTimer *)timer
{
    if (!_timer) {
        self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTimeDown) userInfo:nil repeats:YES];
    }
    return _timer;
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

- (WeiMiLoginInputView *)cellPhoneInputView
{
    if (!_cellPhoneInputView) {
        
        _cellPhoneInputView = [[WeiMiLoginInputView alloc] init];
        _cellPhoneInputView.delegate = self;
        _cellPhoneInputView.title = @"请输入您的手机";
    }
    return _cellPhoneInputView;
}

- (WeiMiLoginInputView *)passWordInputView
{
    if (!_passWordInputView) {
        
        _passWordInputView = [[WeiMiLoginInputView alloc] init];
        _passWordInputView.delegate = self;
        _passWordInputView.keyboardType = UIKeyboardTypeDefault;
        _passWordInputView.secureTextEntry = YES;
        _passWordInputView.title = @"请输入新密码";
    }
    return _passWordInputView;
}

- (WeiMiLoginInputView *)verifyCodeInputView
{
    if (!_verifyCodeInputView) {
        
        _verifyCodeInputView = [[WeiMiLoginInputView alloc] init];
        _verifyCodeInputView.delegate = self;
        _verifyCodeInputView.keyboardType = UIKeyboardTypeNumberPad;
        _verifyCodeInputView.title = @"请填写验证码";
    }
    return _verifyCodeInputView;
}

- (UIButton *)okBtn
{
    if (!_okBtn) {
        _okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _okBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _okBtn.layer.masksToBounds = YES;
        _okBtn.layer.borderColor = HEX_RGB(BASE_COLOR_HEX).CGColor;
        _okBtn.layer.borderWidth = 1.0f;
        _okBtn.layer.cornerRadius = 3.0f;
        [_okBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_okBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        //        [_loginBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_okBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (UIButton *)downCountBtn
{
    if (!_downCountBtn) {
        _downCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _downCountBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _downCountBtn.layer.masksToBounds = YES;
        _downCountBtn.layer.borderColor = kGrayColor.CGColor;
        _downCountBtn.layer.borderWidth = 1.0f;
        _downCountBtn.layer.cornerRadius = 3.0f;
        //        _downCountBtn.backgroundColor = HEX_RGB(BASE_COLOR_HEX);
        [_downCountBtn setTitle:@" 发送验证码 " forState:UIControlStateNormal];
        [_downCountBtn sizeToFit];
        [_downCountBtn setTitleColor:HEX_RGB(BASE_COLOR_HEX) forState:UIControlStateNormal];
        //        [_loginBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"icon_guanzhu"] forState:UIControlStateNormal];
        //        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"little_purple_btn"] forState:UIControlStateSelected];
        [_downCountBtn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _downCountBtn;
}

#pragma mark - actions
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_cellPhoneInputView.inputFiled resignFirstResponder];
    [_verifyCodeInputView.inputFiled resignFirstResponder];
    [_passWordInputView.inputFiled resignFirstResponder];
}

- (void)onBtn:(UIButton *)sender
{
    if (sender == _okBtn) {
        NSString *phoneNum = _cellPhoneInputView.inputFiled.text;
        NSString *verifyCode = _verifyCodeInputView.inputFiled.text;
        NSString *pwd = _passWordInputView.inputFiled.text;
        if (![NSString isNullOrEmpty:phoneNum] && ![NSString isNullOrEmpty:pwd] && ![NSString isNullOrEmpty:verifyCode]) {
            
            [self forgetPWDPhone:phoneNum password:pwd verifyCode:verifyCode];
            
        }else
        {
            [self presentSheet:@"请将信息填写完整！"];
        }
        
    }else if (sender == _downCountBtn)
    {
        if (!_cellPhoneInputView || ![_cellPhoneInputView.inputFiled.text isValidMobile]) {
            [self presentSheet:@"请输入正确的电话号码"];
            return;
        }
        //发送验证码
        [self getVerifyCode:_cellPhoneInputView.inputFiled.text];
    }
}

- (void)updateTimeDown
{
    if (_downTime != 0) {
        _downTime --;
        [_downCountBtn setUserInteractionEnabled:NO];
        [_downCountBtn setTitle:[NSString stringWithFormat:@"等待%ld秒", _downTime] forState:UIControlStateNormal];
    }
    else
    {
        if (_timer.isValid) {
            [self.timer invalidate];
            [_downCountBtn setUserInteractionEnabled:YES];
            [_downCountBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        }
    }
}

#pragma mark - NetWork
//--------获取验证码
- (void)getVerifyCode:(NSString *)phone
{
    WeiMiCheckExistRequest *request = [[WeiMiCheckExistRequest alloc] initWithMemberId:phone];
    
    WeiMiPassWorldRequest *getCodeRequest = [[WeiMiPassWorldRequest alloc] initWithMemberId:phone];
    WS(weakSelf);
    
    YTKChainRequest *chainRequest = [[YTKChainRequest alloc] init];
    [chainRequest addRequest:request callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
        SS(strongSelf);
        WeiMiCheckExistRequest *req = (WeiMiCheckExistRequest *)baseRequest;
        NSString *result = EncodeStringFromDic(req.responseJSONObject, @"result");
        if ([result isEqualToString:@"1"]) {
            
            //开启倒计时
            if (_downTime == 0) {
                _downTime = 60;
                [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
            }
            //发送获取验证码请求
            [chainRequest addRequest:getCodeRequest callback:^(YTKChainRequest * _Nonnull chainRequest, YTKBaseRequest * _Nonnull baseRequest) {
                WeiMiPassWorldRequest *req = (WeiMiPassWorldRequest *)baseRequest;
                NSString *result = EncodeStringFromDic(req.responseJSONObject, @"result");
                
                if (result) {
                    [self presentSheet:@"发送成功"];
                }else
                {
                    [strongSelf presentSheet:@"发送失败"];
                }
            }];
        }
    }];
    
    chainRequest.delegate = self;
    // start to send request
    [chainRequest start];
}

//----忘记密码
- (void)forgetPWDPhone:(NSString *)phone password:(NSString *)password verifyCode:(NSString *)code
{
    WeiMiChangePassWordRequest *request = [[WeiMiChangePassWordRequest alloc] initWithMemberId:phone password:password verifyCode:code];
    request.showHUD = YES;
    WS(weakSelf);
    
    [request startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SS(strongSelf);
        NSString *result = EncodeStringFromDic(request.responseJSONObject, @"result");
        if ([result compare:@"1"] == NSOrderedSame) {
            //            strongSelf.verifyCodeInputView.inputFiled.text = result;
            [strongSelf presentSheet:@"修改成功" complete:^{
                [strongSelf BackToLastNavi];

            }];
        }else
        {
            [strongSelf presentSheet:@"修改失败,请输入"];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        //        [self presentSheet:[NSString stringWithFormat:@"faild: %ld -- %@", request.responseStatusCode, request.responseString]];
        
    }];
}


#pragma mark - YTKChainRequest Delegate
- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    // all requests are done
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
}

#pragma mark - Constraints
- (void)viewDidLayoutSubviews
{
    _scrollBGView.contentSize = CGSizeMake(SCREEN_WIDTH,  SCREEN_HEIGHT);
    
    [super viewDidLayoutSubviews];
}
- (void)updateViewConstraints
{
    [_passWordInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.mas_equalTo(_verifyCodeInputView);
        make.left.mas_equalTo(60);
        //        make.right.mas_equalTo(-60);
        make.width.mas_equalTo(_verifyCodeInputView);
        make.top.mas_equalTo(SCREEN_HEIGHT/2 - STATUS_BAR_HEIGHT -NAV_HEIGHT);
        make.height.mas_equalTo(25);
    }];
    
    [_verifyCodeInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.mas_equalTo(SCREEN_WIDTH/2);
        make.left.mas_equalTo(60);
        make.width.mas_equalTo(SCREEN_WIDTH - 120);
        make.bottom.mas_equalTo(_passWordInputView.mas_top).offset(-25);
        make.height.mas_equalTo(25);
    }];
    
    [_cellPhoneInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //        make.centerX.mas_equalTo(_verifyCodeInputView);
        make.left.mas_equalTo(60);
        make.width.mas_equalTo(_verifyCodeInputView);
        make.bottom.mas_equalTo(_verifyCodeInputView.mas_top).offset(-25);
        make.height.mas_equalTo(25);
    }];
    
    [_okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(_passWordInputView.mas_bottom).offset(50);
        make.centerX.mas_equalTo(_verifyCodeInputView);
        make.size.mas_equalTo(CGSizeMake(GetAdapterHeight(SCREEN_WIDTH - 90), 32));
    }];
    
    [_downCountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.mas_equalTo(_verifyCodeInputView);
        make.height.mas_equalTo( 29);
        make.width.mas_greaterThanOrEqualTo(GetAdapterHeight(80));
    }];
    
    [super updateViewConstraints];
}

@end
