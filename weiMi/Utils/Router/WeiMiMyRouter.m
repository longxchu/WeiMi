//
//  WeiMiMyRouter.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiMyRouter.h"

@implementation WeiMiMyRouter
// callBack:(RouterOpenCallback)callBack

- (void)skipIntoVC:(NSString *)vc
{
    [self.APP.mineRouter map:vc toController:NSClassFromString(vc)];
    [self.APP.mineRouter open:vc];
}

- (void)skipIntoVC:(NSString *)vc params:(NSDictionary *)dic
{
    UPRouterOptions *options = [UPRouterOptions routerOptions];
    options.defaultParams = dic;
    [self intoVC:vc options:options];
}

- (void)presentIntoVC:(NSString *)vc params:(NSDictionary *)dic
{
    UPRouterOptions *options = [[UPRouterOptions modal] withPresentationStyle: UIModalPresentationFormSheet];
    options.defaultParams = dic;
    [self intoVC:vc options:options];
}

- (void)intoVC:(NSString *)vc options:(UPRouterOptions *)options
{
    [self.APP.mineRouter map:vc toController:NSClassFromString(vc) withOptions:options];
    [self.APP.mineRouter open:vc];
}

- (void)configCallBack:(NSString *)vc block:(RouterOpenCallback)callBack
{
    [self.APP.mineRouter map:vc toCallback:callBack];
}

- (void)callBackToVC:(NSString *)vc params:(NSArray *)arr
{
    [self.APP.mineRouter open:[self configCallBack:vc params:arr]];
}


@end
