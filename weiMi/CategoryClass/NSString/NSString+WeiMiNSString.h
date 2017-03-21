//
//  NSString+WeiMiNSString.h
//  app
//
//  Created by Ning Gang on 16/6/1.
//  Copyright © 2016年 WeiMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WeiMiNSString)

- (BOOL)isGetter;
- (BOOL)isSetter;

- (NSString *)getterToSetter;
- (NSString *)setterToGetter;


@end
