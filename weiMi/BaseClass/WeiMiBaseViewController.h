//
//  WeiMiBaseViewController.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WeiMiConstant.h"
#import "WeiMiBaseView.h"
#import "AppDelegate.h"

@interface WeiMiBaseViewController : UIViewController
{
    WeiMiBasicBlock   sheetCallBack_;
@private
    BOOL                          _isHudDisplaying;
}
/*** 左右按钮*/
@property (nonatomic, strong) UIButton *leftBaseBtn;
@property (nonatomic, strong) UIButton *righBasetBtn;
@property (nonatomic, strong) UIButton *rightSecondBtn;

@property (nonatomic, assign) BOOL  hasNav;
@property (nonatomic, assign) BOOL  hasTabBar;
@property (nonatomic, assign) BOOL  needLogin;
@property (nonatomic, strong) NSDictionary *params;
@property (nonatomic, assign) CGRect  contentFrame;
@property (nonatomic, strong) WeiMiBaseView *contentView;
@property (nonatomic, strong) UIImageView * backImageView;
/** 视图消失时候是否回复成app主色调 默认NO */
@property (nonatomic, assign) BOOL popWithBaseNavColor;
- (void)BackToLastNavi;

- (void)initNavgationItem;
//控制popVC
- (BOOL)controllerWillPopHandler;
- (AppDelegate *)APP;
//添加左菜单，设置前景图
- (void)AddLeftBtn:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action;
//添加右菜单，设置前景图
- (void)AddRightBtn:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action;
//添加左菜单，设置背景图
- (void)AddLeftBtnBacground:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action;
//添加右菜单，设置背景图
- (void)AddRightBtnBacground:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action;

//添加二级右菜单，设置前景图
- (void)AddSecondRightBtnAction:(NSString*) title normal:(NSString*)normal selected:(NSString*)selected action:(void (^)(void))action;

//overflow加载框方法
- (void)displayOverFlowActivityView;
- (void)displayOverFlowActivityView:(NSString *)indiTitle maxShowTime:(CGFloat)time;
- (void)removeOverFlowActivityView;

//文字提示
- (void)presentSheet:(NSString *)indiTitle;
- (void)presentSheet:(NSString *)indiTitle posY:(CGFloat)y;

- (void)presentSheet:(NSString *)indiTitle
            complete:(WeiMiBasicBlock)callBack;

//utils
- (CGRect)visibleBoundsShowNav:(BOOL)hasNav showTabBar:(BOOL)hasTabBar;
-(void)processWarning:(NSString *)errorCode Message:(NSString *) message;

@end
