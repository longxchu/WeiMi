//
//  WeiMiGlobalEnum.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#ifndef WeiMiGlobalEnum_h
#define WeiMiGlobalEnum_h

//------------------ 发布评论 有三种类型 贴子， 男生，女生
typedef NS_ENUM(NSInteger, COMMENTTYPE) {
    COMMENTTYPE_INVITATION,//帖子
    COMMENTTYPE_MALEINVITATION,//男生撸啊撸
    COMMENTTYPE_FEMALEINVITATION,//女生悄悄话
    COMMENTTYPE_MALERQ,//男生问答
    COMMENTTYPE_FRMALERQ,//女生问答
};

#endif /* WeiMiGlobalEnum_h */
