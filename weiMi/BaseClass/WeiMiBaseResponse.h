//
//  WeiMiBaseResponse.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiMiBaseResponse : NSObject

//@property (nonatomic, assign) NSInteger errNum;
//@property (nonatomic, copy) NSString *retMsg;

@property (nonatomic,strong) NSDictionary *result;

-(void)parseResponse:(NSDictionary *)dic;

@end
