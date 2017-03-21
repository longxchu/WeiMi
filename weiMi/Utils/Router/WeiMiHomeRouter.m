//
//  WeiMiHomeRouter.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiHomeRouter.h"

@implementation WeiMiHomeRouter

- (void)skipIntoVC:(NSString *)vc
{
    [self.APP.homeRouter map:vc toController:NSClassFromString(vc)];
    [self.APP.homeRouter open:vc];
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
    [self.APP.homeRouter map:vc toController:NSClassFromString(vc) withOptions:options];
    [self.APP.homeRouter open:vc];
}

- (void)configCallBack:(NSString *)vc block:(RouterOpenCallback)callBack
{
    [self.APP.homeRouter map:vc toCallback:callBack];
}

- (void)callBackToVC:(NSString *)vc params:(NSArray *)arr
{
    [self.APP.homeRouter open:[self configCallBack:vc params:arr]];
}


@end
