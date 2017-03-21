//
//  WeiMiProductCommentDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiProductCommentDTO : WeiMiBaseDTO

@property (nonatomic, assign) NSInteger fwtd;//服务态度几颗星
@property (nonatomic, assign) NSInteger msxf;//描述相符几颗星

@property (nonatomic, strong) NSString *createTime;//createTime
@property (nonatomic, strong) NSString *strName;//strName 匿名用户
@property (nonatomic, strong) NSString *imgPath;//imgPath

@property (nonatomic, strong) NSString *fhsd;//发送速度几颗星
@property (nonatomic, strong) NSString *msgId;//msgId
@property (nonatomic, strong) NSString *isAble;//1正常/0不显示
@property (nonatomic, strong) NSString *memberId;//memberId
@property (nonatomic, strong) NSString *msgContext;//评价内容
@property (nonatomic, strong) NSString *productId;//productId


@end
