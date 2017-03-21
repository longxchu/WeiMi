//
//  WeiMiGraphics.m
//  app
//
//  Created by Ning Gang on 16/6/1.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import "WeiMiGraphics.h"
#import "UIColor+WeiMiUIColor.h"

WEIMI_EXTERN CellPosition CellPositionMake(unsigned int rowCount, unsigned int row)
{
    if (rowCount <= 0)
    {
        return CellPositionSingle;
    }
    else if (rowCount == 1)
    {
        return CellPositionSingle;
    }
    else if (row == 0)
    {
        return CellPositionTop;
    }
    else if (row < rowCount-1)
    {
        return CellPositionCenter;
    }
    else if (row == rowCount-1)
    {
        return CellPositionBottom;
    }
    return CellPositionSingle;
}

WEIMI_EXTERN void CGContextAddRoundCornerToPath(CGContextRef context, CGRect rect, CGFloat cornerRadius)
{
    CGContextSaveGState(context);
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, minX, midY);
    CGContextAddArcToPoint(context, minX, minY, midX, minY, cornerRadius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, cornerRadius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, cornerRadius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, cornerRadius);
    CGContextClosePath(context);
    
    CGContextRestoreGState(context);
}

WEIMI_EXTERN void CGContextAddCircleRectToPath(CGContextRef context, CGRect rect)
{
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextSetShouldAntialias(context, true);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextAddEllipseInRect(context, rect);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation WeiMiGraphics

+ (UIImage*)colorImage:(UIColor*)color withFrame:(CGRect)frame
{
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0);
    [color setFill];
    UIRectFill(frame);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (CAGradientLayer*)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = frame;
    layer.colors = [NSArray arrayWithObjects:
                    (id)[topColor CGColor],
                    (id)[bottomColor CGColor], nil];
    layer.startPoint = CGPointMake(0.5f, 0.0f);
    layer.endPoint = CGPointMake(0.5f, 1.0f);
    return layer;
}

