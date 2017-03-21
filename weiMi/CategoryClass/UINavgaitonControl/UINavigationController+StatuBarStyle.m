//
//  UINavigationController+StatuBarStyle.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/13.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "UINavigationController+StatuBarStyle.h"

@implementation UINavigationController (StatuBarStyle)

- (UIViewController *)childViewControllerForStatusBarStyle
{
   return self.topViewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden
{
    return self.topViewController;
}

@end
