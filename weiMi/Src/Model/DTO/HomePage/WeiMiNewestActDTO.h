//
//  WeiMiNewestActDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiNewestActDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imgURL;//atImg
@property (nonatomic, strong) NSString *title;//atTitle
@property (nonatomic, strong) NSString *detailTitle;//description
@property (nonatomic, strong) NSString *activityPeriod;//atTime
@property (nonatomic, assign) NSUInteger joinMember;//canyu

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *atId;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, strong) NSString *atContent;
@property (nonatomic, strong) NSString *yuedu;
@end
