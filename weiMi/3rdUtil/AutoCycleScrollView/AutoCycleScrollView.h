//
//  AutoCycleScrollView.h
//  Autoyol
//
//  Created by 冯光耀 on 15/11/10.
//  Copyright © 2015年 Autoyol. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UIPageControlShowStyleNone,
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight
    
}UIPageControlShowStyle;

@interface AutoCycleScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic,strong) UIPageControl *pageControl;

@property (nonatomic,strong) NSArray *imageNameArray;

@property (nonatomic,assign) UIPageControlShowStyle PageControlStyle;

@end
