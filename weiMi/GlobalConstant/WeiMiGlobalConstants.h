//
//  WeiMiGlobalConstants.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#ifndef WeiMiGlobalConstants_h
#define WeiMiGlobalConstants_h

#pragma mark ----------------------------- 分页默认配置

#define kDefaultStartPage           (0)
#define kDefaultPageSize            (10)

#define kDefaultStartPageStr           @"0"
#define kDefaultPageSizeStr            @"10"
#define kLargePageSizeStr            @"100"

#pragma mark ----------------------------- 系统控件默认尺寸

#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)

#define NAV_WIDTH                   SCREEN_WIDTH
#define NAV_HEIGHT                  (44)

#define TAB_BAR_WIDTH               SCREEN_WIDTH
#define TAB_BAR_HEIGHT              (48)

#define STATUS_BAR_HEIGHT           (20)

#pragma mark ----------------------------- APP默认主色调
#define BASE_COLOR_HEX              (0x7020b0)

#pragma mark ----------------------------- APP二级页面navBar颜色
#define SEC_COLOR_HEX              (0xF6F6F6)

#pragma mark ----------------------------- APP默认字体颜色
#define BASE_TEXT_COLOR             (0x302F2F)

#pragma mark ----------------------------- APP默认背景颜色
#define BASE_BG_COLOR             (0xEAEAEA)

#pragma mark ----------------------------- APP测试图片
#define TEST_IMAGE_URL               (@"http://image.thepaper.cn/www/image/5/188/51.jpg")

#pragma mark ----------------------------- 通知中心注册名
/// 变换倒计时通知
#define NOTIFI_CHANGEDOWNTIME       @"changeDownTimenNotifi"
/// 页面跳转通知
#define kPageSkipKey                @"kPageSkipKeyNotifi"


#define kMaleTag  @"98"
#define kFemaleTag  @"99"

#define WEIXIN_AppID @"wx4be647c5b8664135"
#define WEIXIN_AppSecret @"2ed1eb08daef859974685d9b2fa66226"

#define LOG_SELECT @"logSelect"


#endif /* WeiMiGlobalConstants_h */
