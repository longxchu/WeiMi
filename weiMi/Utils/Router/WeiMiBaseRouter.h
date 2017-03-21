//
//  WeiMiBaseRouter.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiMiBaseRouter : NSObject

- (AppDelegate *)APP;

- (void)skipIntoVC:(NSString *)vc params:(NSDictionary *)dic;
- (void)presentIntoVC:(NSString *)vc params:(NSDictionary *)dic;

- (void)callBackToVC:(NSString *)vc params:(NSArray *)arr;
- (void)configCallBack:(NSString *)vc block:(RouterOpenCallback)callBack;

- (void)skipIntoVC:(NSString *)vc;

- (NSString *)configCallBack:(NSString *)vc params:(NSArray *)arr;

- (void)intoVC:(NSString *)vc options:(UPRouterOptions *)options;

@end
