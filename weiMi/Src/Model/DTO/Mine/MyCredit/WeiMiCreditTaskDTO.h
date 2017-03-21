//
//  WeiMiCreditTaskDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/11/7.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiCreditTaskDTO : WeiMiBaseDTO

    @property (nonatomic, strong) NSString *baseNumber;//完成数
    @property (nonatomic, strong) NSString *baseType;//1新手任务/2日常任务
    @property (nonatomic, strong) NSString *baseName;//任务名称
    @property (nonatomic, strong) NSString *baseValue;//奖励积分
    @property (nonatomic, strong) NSString *baseId;//baseId
    
@end
