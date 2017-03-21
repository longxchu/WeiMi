//
//  WeiMiMyCareListModel.h
//  weiMi
//
//  Created by zhaoke on 2016/12/26.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WeiMiBaseDTO.h"
#import "WeiMiBaseRequest.h"
#import "WeiMiBaseResponse.h"
#import "WeiMiCircleCateListDTO.h"

@interface WeiMiMyCareListReqeust : WeiMiBaseRequest

- (id)initWithMemberId:(NSString *)memberId pageIndex:(NSString *)index pageSize:(NSString *)size;

@end

@interface WeiMiMyCareListResponse : WeiMiBaseResponse

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@interface WeiMiMyCareListModel : WeiMiBaseDTO

@property (nonatomic, copy) NSString *ringId;
@property (nonatomic, copy) NSString *ringTitle;
@property (nonatomic, copy) NSString *ringIcon;
@property (nonatomic, copy) NSString *myDescription;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *isAble;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *typeId;

@end
