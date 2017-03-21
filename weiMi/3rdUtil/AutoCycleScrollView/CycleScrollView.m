//
//  CycleScrollView.m
//  Autoyol
//
//  Created by 冯光耀 on 15/11/12.
//  Copyright © 2015年 Autoyol. All rights reserved.
//

#import "CycleScrollView.h"

#import "NSTimer+Add.h"

@interface CycleScrollView ()<UIScrollViewDelegate>

@property (nonatomic,assign) NSInteger currentPageIndex;

@property (nonatomic,assign) NSInteger totalPageCount;

@property (nonatomic,strong) NSMutableArray *contentViews;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) NSTimer *animationTimer;
@property (nonatomic,assign) NSTimeInterval animationDuration;

@end


@implementation CycleScrollView

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if ( self ) {
        
        self.autoresizesSubviews=YES;
        
        self.scrollView =[[UIScrollView alloc] initWithFrame:self.bounds];
//        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode=UIViewContentModeCenter;
        self.scrollView.contentSize=CGSizeMake(3*CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate=self;
        self.scrollView.contentOffset=CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled=YES;
        self.scrollView.scrollsToTop = NO;
        [self addSubview:self.scrollView];
        
        self.currentPageIndex=0;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, self.scrollView.frame.size.height-30, SCREEN_WIDTH-20, 20)];
        self.pageControl.currentPage=0;
        self.pageControl.currentPageIndicatorTintColor=[HEX_RGB(0xffffff) colorWithAlphaComponent:0.8];
        self.pageControl.pageIndicatorTintColor=[HEX_RGB(0xffffff) colorWithAlphaComponent:0.2];
        [self addSubview:self.pageControl];
        
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration{
    
    self=[self initWithFrame:frame];
    
    if (animationDuration>0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration=animationDuration) target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
        
        [self.animationTimer pauseTimer];
    }
    
    return self;
    
}

#pragma mark --setter  getter
-(void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount{
    self.totalPageCount= totalPagesCount();
    
    if (self.totalPageCount>0) {
        
        self.currentPageIndex = 0;
        [self configContentView];
        
        self.scrollView.scrollEnabled = NO;
        [self.animationTimer pauseTimer];
        
    }
    if (self.totalPageCount > 1) {
        
        self.scrollView.scrollEnabled = YES;
        [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
    }
    
}

#pragma mark -- 时间触发事件
-(void)animationTimerDidFired:(NSTimer *)timer{
    
    self.pageControl.currentPage=self.currentPageIndex+1;
    
    if (self.currentPageIndex==self.totalPageCount-1) {
        self.pageControl.currentPage=0;
    }
    CGPoint newOffset=CGPointMake(2 * CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
//    CGPoint newOffset=CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
    
}

-(void)configContentView{
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self setScrollViewContentDataSource];
    
    NSInteger counter=0;
    
    for (UIView *contentView in self.contentViews) {
        
        
        contentView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        
        
        CGRect rightRect = contentView.frame;
        rightRect.origin=CGPointMake(CGRectGetWidth(self.scrollView.frame)*(counter ++), 0);
        contentView.frame=rightRect;
        
        [self.scrollView addSubview:contentView];
    }
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    
    
    self.pageControl.numberOfPages=self.totalPageCount;
    
}

//手势
- (void)contentViewTapAction:(UITapGestureRecognizer *)tap
{
    if (self.TapActionBlock) {
        self.TapActionBlock(self.currentPageIndex);
    }
    
    //self.pageControl.currentPage=self.currentPageIndex;
}

//数据源
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViews addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex >= self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

#pragma mark --UIScrollViewDelegaet

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.animationTimer pauseTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int contentOffsetX = scrollView.contentOffset.x;
    
    if (contentOffsetX >= (2*CGRectGetWidth(scrollView.frame))) {
        
        self.currentPageIndex=[self getValidNextPageIndexWithPageIndex:self.currentPageIndex+1];
        [self configContentView];
    }
    
    if (contentOffsetX <= 0) {
        self.currentPageIndex=[self getValidNextPageIndexWithPageIndex:self.currentPageIndex-1];
        [self configContentView];
    }
    
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
    
    self.pageControl.currentPage=self.currentPageIndex;
}





/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
