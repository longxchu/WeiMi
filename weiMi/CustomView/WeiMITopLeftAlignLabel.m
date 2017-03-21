//
//  WeiMITopLeftAlignLabel.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMITopLeftAlignLabel.h"

@implementation WeiMITopLeftAlignLabel

-(void) drawTextInRect:(CGRect)inFrame {
    
    CGRect draw = [self textRectForBounds:inFrame limitedToNumberOfLines:[self numberOfLines]];
    draw.origin = CGPointMake(0, 10);
    [super drawTextInRect:draw];
}

@end