+ (UIImage*)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame
{
    CAGradientLayer *layer = [self gradientLayerWithTop:topColor bottom:bottomColor frame:frame];
    UIGraphicsBeginImageContextWithOptions([layer frame].size, NO, 0);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (CAShapeLayer *)roundCornerLayerAtFrame:(CGRect)rect
                                   radius:(CGFloat)radius
                          cornerPositions:(CornerPositions)positions
{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat minX = CGRectGetMinX(rect);
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat maxX = CGRectGetMaxX(rect);
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat midY = CGRectGetMidY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    
    CGPathMoveToPoint(path, NULL, midX, minY);
    if (positions.topLeft) {
        CGPathAddArcToPoint(path, NULL, minX, minY, minX, midY, radius);
    }else{
        CGPathAddLineToPoint(path, NULL, minX, minY);
        CGPathAddLineToPoint(path, NULL, minX, midY);
    }
    
    if (positions.bottomLeft) {
        CGPathAddArcToPoint(path, NULL, minX, maxY, midX, maxY, radius);
    }else{
        CGPathAddLineToPoint(path, NULL, minX, maxY);
        CGPathAddLineToPoint(path, NULL, midX, maxY);
    }
    
    if (positions.bottomRight) {
        CGPathAddArcToPoint(path, NULL, maxX, maxY, maxX, midY, radius);
    }else{
        CGPathAddLineToPoint(path, NULL, maxX, maxY);
        CGPathAddLineToPoint(path, NULL, maxX, midY);
    }
    
    if (positions.topRight) {
        CGPathAddArcToPoint(path, NULL, maxX, minY, midX, minY, radius);
    }else{
        CGPathAddLineToPoint(path, NULL, maxX, minY);
    }
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    return shapeLayer;
}

+ (UIImage *)singleCellBgImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius
                                   size:(CGSize)size
{
    //生成图像
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGRect frame = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画阴影
    //CGContextSetShadowWithColor(context, CGSizeMake(0.1, 0.5), 1, RGBACOLOR(100, 100, 100, 0.4).CGColor);
    
    //画圆角
    CGContextBeginTransparencyLayer(context, NULL);
    {
        CGContextClipToRect(context, frame);
        CGFloat minX = CGRectGetMinX(frame);
        CGFloat midX = CGRectGetMidX(frame);
        CGFloat maxX = CGRectGetMaxX(frame);
        
        CGFloat minY = CGRectGetMinY(frame);
        CGFloat midY = CGRectGetMidY(frame);
        CGFloat maxY = CGRectGetMaxY(frame);
        
        CGContextMoveToPoint(context, minX, midY);
        CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
        CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
        CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
        CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    }
    CGContextEndTransparencyLayer(context);
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)topCellBgImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius size:(CGSize)size
{
    //生成图像
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGRect frame = CGRectMake(0, 0, w, h);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //画阴影
    // CGContextSetShadowWithColor(context, CGSizeMake(0.1, 0.5), 1, RGBACOLOR(100, 100, 100, 0.4).CGColor);
    
    //画圆角
    CGContextBeginTransparencyLayer(context, NULL);
    {
        CGContextClipToRect(context, frame);
        CGFloat minX = CGRectGetMinX(frame);
        CGFloat midX = CGRectGetMidX(frame);
        CGFloat maxX = CGRectGetMaxX(frame);
        
        CGFloat minY = CGRectGetMinY(frame);
        CGFloat midY = CGRectGetMidY(frame);
        CGFloat maxY = CGRectGetMaxY(frame);
        
        CGContextMoveToPoint(context, minX, midY);
        CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
        CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
        CGContextAddLineToPoint(context, maxX, maxY);
        CGContextAddLineToPoint(context, minX, maxY);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    }
    CGContextEndTransparencyLayer(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)centerCellBgImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius hasLine:(BOOL)hasLine lineTop:(UIColor *)lineTop lineBottom:(UIColor *)lineBottom size:(CGSize)size
{
    //生成图像
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGRect frame = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画阴影
    // CGContextSetShadowWithColor(context, CGSizeMake(0.1, 0.5), 1, RGBACOLOR(100, 100, 100, 0.4).CGColor);
    
    //画底色
    CGContextBeginTransparencyLayer(context, NULL);
    {
        CGContextClipToRect(context, frame);
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillRect(context, frame);
    }
    CGContextEndTransparencyLayer(context);
    
    //添加sepline
    if (hasLine) {
        NSInteger pandleft = 10;
        //        if (IS_IPAD) {
        //            pandleft = 35;
        //        }
        //end add
        CGContextClipToRect(context, CGRectMake(pandleft, 0, w - 2*pandleft, 1));
        CAGradientLayer *lineLayer = [self gradientLayerWithTop:lineTop
                                                         bottom:lineBottom
                                                          frame:CGRectMake(0, 0, w, 1)];
        [lineLayer renderInContext:context];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)bottomCellBgImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius hasLine:(BOOL)hasLine lineTop:(UIColor *)lineTop lineBottom:(UIColor *)lineBottom size:(CGSize)size
{
    //生成图像
    CGFloat w = size.width;
    CGFloat h = size.height;
    
    CGRect frame = CGRectMake(0, 0, w, h);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //画阴影
    // CGContextSetShadowWithColor(context, CGSizeMake(0.1, 0.5), 1, RGBACOLOR(100, 100, 100, 0.4).CGColor);
    
    //画圆角和填充色
    CGContextBeginTransparencyLayer(context, NULL);
    {
        CGContextClipToRect(context, frame);
        CGFloat minX = CGRectGetMinX(frame);
        CGFloat midX = CGRectGetMidX(frame);
        CGFloat maxX = CGRectGetMaxX(frame);
        
        CGFloat minY = CGRectGetMinY(frame);
        CGFloat midY = CGRectGetMidY(frame);
        CGFloat maxY = CGRectGetMaxY(frame);
        
        CGContextMoveToPoint(context, minX, minY);
        CGContextAddLineToPoint(context, maxX, minY);
        CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
        CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);
        CGContextClosePath(context);
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        CGContextFillPath(context);
    }
    CGContextEndTransparencyLayer(context);
    
    NSInteger pandleft = 10;
    //    if (IS_IPAD) {
    //        pandleft = 35;
    //    }
    //end add
    
    //添加sepline
    if (hasLine) {
        CGContextClipToRect(context, CGRectMake(pandleft, 0, w-2*pandleft, 1));
        CAGradientLayer *lineLayer = [self gradientLayerWithTop:lineTop
                                                         bottom:lineBottom
                                                          frame:CGRectMake(0, 0, w, 1)];
        [lineLayer renderInContext:context];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)cellBgWithCellPosition:(CellPosition)pos
                              color:(UIColor *)color
                       cornerRadius:(CGFloat)radius
                               size:(CGSize)size
{
    switch (pos) {
        case CellPositionSingle:
        {
            return [self singleCellBgImageWithColor:color cornerRadius:radius size:size];
            break;
        }
        case CellPositionTop:
        {
            return [self topCellBgImageWithColor:color cornerRadius:radius size:size];
            break;
        }
        case CellPositionCenter:
        {
            return [self centerCellBgImageWithColor:color cornerRadius:radius hasLine:YES
                                            lineTop:HEX_RGB(0xb1b4b9)
                                         lineBottom:HEX_RGB(0xb1b4b9)
                                               size:size];
            break;
        }
        case CellPositionBottom:
        {
            return [self bottomCellBgImageWithColor:color cornerRadius:radius hasLine:YES
                                            lineTop:HEX_RGB(0xb1b4b9)
                                         lineBottom:HEX_RGB(0xb1b4b9)
                                               size:size];
            break;
        }
        default:
            break;
    }
    return nil;
}
@end
