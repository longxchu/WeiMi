//
//  WeiMiRQCommentModel.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiRQCommentModel : WeiMiBaseDTO

@property (nullable, nonatomic, strong) NSString* createTime;
@property (nullable, nonatomic, strong) NSString* disContent;
@property (nullable, nonatomic, strong) NSString* disId;
@property (nullable, nonatomic, strong) NSString* memberId;
@property (nullable, nonatomic, strong) NSString* memberName;
@property (nullable, nonatomic, strong) NSString* headImgPath;
@property (nullable, nonatomic, strong) NSString* title;
@property (nonatomic, assign) NSInteger index;
@end
