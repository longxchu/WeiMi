//
//  WeiMiMainViewController.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMainViewController.h"
#import "WeiMiBaseNavigationController.h"
#import "WeiMiHomePageVC.h"
#import "WeiMiCommunityVC.h"
#import "WeiMiShoppingCartVC.h"
#import "WeiMiMyVC.h"
#import "AppDelegate.h"
#import "WeiMiComponentRegister.h"
#import "WeiMiLogInVC.h"

@interface WeiMiMainViewController()<UITabBarControllerDelegate>

@property (nonatomic, strong) WeiMiHomePageVC *homeVC;
@property (nonatomic, strong) WeiMiCommunityVC *communityVC;
@property (nonatomic, strong) WeiMiShoppingCartVC *shoppingCartVC;
@property (nonatomic, strong) WeiMiMyVC *myVC;

@end

@implementation WeiMiMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    WeiMiBaseNavigationController *navHomePage = [[WeiMiBaseNavigationController alloc] initWithRootViewController:self.homeVC];
    WeiMiBaseNavigationController *navCommunity = [[WeiMiBaseNavigationController alloc] initWithRootViewController:self.communityVC];
    WeiMiBaseNavigationController *navShoppingCart  = [[WeiMiBaseNavigationController alloc] initWithRootViewController:self.shoppingCartVC];
    WeiMiBaseNavigationController *navMy  = [[WeiMiBaseNavigationController alloc] initWithRootViewController:self.myVC];
    self.viewControllers = @[navHomePage, navCommunity, navShoppingCart, navMy];
    [self.tabBar setTintColor:HEX_RGB(BASE_COLOR_HEX)];
    [self setSelectedViewController:navHomePage];
    
    AppDelegate *delegate = (AppDelegate *)([UIApplication sharedApplication].delegate);
    [delegate.mineRouter setNavigationController:navMy];
    NSDictionary *mineDic = [WeiMiComponentRegister mineDic];
    for (NSString *key in mineDic.allKeys) {
        [delegate.mineRouter map:mineDic[key] toController:NSClassFromString(key)];
    }
    
    [delegate.homeRouter setNavigationController:navHomePage];
    NSDictionary *homeDic = [WeiMiComponentRegister homeDic];
    for (NSString *key in homeDic.allKeys) {
        [delegate.homeRouter map:homeDic[key] toController:NSClassFromString(key)];
    }
    
    [delegate.communityRouter setNavigationController:navCommunity];
    NSDictionary *communityDic = [WeiMiComponentRegister communityDic];
    for (NSString *key in communityDic.allKeys) {
        [delegate.communityRouter map:communityDic[key] toController:NSClassFromString(key)];
    }
    
}

#pragma mark - Getter
- (WeiMiHomePageVC *)homeVC
{
    if (!_homeVC) {
        _homeVC = [[WeiMiHomePageVC alloc] init];
        _homeVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                           image:[UIImage imageNamed:@"icon_home"]
                                                   selectedImage:[UIImage imageNamed:@"icon_home_pre"]];
        [self unSelectedTapTabBarItems:_homeVC.tabBarItem];//未点击字体属性
        [self selectedTapTabBarItems:_homeVC.tabBarItem];//点击字体属性
        
    }
    return _homeVC;
}

- (WeiMiCommunityVC *)communityVC
{
    if (!_communityVC) {
        _communityVC = [[WeiMiCommunityVC alloc] init];
        _communityVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"社区"
                                                                image:[UIImage imageNamed:@"icon_life"]
                                                        selectedImage:[UIImage imageNamed:@"icon_life_pre"]];
        [self unSelectedTapTabBarItems:_communityVC.tabBarItem];//未点击字体属性
        [self selectedTapTabBarItems:_communityVC.tabBarItem];//点击字体属性
        
    }
    return _communityVC;
}

- (WeiMiShoppingCartVC *)shoppingCartVC
{
    if (!_shoppingCartVC) {
        _shoppingCartVC = [[WeiMiShoppingCartVC alloc] init];
        _shoppingCartVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"购物车"
                                                                image:[UIImage imageNamed:@"icon_shopping"]
                                                        selectedImage:[UIImage imageNamed:@"icon_shopping_pre"]];
        [self unSelectedTapTabBarItems:_shoppingCartVC.tabBarItem];//未点击字体属性
        [self selectedTapTabBarItems:_shoppingCartVC.tabBarItem];//点击字体属性
    }
    return _shoppingCartVC;
}

- (WeiMiMyVC *)myVC
{
    if (!_myVC) {
        _myVC = [[WeiMiMyVC alloc] init];
        _myVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的"
                                                                image:[UIImage imageNamed:@"icon_mine"]
                                                        selectedImage:[UIImage imageNamed:@"icon_mine_pre"]];
        [self unSelectedTapTabBarItems:_myVC.tabBarItem];//未点击字体属性
        [self selectedTapTabBarItems:_myVC.tabBarItem];//点击字体属性
    }
    return _myVC;
}

#pragma mark - 
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    
}

- (BOOL)tabBarController:(UITabBarController*)tabBarController shouldSelectViewController:(UIViewController*)viewController
{
    if (viewController == tabBarController.viewControllers[2] && ![[WeiMiUserCenter sharedInstance] isLogin]) {//判断是否登陆
        
        WeiMiLogInVC *vc = [[WeiMiLogInVC alloc] init];
        WeiMiBaseNavigationController *nav = [[WeiMiBaseNavigationController alloc] initWithRootViewController:vc];
        [((UINavigationController *)tabBarController.selectedViewController) presentViewController:nav animated:YES completion:nil];
        
        //在登陆界面判断登陆成功之后发送通知,将所选的TabbarItem传回,使用通知传值
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logSelect:) name:LOG_SELECT object:nil];     //接收
        return NO;
    }
    return YES;
}

- (void)logSelect:(NSNotification *)text{
    NSLog(@"=====%ld", [text.object integerValue]);
    self.selectedIndex = [text.object integerValue];
}


#pragma mark - 通用方法
/**
 *  未点击字体属性
 */
-(void)unSelectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:11],
                                        NSFontAttributeName,
                                        HEX_RGB(0x6b6b6b),
                                        NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateNormal];
}

/**
 *  点击字体属性
 */
-(void)selectedTapTabBarItems:(UITabBarItem *)tabBarItem
{
    [tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont systemFontOfSize:11],
                                        NSFontAttributeName,HEX_RGB(BASE_COLOR_HEX),
                                        NSForegroundColorAttributeName,
                                        nil] forState:UIControlStateSelected];
}


@end
