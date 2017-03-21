//
//  WeiMiHPMenuDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/22.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiHPMenuDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *menuId;
@property (nonatomic, strong) NSString *menuImgPath;
@property (nonatomic, strong) NSString *menuName;
@property (nonatomic, assign) NSInteger menuSort;
@property (nonatomic, assign) NSInteger isAble;

@end
