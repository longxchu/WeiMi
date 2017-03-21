//
//  WeiMiRQDetailTopicDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiRQDetailTopicDTO : WeiMiBaseDTO
@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *level;
@property (nonatomic, strong) NSString *tag;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *visitNum;
@property (nonatomic, assign) BOOL isAnonymity;

@end
