//
//  WeiMiAddRQRequest.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/19.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseRequest.h"

@interface WeiMiAddRQRequest : WeiMiBaseRequest

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *memberId;
@property (nonatomic, strong) NSString *qtId;
@property (nonatomic, assign) NSInteger index;

-(id)initWithQId:(NSString *)qtId memberId:(NSString *)memberId content:(NSString *)content;

@end
