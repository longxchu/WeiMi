//
//  WeiMiBaseNavigationControllerDelegate.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeiMiBaseNavigationControllerDelegate <NSObject>

@optional
- (BOOL)controllerWillPopHandler;

@end
