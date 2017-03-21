//
//  AutoCycleScrollView.m
//  Autoyol
//
//  Created by 冯光耀 on 15/11/10.
//  Copyright © 2015年 Autoyol. All rights reserved.
//

#import "AutoCycleScrollView.h"

#define UIScrollWidth self.bounds.size.width
#define UIScrollHeight self.bounds.size.height

#define HIGHT self.bounds.origin.y

static CGFloat const changeImageTime = 3.0;
static NSUInteger currentImage=1;

@interface AutoCycleScrollView ()
{

    
    NSTimer *moveTime;
    
    BOOL isTimeUp;
}

@property (nonatomic,strong) UIImageView *leftImageView;
@property (nonatomic,strong) UIImageView *centerImageView;
@property (nonatomic,strong) UIImageView *rightImageView;

@end



@implementation AutoCycleScrollView


-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {
        
        self.bounces=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.showsVerticalScrollIndicator=NO;
        
//        UIPageControl *pageControl = [[UIPageControl alloc] init];
//        
//        [self.superview addSubview:pageControl];
//        self.pageControl = pageControl;
        
        self.pageControl = [[UIPageControl alloc] init];
        
        self.pagingEnabled=YES;
        self.contentOffset=CGPointMake(UIScrollWidth, 0);
        self.contentSize=CGSizeMake(UIScrollWidth*3, UIScrollHeight);
        self.delegate=self;
        
        _leftImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScrollWidth, UIScrollHeight)];
        [self addSubview:_leftImageView];
        _centerImageView=[[UIImageView alloc] initWithFrame:CGRectMake(UIScrollWidth*1, 0, UIScrollWidth, UIScrollHeight)];
        [self addSubview:_centerImageView];
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(UIScrollWidth*2, 0, UIScrollWidth, UIScrollHeight)];
        [self addSubview:_rightImageView];
        
        moveTime = [NSTimer scheduledTimerWithTimeInterval:changeImageTime target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
        isTimeUp=NO;
    }
    
    return self;
}


-(void)setImageNameArray:(NSArray *)imageNameArray{
    _imageNameArray=imageNameArray;
    
    self.leftImageView.image=[UIImage imageNamed:self.imageNameArray[0]];
    self.centerImageView.image=[UIImage imageNamed:self.imageNameArray[1]];
    self.rightImageView.image=[UIImage imageNamed:self.imageNameArray[2]];
}


-(void)setPageControlStyle:(UIPageControlShowStyle)PageControlStyle{
    if (PageControlStyle==UIPageControlShowStyleNone) {
        return;
    }
    
      self.pageControl.numberOfPages=self.imageNameArray.count;
    
    
    if (PageControlStyle==UIPageControlShowStyleLeft) {
        self.pageControl.frame=CGRectMake(10, HIGHT+UIScrollHeight-20, 20*self.pageControl.numberOfPages, 20);
        
    }else if (PageControlStyle==UIPageControlShowStyleCenter){
        self.pageControl.frame=CGRectMake(0, 0, 20*self.pageControl.numberOfPages, 20);
        self.pageControl.center=CGPointMake(UIScrollWidth/2.0, HIGHT+UIScrollHeight-20);
    }else{
        self.pageControl.frame=CGRectMake(UIScrollWidth-20*self.pageControl.numberOfPages, HIGHT+UIScrollHeight-20, 20*self.pageControl.numberOfPages, 20);
    }
    
    self.pageControl.currentPage=0;
    self.pageControl.enabled=NO;
    
    [self performSelector:@selector(addPageControl) withObject:nil afterDelay:0.1f];
    
}
-(void)addPageControl{
    [[self superview] addSubview:self.pageControl];
}

-(void)animalMoveImage{
    
    [self setContentOffset:CGPointMake(UIScrollWidth*2, 0) animated:YES];
    
    isTimeUp=YES;
    
    [NSTimer scheduledTimerWithTimeInterval:0.4f target:self selector:@selector(scrollViewDidEndDecelerating:) userInfo:nil repeats:NO];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    

    if (self.contentOffset.x==0) {
        
        currentImage=(currentImage -1)%self.imageNameArray.count;
        self.pageControl.currentPage=(self.pageControl.currentPage-1)%self.imageNameArray.count;
   
    }else if (self.contentOffset.x == UIScrollWidth * 2 ){
        
        currentImage=(currentImage+1)%self.imageNameArray.count;
        self.pageControl.currentPage=(self.pageControl.currentPage+1)%self.imageNameArray.count;
    
    }else{
        
        return;
        
    }
    
    
    //self.pageControl.currentPage = scrollView.contentOffset.x/SCREEN_WIDTH;
    
    self.leftImageView.image=[UIImage imageNamed:self.imageNameArray[(currentImage-1)%self.imageNameArray.count]];
    
    self.centerImageView.image=[UIImage imageNamed:self.imageNameArray[currentImage%self.imageNameArray.count]];
    
    self.rightImageView.image=[UIImage imageNamed:self.imageNameArray[(currentImage+1)%self.imageNameArray.count]];
    
    self.contentOffset=CGPointMake(UIScrollWidth, 0);
    
    if (!isTimeUp) {
        [moveTime setFireDate:[NSDate dateWithTimeIntervalSinceNow:changeImageTime]];
    }
    
    isTimeUp=NO;
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
