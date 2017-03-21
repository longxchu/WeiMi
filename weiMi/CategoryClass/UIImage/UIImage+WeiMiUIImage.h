//
//  UIImage+WeiMiUIImage.h
//  app
//
//  Created by Ning Gang on 16/6/1.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WeiMiUIImage)

+ (UIImage *)getImageFromBundle:(NSString *)imageName;

+ (UIImage *)noCachegetImageFromBundle:(NSString *)imageName;

+ (UIImage *)stregetImageFromBundle:(NSString *)imageName;
+ (UIImage *)stregetImageFromBundle:(NSString *)imageName capX:(CGFloat)x capY:(CGFloat)y;
+ (UIImage *)imageWithColor:(UIColor *)color;

- (UIImage *)stretched;
- (UIImage *)grayscale;
- (UIImage *)roundCornerImageWithRadius:(CGFloat)cornerRadius;


- (UIColor *)patternColor;


- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

@end
