//
//  WeiMiAddressEditVC.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/28.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseViewController.h"
#import "WeiMiRecAddDTO.h"

typedef void (^CallBackHandler)(WeiMiRecAddDTO *);

@interface WeiMiAddressEditVC : WeiMiBaseViewController

@property (nonatomic, strong) CallBackHandler callBackHandler;
@property (nonatomic, strong) WeiMiRecAddDTO *dto;

@end
