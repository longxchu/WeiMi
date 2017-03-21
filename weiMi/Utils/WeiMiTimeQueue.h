//
//  WeiMiTimeQueue.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WeiMiConstant.h"

@interface WeiMiTimeQueue : NSObject
{
    NSMutableArray  *_timerQueue;
    UIBackgroundTaskIdentifier backgroundTask;
}

AS_SINGLETON(WeiMiTimeQueue);


- (void)scheduleTimeWithInterval:(NSTimeInterval)interval target:(id)target sel:(SEL)aSel repeat:(BOOL)aRep;

- (void)cancelTimerOfTarget:(id)target sel:(SEL)aSel;

- (void)cancelTimerOfTarget:(id)target;

@end
