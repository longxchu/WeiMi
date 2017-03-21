//
//  WeiMiBaseNavigationController.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseNavigationController.h"
//#import <UINavigationController+FDFullscreenPopGesture.h>
#import "WeiMiBaseNavigationControllerDelegate.h"
#import "WeiMiBaseViewController.h"

@interface UINavigationController(UINavigationControllerNeedshouldPopItem)
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;
@end

@interface WeiMiBaseNavigationController()<UIGestureRecognizerDelegate>

@end

@implementation WeiMiBaseNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [self.navigationBar setBarTintColor:HEX_RGB(BASE_COLOR_HEX)];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    self.navigationController.fd_interactivePopDisabled = NO;
    self.interactivePopGestureRecognizer.delegate = self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    
    WeiMiBaseViewController *vc = [self topViewController];
    
    if ([vc respondsToSelector:@selector(controllerWillPopHandler)])
    {
        if ([vc performSelector:@selector(controllerWillPopHandler)])
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
{

    WeiMiBaseViewController *vc = [self valueForKeyPath:@"disappearingViewController"];
    
    if (vc.popWithBaseNavColor) {
        [self.navigationBar setBarTintColor:HEX_RGB(BASE_COLOR_HEX)];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    }
    
    if ([vc respondsToSelector:@selector(controllerWillPopHandler)])
    {
        if ([vc performSelector:@selector(controllerWillPopHandler)])
        {
            return [super navigationBar:navigationBar shouldPopItem:item];
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return [super navigationBar:navigationBar shouldPopItem:item];
    }
}


#pragma mark - 单个页面转屏支持
//-(BOOL)shouldAutorotate
//{
//    return YES;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    for (UIViewController *vc in self.viewControllers) {
//        
//        // 如果是 YinzhiVideoViewController 则需要支持转屏
//        if ([vc isKindOfClass:NSClassFromString(@"YinzhiVideoViewController")]) {
//            
//            return UIInterfaceOrientationMaskAllButUpsideDown;
//        }
//    }
//    
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
//{
//    return UIInterfaceOrientationPortrait;
//}

@end
