//
//  WeiMiMaleFemaleRQDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/14.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiMaleFemaleRQDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *qtId;//qtId
@property (nonatomic, strong) NSString *createTime;//"2016-07-28 23:42:08"
@property (nonatomic, strong) NSString *niming;//niming

@property (nonatomic, strong) NSString *qtContent;//qtContent
@property (nonatomic, strong) NSString *qtTitle;//qtTitle
@property (nonatomic, strong) NSString *memberId;//memberId
@property (nonatomic, strong) NSString *isAble;//isAble
@property (nonatomic, strong) NSString *memberName;//memberName
@property (nonatomic, assign) NSInteger type;//type
@property (nonatomic, assign) NSInteger pinglun;//评论
@property (nonatomic, assign) NSInteger yuedu;//yuedu

@end
