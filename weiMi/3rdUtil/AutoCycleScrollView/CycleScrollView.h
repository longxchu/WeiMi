//
//  CycleScrollView.h
//  Autoyol
//
//  Created by 冯光耀 on 15/11/12.
//  Copyright © 2015年 Autoyol. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView

@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,readonly) UIScrollView *scrollView;

//animationDuration 每隔多长时间自动滚动
-(id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

@property (nonatomic,copy)NSInteger (^totalPagesCount)(void);
//获取第pageIndex个位置的contentView
@property (nonatomic,copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);

//点击执行block
@property (nonatomic,copy) void (^TapActionBlock)(NSInteger pageIndex);

@end
