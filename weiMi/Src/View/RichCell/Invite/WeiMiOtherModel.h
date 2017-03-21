//
//  WeiMiOtherModel.h
//  weiMi
//
//  Created by 梁宪松 on 16/10/5.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiMiOtherModel : NSObject

@property (nullable, nonatomic, copy) NSString* type;
@property (nullable, nonatomic, strong) NSString* title;
@property (nullable, nonatomic, copy) NSArray* imgs;
@property (nullable, nonatomic, strong) NSDate* date;
@property (nullable, nonatomic, strong) NSString* tag;
@property (nullable, nonatomic, copy) NSArray* commentNum;
- (id)initWithDict:(NSDictionary *)dict;
@end
