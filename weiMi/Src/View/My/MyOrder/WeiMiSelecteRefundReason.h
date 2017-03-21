//
//  WeiMiSelecteRefundReason.h
//  weiMi
//
//  Created by 梁宪松 on 16/9/20.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SeletedIndex) (NSInteger, NSString *);

@interface WeiMiSelecteRefundReason : NSObject

@property (nonatomic,copy)SeletedIndex seletedIndex;

+(instancetype)shareInstance;

- (void)showWithTitles:(NSArray *)titles;
-(void)dismiss;

@end
