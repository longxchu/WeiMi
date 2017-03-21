//
//  WeiMiHotCommandDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiHotCommandDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *createTime;//新增时间
@property (nonatomic, strong) NSString *ringId;//圈子id

@property (nonatomic, strong) NSString *infoId;//infoId
@property (nonatomic, strong) NSString *type;//type
@property (nonatomic, strong) NSString *content;//content
@property (nonatomic, strong) NSString *sex;//性别
@property (nonatomic, strong) NSString *dzscription;//简介/描述
@property (nonatomic, strong) NSString *imgPath;//图片地址
@property (nonatomic, strong) NSString *memberId;//memberId
@property (nonatomic, strong) NSString *memberName;//会员名
@property (nonatomic, strong) NSString *infoTitle;//标题
@property (nonatomic, assign) NSInteger pinglun;//评论
@property (nonatomic, assign) NSInteger dianzan;//点赞次数
@property (nonatomic, assign) NSInteger isAble;//1正常/2精华
@property (nonatomic, strong) NSString *headImgPath;//图片地址
@end
