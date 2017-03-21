//
//  WeiMiPanicBuyItem.h
//  weiMi
//
//  Created by 梁宪松 on 2016/12/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeiMiHPProductListDTO.h"
typedef void (^OnItemHandler)(NSString *);
@interface WeiMiPanicBuyItem : WeiMiBaseView

@property (nonatomic, copy) OnItemHandler onItemHandler;

- (void)setViewWithDTO:(WeiMiHPProductListDTO *)dto;


@end
