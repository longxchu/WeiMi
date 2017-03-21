//
//  WeiMiPublishView.m
//  weiMi
//
//  Created by 梁宪松 on 16/10/9.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiPublishView.h"
#import <math.h>

#define LSCREENH [UIScreen mainScreen].bounds.size.height
#define LSCREENW [UIScreen mainScreen].bounds.size.width
#define ShareH 170

@implementation WeiMiPublishView

- (instancetype)initWithTitleImgDic:(NSDictionary *)dic frame:(CGRect)frame
{
    NSAssert(dic.count <= 8, @"too much items");
    
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.6];
        
        UIView * view1 =[[UIView alloc]initWithFrame:CGRectMake(0, LSCREENH-ShareH, LSCREENW, ShareH)];
        view1.backgroundColor =[UIColor clearColor];
        [self addSubview:view1];
        
        NSInteger tag = 0;
        for(NSString *key in dic.allKeys)
        {
            
            UILabel *lb = [[UILabel alloc] init];
            lb.font = [UIFont fontWithName:@"Arial" size:15];
            lb.textColor = [UIColor whiteColor];
            lb.textAlignment = NSTextAlignmentCenter;
            lb.text = key;
            
            UIButton * btn1 = [self btnAnimateWithTitle:lb frame:CGRectMake(LSCREENW/4 * pow(3, tag) -30, LSCREENH-80, 60, 60) imageName:EncodeStringFromDic(dic, key) animateFrame:CGRectMake(LSCREENW/4* pow(3, tag) - 30, LSCREENH-130, 60, 60) delay:0.0];
            
            btn1.tag= tag +1 ;
            tag ++;
            [btn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
//        UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
//        plus.frame = CGRectMake((LSCREENW-25)/2 ,LSCREENH-35, 25, 25);
//        [plus setImage:[UIImage imageNamed:@"share_icon_cancle"] forState:UIControlStateNormal];
//        [plus addTarget:self action:@selector(cancelAnimation) forControlEvents:UIControlEventTouchUpInside];
//        plus.tag =8888;
//        [self addSubview:plus];
//        [UIView animateWithDuration:0.2 animations:^{
//            
//            plus.transform = CGAffineTransformMakeRotation(M_PI_2);
//        }];

    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor =[[UIColor blackColor]colorWithAlphaComponent:0.6];
        
        UIView * view1 =[[UIView alloc]initWithFrame:CGRectMake(0, LSCREENH-ShareH, LSCREENW, ShareH)];
        view1.backgroundColor =[UIColor whiteColor];
        [self addSubview:view1];
        
        UILabel *lb1 = [[UILabel alloc] init];
        lb1.font = [UIFont fontWithName:@"Arial" size:15];
        lb1.textColor = [UIColor lightGrayColor];
        lb1.textAlignment = NSTextAlignmentCenter;
        lb1.text = @"微信好友";
        UIButton * btn1 = [self btnAnimateWithTitle:lb1 frame:CGRectMake(LSCREENW/4-30, LSCREENH-80, 60, 60) imageName:@"share_icon_weixinhaoyou" animateFrame:CGRectMake(LSCREENW/4-30, LSCREENH-130, 60, 60) delay:0.0];
        btn1.tag=1;
        [btn1 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *lb2 = [[UILabel alloc] init];
        lb2.font = [UIFont fontWithName:@"Arial" size:15];
        lb2.textColor = [UIColor lightGrayColor];
        lb2.textAlignment = NSTextAlignmentCenter;
        lb2.text = @"朋友圈";
        UIButton * btn2 = [self btnAnimateWithTitle:lb2 frame:CGRectMake((LSCREENW/4)*3-30, LSCREENH-80, 60, 60) imageName:@"share_icon_pengyouquan" animateFrame:CGRectMake((LSCREENW/4)*3-30, LSCREENH-130, 60, 60) delay:0.1];
        btn2.tag=2;
        [btn2 addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *plus = [UIButton buttonWithType:UIButtonTypeCustom];
        plus.frame = CGRectMake((LSCREENW-25)/2 ,LSCREENH-35, 25, 25);
        [plus setImage:[UIImage imageNamed:@"share_icon_cancle"] forState:UIControlStateNormal];
        [plus addTarget:self action:@selector(cancelAnimation) forControlEvents:UIControlEventTouchUpInside];
        plus.tag =8888;
        [self addSubview:plus];
        [UIView animateWithDuration:0.2 animations:^{
            
            plus.transform = CGAffineTransformMakeRotation(M_PI_2);
        }];
        
    }
    return self;
}

-(void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
}

-(UIButton *)btnAnimateWithTitle:(UILabel *)label frame:(CGRect)frame imageName:(NSString *)imageName animateFrame:(CGRect)aniFrame delay:(CGFloat)delay
{
    UIButton * btn =[[UIButton alloc]init];
    btn.frame =frame;
    [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [self  addSubview:btn];

    [self addSubview:label];
    label.frame = frame;
    
    CGRect lbFrame = CGRectMake(frame.origin.x - 10, CGRectGetMaxY(aniFrame) + 5, CGRectGetWidth(aniFrame) + 20, 20);
    [UIView animateWithDuration:1 delay:delay usingSpringWithDamping:0.3 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        btn.frame  = aniFrame;
        label.frame = lbFrame;
    } completion:^(BOOL finished) {
        
    }];
    return btn;
    
    //usingSpringWithDamping :弹簧动画的阻尼值，也就是相当于摩擦力的大小，该属性的值从0.0到1.0之间，越靠近0，阻尼越小，弹动的幅度越大，反之阻尼越大，弹动的幅度越小，如果大道一定程度，会出现弹不动的情况。
    //initialSpringVelocity :弹簧动画的速率，或者说是动力。值越小弹簧的动力越小，弹簧拉伸的幅度越小，反之动力越大，弹簧拉伸的幅度越大。这里需要注意的是，如果设置为0，表示忽略该属性，由动画持续时间和阻尼计算动画的效果。
    
}

-(void)BtnClick:(UIButton*)btn
{
    for (NSInteger i = 0; i<self.subviews.count; i++)
    {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]])
        {
            [UIView animateWithDuration:0.3 delay:0.1*i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, LSCREENH, 60, 60);
            } completion:^(BOOL finished) {
            }];
        }
    }
    
    [self performSelector:@selector(removeView:) withObject:btn afterDelay:0.5];
    
}
-(void)removeView:(UIButton*)btn
{
    [self removeFromSuperview];
    [self.delegate didSelectBtnWithBtnTag:btn.tag];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint currentPosition = [touch locationInView:self];
    
    CGFloat deltaY = currentPosition.y;
    if (deltaY<(LSCREENH-ShareH))
    {
        [self cancelAnimation];
    }
}
-(void)cancelAnimation
{
    UIButton * cancelBtn =(UIButton*)[self viewWithTag:8888];
    [UIView animateWithDuration:0.2 animations:^{
        
        cancelBtn.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }];
    
    for (NSInteger i = 0; i<self.subviews.count; i++)
    {
        UIView *view = self.subviews[i];
        if ([view isKindOfClass:[UIButton class]] || [view isKindOfClass:[UILabel class]])
        {
            [UIView animateWithDuration:0.3 delay:0.1*i options:UIViewAnimationOptionTransitionCurlDown animations:^{
                view.frame = CGRectMake(view.frame.origin.x, LSCREENH, view.width, view.height);
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
            }];
        }
    }
}



@end
