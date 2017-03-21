//
//  WeiMiGraphics.h
//  app
//
//  Created by Ning Gang on 16/6/1.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    CellPositionSingle = 1,
    CellPositionTop,
    CellPositionCenter,
    CellPositionBottom
}CellPosition;

struct _CornerPositions {
    BOOL topLeft,bottomLeft,bottomRight,topRight;
};
typedef struct _CornerPositions CornerPositions;

//cell的位置
WEIMI_EXTERN CellPosition CellPositionMake(unsigned int rowCount, unsigned int row);

//画四角圆角
WEIMI_EXTERN void CGContextAddRoundCornerToPath(CGContextRef context, CGRect rect, CGFloat cornerRadius);
//画圆形区域
WEIMI_EXTERN void CGContextAddCircleRectToPath(CGContextRef context, CGRect rect);

@interface WeiMiGraphics : NSObject

//用颜色生成图片
+ (UIImage*)colorImage:(UIColor*)color withFrame:(CGRect)frame;

//画一个由上到下渐变的layer
+ (CAGradientLayer*)gradientLayerWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;

//画一个由上到下渐变的image
+ (UIImage*)gradientImageWithTop:(id)topColor bottom:(id)bottomColor frame:(CGRect)frame;

//画圆角
+ (CAShapeLayer *)roundCornerLayerAtFrame:(CGRect)rect
                                   radius:(CGFloat)radius
                          cornerPositions:(CornerPositions)positions;

//手动绘制的cell背景图片
+ (UIImage *)singleCellBgImageWithColor:(UIColor *)color
                           cornerRadius:(CGFloat)radius
                                   size:(CGSize)size;

+ (UIImage *)topCellBgImageWithColor:(UIColor *)color
                        cornerRadius:(CGFloat)radius
                                size:(CGSize)size;

+ (UIImage *)centerCellBgImageWithColor:(UIColor *)color
                           cornerRadius:(CGFloat)radius
                                hasLine:(BOOL)hasLine
                                lineTop:(UIColor *)lineTop
                             lineBottom:(UIColor *)lineBottom
                                   size:(CGSize)size;

+ (UIImage *)bottomCellBgImageWithColor:(UIColor *)color
                           cornerRadius:(CGFloat)radius
                                hasLine:(BOOL)hasLine
                                lineTop:(UIColor *)lineTop
                             lineBottom:(UIColor *)lineBottom
                                   size:(CGSize)size;

+ (UIImage *)cellBgWithCellPosition:(CellPosition)pos
                              color:(UIColor *)color
                       cornerRadius:(CGFloat)radius
                               size:(CGSize)size;

@end
