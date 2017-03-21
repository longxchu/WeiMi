//
//  WeiMiGoodsDetailTagItem.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/11.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiMiGoodsDetailTagItem : UIControl

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *label;

- (void)setCellWithTitle:(NSString *)title image:(NSString *)image;

@end
