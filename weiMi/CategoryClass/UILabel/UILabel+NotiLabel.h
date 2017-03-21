//
//  UILabel+NotiLabel.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (NotiLabel)

+ (UILabel *)defaultNotiLabelWithTitle:(NSString *)title;

+ (UILabel *)footerNotiLabelWithTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlign;
@end
