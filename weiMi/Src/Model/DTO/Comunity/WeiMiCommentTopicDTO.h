//
//  WeiMiCommentTopicDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/10.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiCommentTopicDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *level;

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *upNum;
@property (nonatomic, strong) NSString *downNum;


@end
