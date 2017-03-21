//
//  WeiMiCreditShopDTO.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"

@interface WeiMiCreditShopDTO : WeiMiBaseDTO

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) BOOL finished;
@property (nonatomic, strong) NSString *creditNum;
@property (nonatomic, strong) NSString *metalNum;

@end
