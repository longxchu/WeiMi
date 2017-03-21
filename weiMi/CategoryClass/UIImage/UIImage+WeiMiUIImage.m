//
//  UIImage+WeiMiUIImage.m
//  app
//
//  Created by Ning Gang on 16/6/1.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import "UIImage+WeiMiUIImage.h"
#import "WeiMiGraphics.h"

@implementation UIImage (WeiMiUIImage)

CGFloat DegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

CGFloat RadiansToDegrees(CGFloat radians)
{
    return radians * 180/M_PI;
}

+ (UIImage *)getImageFromBundle:(NSString *)imageName
{
    NSString *main_images_dir_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"WeiMiBundle.bundle"];
    
    NSString *image_path = [main_images_dir_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",imageName]];
    
    return [UIImage imageWithContentsOfFile:image_path];
    
}

+ (UIImage *)noCachegetImageFromBundle:(NSString *)imageName
{
    NSString *imageFile = [[NSString alloc] initWithFormat:@"%@/%@",
                           [[NSBundle mainBundle] resourcePath], imageName];
    return [[UIImage alloc] initWithContentsOfFile:imageFile];
}

+ (UIImage *)stregetImageFromBundle:(NSString *)imageName
{
    if (imageName == nil) {
        return nil;
    }
    UIImage *image = [UIImage getImageFromBundle:imageName];
    UIImage *streImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return streImage;
}

+ (UIImage *)stregetImageFromBundle:(NSString *)imageName capX:(CGFloat)x capY:(CGFloat)y
{
    if (imageName == nil) {
        return nil;
    }
    UIImage *image = [UIImage getImageFromBundle:imageName];
    UIImage *streImage = [image stretchableImageWithLeftCapWidth:x topCapHeight:y];
    return streImage;
}

- (UIImage *)stretched
{
    CGFloat leftCap = floorf(self.size.width / 2.0f);
    CGFloat topCap = floorf(self.size.height / 2.0f);
    return [self stretchableImageWithLeftCapWidth:leftCap topCapHeight:topCap];
}

- (UIImage *)grayscale
{
    CGSize size = self.size;
    CGRect rect = CGRectMake(0.0f, 0.0f, self.size.width, self.size.height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate(nil, size.width, size.height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(context, rect, [self CGImage]);
    CGImageRef grayscale = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage * image = [UIImage imageWithCGImage:grayscale];
    CFRelease(grayscale);
    
    return image;
}

- (UIImage *)roundCornerImageWithRadius:(CGFloat)cornerRadius
{
    int w = self.size.width;
    int h = self.size.height;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGBitmapByteOrderDefault);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(0, 0, w, h);
    CGContextAddRoundCornerToPath(context, rect, cornerRadius);
    CGContextClip(context);
    
    CGContextDrawImage(context, rect, self.CGImage);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIImage *image = [UIImage imageWithCGImage:imageMasked];
    
    CGImageRelease(imageMasked);
    
    return image;
}

- (UIColor *)patternColor
{
    return [UIColor colorWithPatternImage:self];
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
{
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
