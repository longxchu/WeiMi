//
//  UIView+WeiMiHUD.h
//  app
//
//  Created by Ning Gang on 16/6/1.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (WeiMiHUD)

- (void)showIndicatorHUD:(NSString *)indiTitle;
- (void)showIndicatorHUD:(NSString *)indiTitle yOffset:(CGFloat)y;
- (void)hideIndicatorHUD;
- (MBProgressHUD *)getIndicatorHUD;

- (void)showTextHUD:(NSString *)text;
- (void)showTextHUD:(NSString *)text yOffset:(CGFloat)y;
- (void)hideTextHUD;
- (MBProgressHUD *)getTextHUD;

@end
