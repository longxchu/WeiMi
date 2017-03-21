//
//  WeiMiCommunityRouter.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiCommunityRouter.h"

@implementation WeiMiCommunityRouter

- (void)skipIntoVC:(NSString *)vc
{
    [self.APP.communityRouter map:vc toController:NSClassFromString(vc)];
    [self.APP.communityRouter open:vc];
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
    [self.APP.communityRouter map:vc toController:NSClassFromString(vc) withOptions:options];
    [self.APP.communityRouter open:vc];
}

- (void)configCallBack:(NSString *)vc block:(RouterOpenCallback)callBack
{
    [self.APP.communityRouter map:vc toCallback:callBack];
}

- (void)callBackToVC:(NSString *)vc params:(NSArray *)arr
{
    [self.APP.communityRouter open:[self configCallBack:vc params:arr]];
}

@end
