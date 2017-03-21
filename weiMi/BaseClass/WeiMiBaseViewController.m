//
//  WeiMiBaseViewController.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseViewController.h"
#import "WeiMiSystemInfo.h"
#import "WeiMiCategory.h"
#import "WeiMiTimeQueue.h"
#import "UINavigationController+StatuBarStyle.h"
#import "WeiMiBaseNavigationControllerDelegate.h"

typedef void (^btnAction)(void);

@class WeiMiMyVC;
@class WeiMiShoppingCartVC;
@class WeiMiHomePageVC;
@class WeiMiCommunityVC;
@interface WeiMiBaseViewController()<UINavigationControllerDelegate>
{
    btnAction leftBtnAction;
    btnAction rightBtnAction;
    btnAction refreshBtnAction;
}

//@property (nonatomic,strong) UIBarButtonItem * backBtn;

@end

@implementation WeiMiBaseViewController

/** router 初始化方法*/
- (id)initWithRouterParams:(NSDictionary *)params {

    if (self =  [self init]) {
        self.params = [NSDictionary dictionaryWithDictionary:params];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        //common settings
        self.hasNav = YES;
        self.hasTabBar = NO;
        self.needLogin = NO;
        
        if (IOS7_OR_LATER)
        {
            self.edgesForExtendedLayout = UIRectEdgeAll;
            self.extendedLayoutIncludesOpaqueBars = NO;
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationController.delegate = self;
    
    if (CGRectEqualToRect(self.contentFrame, CGRectZero))
    {
        
    }else
    {
        self.view.bounds = self.contentFrame;
    }
    self.contentView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    //    [self.contentView addSubview:self.backImageView];
//    self.navigationItem.leftBarButtonItem = self.backBtn;
//    self.navigationItem.hidesBackButton = YES;
    [self initNavgationItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_popWithBaseNavColor) {
        [self initNavgationItem];
    }
}

- (void)initNavgationItem
{
    //子类复写
    // navBar颜色设置为灰 statusBar前景色设置为黑色
    [self.navigationController.navigationBar setBarTintColor:HEX_RGB(SEC_COLOR_HEX)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor}];
    [self setNeedsStatusBarAppearanceUpdate];
    /** 
     在需要改变状态栏的VC 重写该语句 改变状态栏样式
     -(UIStatusBarStyle)preferredStatusBarStyle
     {
     return UIStatusBarStyleLightContent;
     }
     */
}

- (UIButton *)leftBaseBtn
{
    if (!_leftBaseBtn) {
        _leftBaseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    }
    return _leftBaseBtn;
}

- (UIButton *)righBasetBtn
{
    if (!_righBasetBtn) {
        _righBasetBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_righBasetBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
//        _righBasetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _righBasetBtn;
}


- (UIButton *)rightSecondBtn
{
    if (!_rightSecondBtn) {
        _rightSecondBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        [_rightSecondBtn setTitleColor:kBlackColor forState:UIControlStateNormal];
        //        _righBasetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rightSecondBtn;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[WeiMiTimeQueue sharedInstance] cancelTimerOfTarget:self];
    self.navigationController.delegate = nil;
}


- (BOOL)controllerWillPopHandler
{
    return YES;
}

#pragma mark -
#pragma mark property

-(UIImageView *)backImageView
{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _backImageView.image = [UIImage imageWithColor:[UIColor whiteColor]];
    }
    return _backImageView;
}

- (WeiMiBaseView *)contentView
{
    if (!_contentView)
    {
        _contentView = [[WeiMiBaseView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

#pragma mark -
#pragma mark utils
- (void)BackToLastNavi
{
//    if (_popWithBaseNavColor) {
//        [self.navigationController.navigationBar setBarTintColor:HEX_RGB(BASE_COLOR_HEX)];
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

//overflow加载框方法
- (void)displayOverFlowActivityView
{
    [self displayOverFlowActivityView:L(@"Loading...")];
}

- (void)displayOverFlowActivityView:(NSString *)indiTitle
{
    [self displayOverFlowActivityView:indiTitle maxShowTime:3];
}

- (void)displayOverFlowActivityView:(NSString *)indiTitle maxShowTime:(CGFloat)time
{
    
    
    [self.view showIndicatorHUD:indiTitle];
    
    if (time > 0)
    {
        [[WeiMiTimeQueue sharedInstance] scheduleTimeWithInterval:time*1.5 target:self sel:@selector(removeOverFlowActivityView) repeat:NO];
    }
    else
    {
        [[WeiMiTimeQueue sharedInstance] cancelTimerOfTarget:self sel:@selector(removeOverFlowActivityView)];
    }
    
    _isHudDisplaying = YES;
}


- (void)removeOverFlowActivityView
{
    if (_isHudDisplaying == YES)
    {
        [self.view hideIndicatorHUD];
        [[WeiMiTimeQueue sharedInstance] cancelTimerOfTarget:self sel:@selector(removeOverFlowActivityView)];
        _isHudDisplaying = NO;
    }
}


//文字提示
- (void)presentSheet:(NSString*)indiTitle
{
    [self.view showTextHUD:indiTitle];
    
    //每个字0.3s, 最低3秒
    CGFloat showTime = MAX([indiTitle length] * 0.1, 1);
    //    CGFloat showTime = 3;
    [[WeiMiTimeQueue sharedInstance] scheduleTimeWithInterval:showTime target:self sel:@selector(removeSheetView) repeat:NO];
}


- (void)presentSheet:(NSString*)indiTitle posY:(CGFloat)y
{
    [self.view showTextHUD:indiTitle yOffset:y-self.view.bounds.size.height/2];
    
    //每个字0.3s, 最低3秒
    CGFloat showTime = MAX([indiTitle length] * 0.2, 2);
    [[WeiMiTimeQueue sharedInstance] scheduleTimeWithInterval:showTime target:self sel:@selector(removeSheetView) repeat:NO];
}


- (void)presentSheet:(NSString *)indiTitle
            complete:(WeiMiBasicBlock)callBack
{
    sheetCallBack_ = callBack;
    [self.view showTextHUD:indiTitle];
    //每个字0.3s, 最低3秒
    CGFloat showTime = MAX([indiTitle length] * 0.3, 3);
    [[WeiMiTimeQueue sharedInstance] scheduleTimeWithInterval:showTime target:self sel:@selector(removeSheetView) repeat:NO];
}

- (void)removeSheetView
{
    if (sheetCallBack_)
    {
        sheetCallBack_();
        sheetCallBack_ = nil;
    }
    [self.view hideTextHUD];
    [[WeiMiTimeQueue sharedInstance] cancelTimerOfTarget:self sel:@selector(removeSheetView)];
}
//utils
- (CGRect)visibleBoundsShowNav:(BOOL)hasNav showTabBar:(BOOL)hasTabBar
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    
    if (UIInterfaceOrientationIsLandscape(orientation))
    {
        frame = CGRectMake(0, 0, frame.size.height, frame.size.width);
    }
    else if (UIInterfaceOrientationIsPortrait(orientation))
    {
        frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    }
    
    if (IOS7_OR_LATER)
    {
        //frame is full screen
        frame.size.height -= STATUS_BAR_HEIGHT;
        frame.origin.y += STATUS_BAR_HEIGHT;
        if (hasNav) {
            frame.size.height -= NAV_HEIGHT;
            frame.origin.y += NAV_HEIGHT;
        }
        if (hasTabBar) {
            frame.size.height -= TAB_BAR_HEIGHT;
        }
    }
    else
    {
        frame.size.height -= STATUS_BAR_HEIGHT;
        if (hasNav) {
            frame.size.height -= NAV_HEIGHT;
        }
        if (hasTabBar) {
            frame.size.height -= TAB_BAR_HEIGHT;
        }
    }
    
    return frame;
}

-(void)processWarning:(NSString *)errorCode Message:(NSString *) message
{
    //    if ([self isSessionTimeout:errorCode]) {
    //        [self processSessionTimeout];
    //    }
    //    else
    //    {
    //        [self presentSheet:message];
    //    }
    [self presentSheet:message];
}

- (AppDelegate *)APP
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

#pragma mark - NavigationBar相关
//添加左菜单，设置前景图
- (void)AddLeftBtn:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action
{
    if (!self.navigationController) return;
    if (!selected && normal) {
        [self setBtnImage:self.leftBaseBtn title:title normal:normal selected:normal action:action isLeft:YES];
        return;
    }
    [self setBtnImage:self.leftBaseBtn title:title normal:normal selected:selected action:action isLeft:YES];
}

//添加右菜单，设置前景图
- (void)AddRightBtn:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action
{
    if (!self.navigationController) return;
    [self setBtnImage:self.righBasetBtn title:title normal:normal selected:selected action:action isLeft:NO];
}
//添加左菜单，设置背景图
- (void)AddLeftBtnBacground:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action
{
    if (!self.navigationController) return;
    [self setBtnBackgroundImage:self.leftBaseBtn title:title normal:normal selected:selected action:action isLeft:YES];
}
//添加右菜单，设置背景图
- (void)AddRightBtnBacground:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action
{
    if (!self.navigationController) return;
    [self setBtnBackgroundImage:self.righBasetBtn title:title normal:normal selected:selected action:action isLeft:NO];
}

//添加右二级菜单，设置前背景图
- (void)AddSecondRightBtnAction:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action
{
    if (!self.navigationController) return;
//    [self setBtnImage:self.navigationController.btnSecondRight title:title normal:normal selected:selected action:action isLeft:NO];
    
    [self.rightSecondBtn setTitle:title forState:UIControlStateNormal];
    _rightSecondBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_rightSecondBtn sizeToFit];
    [_rightSecondBtn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [_rightSecondBtn setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [_rightSecondBtn setImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];
    
    [self setBtnAction:_rightSecondBtn action:action isLeft:NO];
    _rightSecondBtn.hidden = NO;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightSecondBtn];
    UIBarButtonItem *buttonItem2 = self.navigationItem.rightBarButtonItem;
    
    self.navigationItem.rightBarButtonItems = @[buttonItem2, buttonItem];
}

- (void)setBtnImage:(UIButton*) btn title:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action isLeft:(BOOL)isLeft
{

    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn sizeToFit];
    [btn setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [btn setImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];

    [self setBtnAction:btn action:action isLeft:isLeft];
    btn.hidden = NO;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = buttonItem;

    }else
    {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}

- (void)setBtnBackgroundImage:(UIButton*) btn title:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action  isLeft:(BOOL)isLeft
{
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateSelected];
    [btn setBackgroundImage:[UIImage imageNamed:selected] forState:UIControlStateHighlighted];
    [self setBtnAction:btn action:action isLeft:isLeft];
    btn.hidden = NO;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    if (isLeft) {
        self.navigationItem.leftBarButtonItem = buttonItem;
    }else
    {
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
}

- (void)setBtnAction:(UIButton*) btn action:(void (^)(void))action isLeft:(BOOL)isLeft
{
    if (isLeft)
    {
        leftBtnAction = nil;
        leftBtnAction = [action copy];
        [btn addTarget:self action:@selector(btnLeftClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        rightBtnAction = nil;
        rightBtnAction = [action copy];
        [btn addTarget:self action:@selector(btnRightClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - NavgationButtonActions
- (void)btnLeftClick:(id)sender
{
    if (leftBtnAction)
        leftBtnAction();
}

- (void)btnRightClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (rightBtnAction)
        rightBtnAction();
}

@end
