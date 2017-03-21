//
//  WeiMiBaseDTO.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeiMiBaseDTO : NSObject

/*!
 @method
 @abstract   解析dic到DTO数据转换对象
 @discussion 子类继承此方法
 @param      dic 数据源
 @result     无
 */
- (void)encodeFromDictionary:(NSDictionary *)dic;

/*!
 @method
 @abstract   便捷获取从dic数据源得到的数据转换DTO
 @discussion 子类继承，实现encodeFromDictionary方法
 @param      dic 数据源
 @result     id 类对象
 */
+ (WeiMiBaseDTO *)dtoFromDic:(NSDictionary *)dic;

/*!
 @method
 @abstract    用于比较两个对象的值是否全部相等。
 @discussion  不能比较两个对象是否是同一个对象，只能比较两个对象是否值相等。
 @param       dto  比较的对象
 @result      BOOL 是否相等
 */
- (BOOL)isEqualToDto:(WeiMiBaseDTO *)dto;

/*!
 @method
 @abstract    dto转换为Dictinary对象。
 @discussion  重写此方法定制化解析方案，否则默认使用runtime的方式解析，
 key为propertyName，value为propertyValue
 @result      解析结果
 */
- (NSDictionary *)decodeToDictionary;

/*!
 @method
 @abstract   重写打印方法
 @discussion 打印DTO的内容，使用runtime的方法打印
 */
- (NSString *)description;


+ (void)printDTOCodeFromDic:(NSDictionary *)dic;

@end
