//
//  WeiMiWannaItem.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@interface WeiMiWannaItem : UIControl

@property (nonatomic, strong) UIImageView *foreImageView;
@property (nonatomic, strong) UILabel *remarkLB;

- (void)setItemWithTitle:(NSString *)title img:(NSString *)img;

@end
