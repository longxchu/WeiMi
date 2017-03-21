//
//  WeiMiExchangeVC.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseViewController.h"
#import "WeiMiCreditExchangeDTO.h"

@interface WeiMiExchangeVC : WeiMiBaseViewController

@property (nonatomic, strong) WeiMiCreditExchangeDTO *dto;

@property (nonatomic, assign) NSInteger currentCredit;
@end
