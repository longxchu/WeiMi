//
//  WeiMiReplyMeMsgDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiReplyMeMsgDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *commentStr;
@property (nonatomic, strong) NSString *replyStr;
@property (nonatomic, strong) NSString *tagStr;

@end
