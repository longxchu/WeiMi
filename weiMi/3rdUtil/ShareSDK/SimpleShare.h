//
//  SimpleShare.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>

@interface NSMutableDictionary (SimpleShareParamCategory)

@property (nonatomic, strong) UIView *panelView;

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

+ (NSMutableDictionary *)shareParamsWithContent:(NSString *)content title:(NSString *)title link:(NSString *)link images:(NSArray *)imgs;
@end

@interface SimpleShare : NSObject

/** 无UI分享 */
+ (void)shareWithPlatformType:(SSDKPlatformType)platformType shareParams:(NSMutableDictionary *)shareParams response:(SSDKShareStateChangedHandler)handler;

+ (void)showShareActionSheet:(UIView *)view withTitle:(NSString *)title content:(NSString *)content imageUrl:(NSString *)imageUrl linkUrl:(NSString *)linkUrl;

@end
