//
//  AppDelegate.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Routable.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) Routable *mineRouter;
@property (nonatomic, strong) Routable *homeRouter;
@property (nonatomic, strong) Routable *communityRouter;

@end

