//
//  WeiMiTryoutListDTO.h
//  weiMi
//
//  Created by 梁宪松 on 2016/10/29.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiTryoutListDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *applyId;//applyId
@property (nonatomic, strong) NSString *applyTitle;//applyTitle
@property (nonatomic, strong) NSString *applyImg;//applyImg
@property (nonatomic, strong) NSString *applyPrice;//applyPrice
@property (nonatomic, assign) NSUInteger applyNumber;//applyNumber

@property (nonatomic, strong) NSString *applyBrand;//applyBrand
@property (nonatomic, strong) NSString *applyName;
@property (nonatomic, strong) NSString *applyCz;
@property (nonatomic, strong) NSString *applyColor;
@property (nonatomic, strong) NSString *applyContent;
@property (nonatomic, strong) NSString *isAble;
@property (nonatomic, assign) NSUInteger numPerson;
@property (nonatomic, strong) NSString *endTime;

@end
