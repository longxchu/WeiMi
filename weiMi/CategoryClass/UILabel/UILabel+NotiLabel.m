//
//  UILabel+NotiLabel.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/30.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "UILabel+NotiLabel.h"

@implementation UILabel (NotiLabel)

+ (UILabel *)defaultNotiLabelWithTitle:(NSString *)title
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont fontWithName:@"Arial" size:kFontSizeWithpx(18)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRGBHex:0x00B7EE];
    label.numberOfLines = 2;
    label.text = title;
    return label;
}

+ (UILabel *)footerNotiLabelWithTitle:(NSString *)title textAlignment:(NSTextAlignment)textAlign
{
    UILabel * __notiLabel = [[UILabel alloc] init];
    __notiLabel.font = [UIFont fontWithName:@"Arial" size:14];
//    __notiLabel.textAlignment = textAlign;
    __notiLabel.textColor = kGrayColor;
    __notiLabel.numberOfLines = 2;
    //设置缩进
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.firstLineHeadIndent = 10;
    style.headIndent = 10;//左缩进
    style.tailIndent = -10;//右缩进
    style.lineSpacing = 5.0f;
    if (textAlign) {
        style.alignment = textAlign;
    }


    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,title.length)];
    __notiLabel.attributedText = attrStr;
    return __notiLabel;
}


@end
