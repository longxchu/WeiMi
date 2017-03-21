//
//  WeiMiCardsDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiCardsDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *tagStr;//infoTitle
@property (nonatomic, strong) NSString *titleStr;//标题 description
@property (nonatomic, strong) NSString *commentNum;//pinglun

@property (nonatomic, strong) NSString *infoId;
//@property (nonatomic, strong) NSString *infoTitle;
//@property (nonatomic, strong) NSString *dzscription;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *ringId;
@property (nonatomic, strong) NSString *dianzan;
//@property (nonatomic, strong) NSString *pinglun;
@property (nonatomic, assign) BOOL isSelect;


@end
