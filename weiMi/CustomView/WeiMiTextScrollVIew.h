//
//  WeiMiTextScrollVIew.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/12.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

typedef void(^clickLabelBlock)(NSInteger index);

@interface WeiMiTextScrollVIew : UIView

/**
*  文字数组
*/
@property (nonatomic,strong) NSArray *titleArray;
/**
 *  拼接后的文字数组
 */
@property (nonatomic,strong) NSMutableArray *titleNewArray;
/**
 *  是否可以拖拽
 */
@property (nonatomic,assign) BOOL isCanScroll;
/**
 *  block回调
 */
@property (nonatomic,copy)void(^clickLabelBlock)(NSInteger index);
/**
 *  字体颜色
 */
@property (nonatomic,strong) UIColor *titleColor;
/**
 *  背景颜色
 */
@property (nonatomic,strong) UIColor *BGColor;
/**
 *  字体大小
 */
@property (nonatomic,assign) CGFloat titleFont;
/**
 *  居中方式
 */
@property (nonatomic,assign) NSTextAlignment textAlignment;

/**
 *  关闭定时器
 */
- (void)removeTimer;

/**
 *  添加定时器
 */
- (void)addTimer;

/**
 *  label的点击事件
 */

- (void) clickTitleLabel:(clickLabelBlock) clickLabelBlock;



@end
