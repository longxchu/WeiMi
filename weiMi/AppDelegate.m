//
//  AppDelegate.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "AppDelegate.h"
#import "WeiMiMainViewController.h"
#import "YTKNetworkConfig.h"
#import "AFNetworkReachabilityManager.h"
#import "Routable.h"
#import <IQKeyboardManager.h>
#import "UIFont+AdaptiveFont.h"
#import "NetWorkManage.h"  
#import "weimiLauchaController.h"
#import "Lauchs.h"
//------ shareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//微信SDK头文件
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

@interface AppDelegate ()

@property (nonatomic, strong) WeiMiMainViewController *mainControl;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化Router
    [self configRouter];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    //    self.window.rootViewController = self.mainControl;
    [self.window makeKeyAndVisible];
    
    
    //判断程序是否第一次安装启动
    //存储用户的偏好设置
    NSUserDefaults *faults = [NSUserDefaults standardUserDefaults];
    BOOL isFirstLaunch = [faults boolForKey:FIPST];
    //第一次安装启动时  加载用户引导页
    if (isFirstLaunch == NO) {
        //一旦发现为NO  说明程序第一次启动 之前没有存储过，指定lanch为window的根视图控制器
        weimiLauchaController *lanch = [[weimiLauchaController alloc]init];
        self.window.rootViewController = lanch;
    } else {
        //如果不是第一次安装运行，则指定主界面视图控制器为windiw的根视图控制器
        WeiMiMainViewController *mainVC = [[WeiMiMainViewController alloc]init];
        self.window.rootViewController = mainVC;
        
    }
    
    
    //监控网络状态
    //[[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[NetWorkManage sharedInstance] startNetWorkeWatch:@"www.baidu.com"];
    
    //键盘管理
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    //全局字体适应
    [UIFont hook];
    //初始化YTK配置
    [self initTYKConfig];
    //分享配置
    [self share_registerApp];
    
    [NSThread sleepForTimeInterval:1.5];//设置启动页面时间
    //[self checkNetWork];
    
    return YES;

}


#pragma mark - 检测网络
- (void)checkNetWork
{
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
    //根据不同的网络状态改变去做相应处理
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self alert:@"正在使用2G/3G/4G 网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self alert:@"WiFi网络已连接"];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self alert:@"WiFi网络已断开"];
                break;

            default:
                [self alert:@"Unknown"];
                break;
        }
    }];

    //开始监控
    [reachabilityManager startMonitoring];
}

#pragma mark 网络状态变化提示
-(void)alert:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return YES;
}


#pragma mark - Getter
- (WeiMiMainViewController *)mainControl
{
    if (!_mainControl) {
        _mainControl = [[WeiMiMainViewController alloc] init];
    }
    return _mainControl;
}

- (void)configRouter
{
    self.mineRouter = [Routable newRouter];
    self.homeRouter = [Routable newRouter];
    self.communityRouter = [Routable newRouter];
}

#pragma mark - YTKInit
- (void)initTYKConfig
{
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = BASE_URL;
    config.cdnUrl = BASE_URL;
}

#pragma mark - reigsterShareSDK
-(void)share_registerApp{
    [ShareSDK registerApp:@"194bd9a2011e0" activePlatforms:@[
                                                             @(SSDKPlatformTypeWechat),
                                                             @(SSDKPlatformSubTypeWechatSession),
                                                             @(SSDKPlatformSubTypeWechatTimeline)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType)
                     {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         default:
                             break;
                     }

     } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
             case SSDKPlatformSubTypeWechatSession:
             case SSDKPlatformSubTypeWechatTimeline:
                 [appInfo SSDKSetupWeChatByAppId:WEIXIN_AppID
                                       appSecret:WEIXIN_AppSecret];
                 break;
             default:
                 break;
         }

     }];
}
-(void)onResp:(BaseResp *)resp
{
    NSLog(@"The response of wechat.");
}
@end
