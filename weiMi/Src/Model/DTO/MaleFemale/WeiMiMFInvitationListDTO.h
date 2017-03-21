//
//  WeiMiMFInvitationListDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiMFInvitationListDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *infoId;//infoId
@property (nonatomic, strong) NSString *infoTitle;//infoTitle
@property (nonatomic, strong) NSString *dzscription;//description
@property (nonatomic, strong) NSString *imgPath;//imgPath

@property (nonatomic, strong) NSString *content;//content
@property (nonatomic, strong) NSString *createTime;//createTime
@property (nonatomic, strong) NSString *type;//type
@property (nonatomic, strong) NSString *isAble;//isAble

@property (nonatomic, strong) NSString *memberId;//memberId
@property (nonatomic, strong) NSString *ringId;//ringId
@property (nonatomic, strong) NSString *dianzan;//dianzan
@property (nonatomic, strong) NSString *pinglun;//pinglun
@property (nonatomic, strong) NSString *memberName;//memberName
@property (nonatomic, copy) NSString *collectId;

@end
