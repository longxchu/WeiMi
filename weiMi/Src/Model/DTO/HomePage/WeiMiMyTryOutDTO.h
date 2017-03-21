//
//  WeiMiMyTryOutDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiMyTryOutDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *imgURL;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSUInteger applyNum;
@property (nonatomic, strong) NSString *deadDate;
@property (nonatomic, assign) NSString *status;

@end
