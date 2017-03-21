//
//  NSTimer+Add.m
//  Autoyol
//
//  Created by 冯光耀 on 15/11/12.
//  Copyright © 2015年 Autoyol. All rights reserved.
//

#import "NSTimer+Add.h"

@implementation NSTimer (Add)

-(void)pauseTimer{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate date]];
}

-(void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval{
    if (![self isValid]) {
        return;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
