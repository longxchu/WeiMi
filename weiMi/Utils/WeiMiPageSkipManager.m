//
//  WeiMiPageSkipManager.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPageSkipManager.h"
#import "WeiMiPersonInfoVC.h"
#import "WeiMiSettingVC.h"
#import "WeiMiMessageSetting.h"
#import "WeiMiCreditShopVC.h"
#import "WeiMiMyGiftVC.h"
#import "WeiMiMyCollectionVC.h"
#import "WeiMiLogInVC.h"
#import "WeiMiRegisterVC.h"
#import "WeiMiInvitationVC.h"
#import "WeiMiRQDetailVC.h"
#import "WeiMiCircleCommentVC.h"
#import "WeiMiWomenWhisperVC.h"
#import "WeiMiCommunityMessageVC.h"
#import "WeiMiWebViewController.h"
#import "WeiMiGoodsDetailVC.h"
#import "WeiMiHomePageChoiceVC.h"
#import "WeiMiUserAgreeController.h"

@implementation WeiMiPageSkipManager

+ (WeiMiMyRouter *)mineRouter
{
    static dispatch_once_t once;

    static WeiMiMyRouter * __mineSingleton__;
    
    dispatch_once(&once, ^{
        __mineSingleton__ = [[WeiMiMyRouter alloc] init];
    });
    return __mineSingleton__;
}

+ (Routable *)mineRT
{
   return [(AppDelegate *)([UIApplication sharedApplication].delegate) mineRouter];
}

+ (WeiMiHomeRouter *)homeRouter
{
    static dispatch_once_t once;
    
    static WeiMiHomeRouter * __homeSingleton__;
    
    dispatch_once(&once, ^{
        __homeSingleton__ = [[WeiMiHomeRouter alloc] init];
    });
    return __homeSingleton__;
}

+ (Routable *)homeRT
{
    return [(AppDelegate *)([UIApplication sharedApplication].delegate) homeRouter];
}

+ (WeiMiCommunityRouter *)communityRouter
{
    static dispatch_once_t once;
    
    static WeiMiCommunityRouter * __communitySingleton__;
    
    dispatch_once(&once, ^{
        __communitySingleton__ = [[WeiMiCommunityRouter alloc] init];
    });
    return __communitySingleton__;
}
+ (Routable *)communityRT
{
    return [(AppDelegate *)([UIApplication sharedApplication].delegate) communityRouter];
}

+ (void)skipIntoPersonalInfoVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiPersonInfoVC *vc = [[WeiMiPersonInfoVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoSettingVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiSettingVC *vc = [[WeiMiSettingVC alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];

}

+ (void)skipIntoMessageSettingVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiMessageSetting *vc = [[WeiMiMessageSetting alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipCommunityMessageSettingVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiCommunityMessageVC *vc = [[WeiMiCommunityMessageVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoCreditShoppingVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiCreditShopVC *vc = [[WeiMiCreditShopVC alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoMyGiftVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiMyGiftVC *vc = [[WeiMiMyGiftVC alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoMyCollectionVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiMyCollectionVC *vc = [[WeiMiMyCollectionVC alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoWebVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title url:(NSString *)url popWithBaseNavColor:(BOOL)pop{
    WeiMiWebViewController *vc = [[WeiMiWebViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.popWithBaseNavColor = pop;
    vc.title = title;
    vc.url = url;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoLoginVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiLogInVC *vc = [[WeiMiLogInVC alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)presentIntoLoginVC:(WeiMiBaseViewController *)selfVC completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0)
{
    WeiMiLogInVC *vc = [[WeiMiLogInVC alloc] init];
    [selfVC.navigationController presentViewController:vc animated:YES completion:completion];
}


+ (void)skipIntoRegisterVC:(WeiMiBaseViewController *)selfVC
{
    WeiMiRegisterVC *vc = [[WeiMiRegisterVC alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoPostDetailVC:(WeiMiBaseViewController *)selfVC dto:(WeiMiBaseDTO *)dto popWithBaseNavColor:(BOOL)pop{
    WeiMiInvitationVC *vc = [[WeiMiInvitationVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.popWithBaseNavColor = pop;
    vc.dto = (WeiMiHotCommandDTO *)dto;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoPostDetailVC:(WeiMiBaseViewController *)selfVC infoId:(NSString *)infoId popWithBaseNavColor:(BOOL)pop{
    WeiMiInvitationVC *vc = [[WeiMiInvitationVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.popWithBaseNavColor = pop;
    vc.infoId = infoId;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoRQDetailVC:(WeiMiBaseViewController *)selfVC dto:(WeiMiBaseDTO *)dto
{
    WeiMiRQDetailVC *vc = [[WeiMiRQDetailVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.dto = (WeiMiMaleFemaleRQDTO *)dto;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoAddCommentVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title sID:(NSString *)sID commentType:(COMMENTTYPE)type
{
    WeiMiCircleCommentVC *vc = [[WeiMiCircleCommentVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.title = title;
    vc.sID = sID;
    vc.commentType = type;
    [selfVC.navigationController pushViewController:vc animated:YES];
    
}

+ (void)skipIntoMaleFemaleVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title navId:(NSString *)navId
{
    WeiMiWomenWhisperVC *VC = [[WeiMiWomenWhisperVC alloc] init];
    VC.title = title;
    VC.navId = navId;
    VC.hidesBottomBarWhenPushed = YES;
    [selfVC.navigationController pushViewController:VC animated:YES];
}

+ (void)skipIntoPannicBuyVCHiddenBottomBar:(BOOL)hide
{
    UPRouterOptions *options = [UPRouterOptions routerOptions];
    options.hidesBottomBarWhenPushed = hide;
    [[WeiMiPageSkipManager homeRouter] intoVC:@"WeiMiPanicBuyContentVC" options:options];
}

+ (void)skipIntoProductDetailVC:(WeiMiBaseViewController *)selfVC productId:(NSString *)productId popWithBaseNavColor:(BOOL)pop hidesBottomBarWhenPushed:(BOOL)hidden
{
    WeiMiGoodsDetailVC *vc = [[WeiMiGoodsDetailVC alloc] init];
    vc.productId = productId;
    vc.popWithBaseNavColor = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoProductListVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title menuId:(NSString *)menuId
{
    WeiMiHomePageChoiceVC *vc = [[WeiMiHomePageChoiceVC alloc] init];
    vc.title = title;
    vc.menuId = menuId;
    vc.hidesBottomBarWhenPushed = YES;
    [selfVC.navigationController pushViewController:vc animated:YES];
}

+ (void)skipIntoUserAgreement:(WeiMiBaseViewController *)selfVC
{
    WeiMiUserAgreeController *vc = [[WeiMiUserAgreeController alloc] init];
    [selfVC.navigationController pushViewController:vc animated:YES];
}
@end
