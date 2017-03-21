//
//  WeiMiSegmentView.h
//  weiMi
//
//  Created by 梁宪松 on 16/8/24.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseView.h"

@protocol WeiMiSegmentViewDelegate <NSObject>

- (void)didSelectedAtIndex:(NSUInteger)index;

@end

@interface WeiMiSegmentViewConfig : NSObject

//title集合
@property (nonatomic, strong) NSArray *titleArray;
//默认背景颜色
@property (nonatomic, strong) UIColor *bgColor;
//默认字体颜色
@property (nonatomic, strong) UIColor *titleColor;
//选中背景颜色
@property (nonatomic, strong) UIColor *selectBgColor;
//选中字体颜色
@property (nonatomic, strong) UIColor *selectTitleColor;
//滚动条颜色
@property (nonatomic, strong) UIColor *scrollViewColor;
//字体大小
@property (nonatomic, strong) UIFont *titleFont;
//默认选中idx
@property (nonatomic, assign) NSInteger selectedIndex;

@end

@interface WeiMiSegmentView : WeiMiBaseView




@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, weak) id <WeiMiSegmentViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArray defaultSelectIndex:(NSInteger)selectedIndex delegate:(id <WeiMiSegmentViewDelegate>) delegate;

- (instancetype)initWithFrame:(CGRect)frame config:(WeiMiSegmentViewConfig *)config delegate:(id <WeiMiSegmentViewDelegate>) delegate;

- (void)selectedIndex:(NSInteger)selectIndex;

@end
