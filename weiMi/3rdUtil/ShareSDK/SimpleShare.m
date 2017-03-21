//
//  SimpleShare.m
//  weiMi
//
//  Created by 梁宪松 on 2016/11/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "SimpleShare.h"

@implementation NSMutableDictionary (SimpleShareParamCategory)

+ (NSMutableDictionary *)shareParamsWithContent:(NSString *)content title:(NSString *)title link:(NSString *)link images:(NSArray *)imgs
{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imgs
                                        url:[NSURL URLWithString:link]
                                      title:title
                                       type:SSDKContentTypeAuto];
    return shareParams;
}
@end

@implementation SimpleShare


+ (void)shareWithPlatformType:(SSDKPlatformType)platformType shareParams:(NSMutableDictionary *)shareParams response:(SSDKShareStateChangedHandler)handler {
    [ShareSDK share:platformType parameters:shareParams onStateChanged:handler];
}
+ (void)showShareActionSheet:(UIView *)view withTitle:(NSString *)title content:(NSString *)content imageUrl:(NSString *)imageUrl linkUrl:(NSString *)linkUrl {
    NSURL *url = nil;
    if(linkUrl != nil){
        url = [NSURL URLWithString:linkUrl];
    }else {
        url = [NSURL URLWithString:@"www.baidu.com"];
    }
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content images:@[imageUrl] url:url title:title type:SSDKContentTypeImage | SSDKContentTypeText];
    
    SSUIShareActionSheetCustomItem *copyItem = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"copy"] label:@"复制链接" onClick:^{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:linkUrl ? linkUrl : @"www.baidu.com"];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"复制成功"
                                                            message:nil
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:@[@(SSDKPlatformTypeWechat),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatFav)]];
    [activePlatforms addObject:copyItem];
    [ShareSDK showShareActionSheet:view items:activePlatforms shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin:{
                break;
            }
            case SSDKResponseStateSuccess:{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SSDKResponseStateCancel:
                break;
            default:
                break;
        }
    }];
}

@end
