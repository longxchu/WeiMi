//
//  WeiMiGoodsDetialCommentDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiGoodsDetialCommentDTO : WeiMiBaseDTO

@property (nonatomic, assign) NSUInteger starNum;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *date;

@end
