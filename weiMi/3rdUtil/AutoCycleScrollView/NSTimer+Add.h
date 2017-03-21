//
//  NSTimer+Add.h
//  Autoyol
//
//  Created by 冯光耀 on 15/11/12.
//  Copyright © 2015年 Autoyol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Add)

-(void)pauseTimer;
-(void)resumeTimer;
-(void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
