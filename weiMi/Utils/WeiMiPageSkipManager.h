//
//  WeiMiPageSkipManager.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiMiBaseViewController.h"
#import "WeiMiMyRouter.h"
#import "WeiMiHomeRouter.h"
#import "WeiMiCommunityRouter.h"
#import "WeiMiBaseDTO.h"

@interface WeiMiPageSkipManager : NSObject

/** 我的跳转*/
+ (WeiMiMyRouter *)mineRouter;
+ (Routable *)mineRT;
/** 主页跳转*/
+ (WeiMiHomeRouter *)homeRouter;
+ (Routable *)homeRT;
/** 社区跳转*/
+ (WeiMiCommunityRouter *)communityRouter;
+ (Routable *)communityRT;

/**跳转至个人资料*/
+ (void)skipIntoPersonalInfoVC:(WeiMiBaseViewController *)selfVC;

/**跳转至设置资料*/
+ (void)skipIntoSettingVC:(WeiMiBaseViewController *)selfVC;

/**跳转至新消息设置*/
+ (void)skipIntoMessageSettingVC:(WeiMiBaseViewController *)selfVC;

/**跳转至社区消息设置*/
+ (void)skipCommunityMessageSettingVC:(WeiMiBaseViewController *)selfVC;

/**跳转至积分商城*/
+ (void)skipIntoCreditShoppingVC:(WeiMiBaseViewController *)selfVC;

/**跳转至我的礼物*/
+ (void)skipIntoMyGiftVC:(WeiMiBaseViewController *)selfVC;

/**跳转至我的收藏*/
+ (void)skipIntoMyCollectionVC:(WeiMiBaseViewController *)selfVC;

/**跳转至webView*/
+ (void)skipIntoWebVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title url:(NSString *)url popWithBaseNavColor:(BOOL)pop;

/**跳转至登录页面*/
+ (void)skipIntoLoginVC:(WeiMiBaseViewController *)selfVC;

/**跳转至登录页面(present)*/
+ (void)presentIntoLoginVC:(WeiMiBaseViewController *)selfVC completion:(void (^)(void))completion NS_AVAILABLE_IOS(5_0);

/**跳转至注册页面*/
+ (void)skipIntoRegisterVC:(WeiMiBaseViewController *)selfVC;

/**跳转至帖子详情页面*/
+ (void)skipIntoPostDetailVC:(WeiMiBaseViewController *)selfVC dto:(WeiMiBaseDTO *)dto popWithBaseNavColor:(BOOL)pop;

+ (void)skipIntoPostDetailVC:(WeiMiBaseViewController *)selfVC infoId:(NSString *)infoId popWithBaseNavColor:(BOOL)pop;

/**跳转至问题详情页面*/
+ (void)skipIntoRQDetailVC:(WeiMiBaseViewController *)selfVC dto:(WeiMiBaseDTO *)dto;

/**跳转至添加评论页面*/
+ (void)skipIntoAddCommentVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title sID:(NSString *)sID commentType:(COMMENTTYPE)type;

/**跳转至男生女生页面*/
+ (void)skipIntoMaleFemaleVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title navId:(NSString *)navId;

/**跳转限时抢购页面*/
+ (void)skipIntoPannicBuyVCHiddenBottomBar:(BOOL)hide;

/**跳转商品详情*/
+ (void)skipIntoProductDetailVC:(WeiMiBaseViewController *)selfVC productId:(NSString *)productId popWithBaseNavColor:(BOOL)pop hidesBottomBarWhenPushed:(BOOL)hidden;

/** 跳转至产品列表*/
+ (void)skipIntoProductListVC:(WeiMiBaseViewController *)selfVC title:(NSString *)title menuId:(NSString *)menuId;

/** 跳转至用户协议*/
+ (void)skipIntoUserAgreement:(WeiMiBaseViewController *)selfVC;

@end
