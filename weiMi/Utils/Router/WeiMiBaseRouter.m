//
//  WeiMiBaseRouter.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRouter.h"

@implementation WeiMiBaseRouter

- (void)skipIntoVC:(NSString *)vc params:(NSDictionary *)dic
{
    
}

- (void)presentIntoVC:(NSString *)vc params:(NSDictionary *)dic
{
    
}

- (void)intoVC:(NSString *)vc params:(NSDictionary *)dic options:(UPRouterOptions *)options 
{
    
}

- (AppDelegate *)APP
{
    return (AppDelegate *)([UIApplication sharedApplication].delegate);
}

- (void)callBackToVC:(NSString *)vc params:(NSDictionary *)dic
{
    
}

- (void)skipIntoVC:(NSString *)vc
{
    
}

- (NSString *)configCallBack:(NSString *)vc params:(NSArray *)arr
{
    NSMutableString *string = [[NSMutableString alloc] initWithString:vc];
    if (!arr.count) {
        return [vc stringByAppendingString:@"/id"];
    }
    for (NSString *key in arr) {
        [string appendString:[NSString stringWithFormat:@"/%@", key]];
    }
    return string;
}


@end
