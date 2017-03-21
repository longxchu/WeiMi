//
//  WeiMiTryoutGroundDetailDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/31.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiTryoutGroundDetailDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *applyId;//applyId
@property (nonatomic, strong) NSString *createTime;//createTime
@property (nonatomic, strong) NSString *ssg;//舒适感评分
@property (nonatomic, strong) NSString *weidao;//味道评分
@property (nonatomic, strong) NSString *sex;//性别

@property (nonatomic, strong) NSString *fuwu;//服务评分
@property (nonatomic, strong) NSString *zgsg;//做工手感评分
@property (nonatomic, strong) NSString *applyImg;//体验产品图片
@property (nonatomic, strong) NSString *sign;//婚姻状况
@property (nonatomic, strong) NSString *id;//暂无注释

@property (nonatomic, strong) NSString *content;//暂无注释
@property (nonatomic, strong) NSString *title;//Title
@property (nonatomic, strong) NSString *applyName;//体验产品名称
@property (nonatomic, strong) NSString *waixing;//外形评分
@property (nonatomic, strong) NSString *ckfy;//操控反应评分

@property (nonatomic, strong) NSString *age;//age
@property (nonatomic, strong) NSString *memberId;//memberId
@property (nonatomic, strong) NSString *isAble;//状态1正常 2失效
@property (nonatomic, strong) NSString *memberName;//会员名称
@property (nonatomic, strong) NSString *headImgPath;//头像地址

@property (nonatomic, copy) NSString *applyCz, *applyColor, *applyBrand;

@end
