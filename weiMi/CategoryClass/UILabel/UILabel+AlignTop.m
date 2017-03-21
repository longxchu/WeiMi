//
//  UILabel+AlignTop.m
//  weiMi
//
//  Created by 梁宪松 on 16/9/6.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "UILabel+AlignTop.h"

@implementation UILabel (AlignTop)

- (void)alignTop{
    
    CGSize fontSize = [self.text sizeWithAttributes:@{NSFontAttributeName:self.font}];
    NSInteger num = (NSInteger)(CGRectGetHeight(self.frame)/fontSize.height);
    double finalWidth =self.frame.size.width;//expected width of label
    CGRect theStringRect = [self.text boundingRectWithSize:CGSizeMake(finalWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    if (CGRectGetHeight(theStringRect)<CGRectGetHeight(self.frame)) {
        self.numberOfLines = num;
        self.adjustsFontSizeToFitWidth = NO;
        int newLinesToPad =(CGRectGetHeight(self.frame) - theStringRect.size.height)/ fontSize.height;
        for(int i=0; i<newLinesToPad; i++)
            self.text =[self.text stringByAppendingString:@"\n "];
    }else{
        self.numberOfLines = 0;
        self.adjustsFontSizeToFitWidth = YES;
    }
}

@end
