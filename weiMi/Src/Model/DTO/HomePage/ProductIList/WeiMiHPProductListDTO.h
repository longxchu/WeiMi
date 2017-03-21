//
//  WeiMiHPProductListDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiHPProductListDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *proTypeId;//	类型Id
@property (nonatomic, strong) NSString *vipprice;//	打折
@property (nonatomic, strong) NSString *remark;//	产品描述
@property (nonatomic, strong) NSString *cishu;//	类型Id
@property (nonatomic, strong) NSString *menuId;//	menuId
@property (nonatomic, strong) NSString *number;//	库存
@property (nonatomic, strong) NSString *property;//	库存
@property (nonatomic, strong) NSString *faceImgPath;//	产品显示封面
@property (nonatomic, strong) NSString *endTime;//	限时结束时间
@property (nonatomic, strong) NSString *brandName;//	品牌
@property (nonatomic, strong) NSString *brandId;//	brandId
@property (nonatomic, strong) NSString *salesVolume;//	销量
@property (nonatomic, strong) NSString *proTypeName;//分类名称
@property (nonatomic, strong) NSString *productId;//productId
@property (nonatomic, strong) NSString *zengpin;//赠品信息
@property (nonatomic, strong) NSString *startTime;//限时开始时间
@property (nonatomic, strong) NSString *price;//价格
@property (nonatomic, strong) NSString *imgfiles;//展示图片列表
@property (nonatomic, strong) NSString *isAble;//显示位置
@property (nonatomic, strong) NSString *productName;//产品名称
@property (nonatomic, strong) NSString *menuName;//导航名称

@end
