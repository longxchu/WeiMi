//
//  WeiMiBaseDTO.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiBaseDTO.h"
#import <objc/runtime.h>

@implementation WeiMiBaseDTO

/*
 子类继承此方法
 */
- (void)encodeFromDictionary:(NSDictionary *)dic
{
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]])  return;
}

+ (WeiMiBaseDTO *)dtoFromDic:(NSDictionary *)dic
{
    WeiMiBaseDTO * dto = [[self alloc] init];
    [dto encodeFromDictionary:dic];
    return dto;
}

- (BOOL)isEqualToDto:(WeiMiBaseDTO *)dto
{
    if ([[dto description] isEqualToString:[self description]])
    {
        return YES;
    }
    return NO;
}

- (NSDictionary *)decodeToDictionary
{
    //子类重写
    
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i< outCount; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc]
                                  initWithCString:property_getName(property)
                                  encoding:NSUTF8StringEncoding];
        SEL theSelector = NSSelectorFromString(propertyName);
        NSInvocation *anInvocation = [NSInvocation
                                      invocationWithMethodSignature:
                                      [self methodSignatureForSelector:theSelector]];
        [anInvocation setSelector:theSelector];
        [anInvocation setTarget:self];
        [anInvocation invoke];
        
        const char *type = property_copyAttributeValue(property, "T");
        NSString *typeName = [[NSString alloc]
                              initWithCString:type
                              encoding:NSUTF8StringEncoding];
        
        // @see https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
        
        if ([typeName hasPrefix:@"@"])
        {
            __unsafe_unretained id value = nil;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:value forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"c"])
        {
            char value;
            [anInvocation getReturnValue:&value];
            NSString *str = [NSString stringWithFormat:@"%hhd",value];
            [resultDic setObject:str forKey:propertyName];
            
        }
        else if ([typeName hasPrefix:@"i"])
        {
            int value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithInt:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"s"])
        {
            short value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithShort:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"l"])
        {
            long value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithLong:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"q"])
        {
            long long value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithLongLong:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"C"])
        {
            unsigned char value;
            [anInvocation getReturnValue:&value];
            NSString *str = [NSString stringWithFormat:@"%hhd",value];
            [resultDic setObject:str forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"I"])
        {
            unsigned int value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithUnsignedInt:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"S"])
        {
            unsigned short value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithUnsignedShort:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"L"])
        {
            unsigned long value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithUnsignedLong:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"Q"])
        {
            unsigned long long value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithUnsignedLongLong:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"f"])
        {
            float value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithFloat:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"d"])
        {
            double value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithDouble:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"B"])
        {
            _Bool value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:[NSNumber numberWithBool:value] forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"*"])
        {
            char* value;
            [anInvocation getReturnValue:&value];
            NSString *str = [NSString stringWithFormat:@"%s",value];
            [resultDic setObject:str forKey:propertyName];
        }
        else if ([typeName hasPrefix:@"#"])
        {
            Class value;
            [anInvocation getReturnValue:&value];
            [resultDic setObject:value forKey:propertyName];
        }
        else if ([typeName hasPrefix:@":"])
        {
            SEL value;
            [anInvocation getReturnValue:&value];
            NSString *str = [NSString stringWithFormat:@"%s",sel_getName(value)];
            [resultDic setObject:str forKey:propertyName];
        }
    }
    
    free(properties);
    
    return resultDic;
}

//重写desciption方法打印DTO的属性名称以及属性值
- (NSString *)description
{
    NSMutableString *desc = [[NSMutableString alloc] init];
    
    [desc appendFormat:@"\n%@:{\n", [self class]];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i< outCount; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *propertyName = [[NSString alloc]
                                  initWithCString:property_getName(property)
                                  encoding:NSUTF8StringEncoding];
        SEL theSelector = NSSelectorFromString(propertyName);
        NSInvocation *anInvocation = [NSInvocation
                                      invocationWithMethodSignature:
                                      [self methodSignatureForSelector:theSelector]];
        [anInvocation setSelector:theSelector];
        [anInvocation setTarget:self];
        [anInvocation invoke];
        
        const char *type = property_copyAttributeValue(property, "T");
        NSString *typeName = [[NSString alloc]
                              initWithCString:type
                              encoding:NSUTF8StringEncoding];
        
        // @see https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
        
        if ([typeName hasPrefix:@"@"])
        {
            __unsafe_unretained id value = nil;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%@,\n", propertyName,[value description]];
        }
        else if ([typeName hasPrefix:@"c"])
        {
            char value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%hhd,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"i"])
        {
            int value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%d,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"s"])
        {
            short value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%hd,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"l"])
        {
            long value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%ld,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"q"])
        {
            long long value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%lld,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"C"])
        {
            unsigned char value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%hhd,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"I"])
        {
            unsigned int value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%d,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"S"])
        {
            unsigned short value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%hd,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"L"])
        {
            unsigned long value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%ld,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"Q"])
        {
            unsigned long long value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%lld,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"f"])
        {
            float value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%f,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"d"])
        {
            double value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%f,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"B"])
        {
            _Bool value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%@,\n", propertyName,value?@"YES":@"NO"];
        }
        else if ([typeName hasPrefix:@"*"])
        {
            char* value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%s,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@"#"])
        {
            Class value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%@,\n", propertyName,value];
        }
        else if ([typeName hasPrefix:@":"])
        {
            SEL value;
            [anInvocation getReturnValue:&value];
            [desc appendFormat:@"\t%@:%s,\n", propertyName,sel_getName(value)];
        }
    }
    
    [desc appendString:@"}"];
    
    free(properties);
    
    return desc;
}

+ (void)printDTOCodeFromDic:(NSDictionary *)dic;
{
    NSArray *keyArr = [dic allKeys];
    NSMutableString *multiStr = [[NSMutableString alloc] init];
    [multiStr appendString:@"DTO Object .h  Begin=========================================\n"];
    for (NSInteger i = 0; i < [keyArr count] ; i++)
    {
        NSString *propertyStr = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString  *%@;\n",[dic allKeys][i]];
        [multiStr appendString:propertyStr];
        
    }
    [multiStr appendString:@"DTO Object .h  End=========================================\n"];
    [multiStr appendString:@"DTO Object .m  Begin=========================================\n"];
    
    [multiStr appendString:@"\
     - (NSDictionary *)decodeToDictionary\n\
     {\n\
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];\n\
     "];
    for (NSInteger i = 0; i < [keyArr count] ; i++)
    {
        NSString *key = [dic allKeys][i];
        NSString *propertyStr = [NSString stringWithFormat:@"EncodeUnEmptyStrObjctToDic(dic,self.%@,@\"%@\");\n",key,key];
        [multiStr appendString:propertyStr];
    }
    
    [multiStr appendString:@" return dic;\n\
     }"];
    
    [multiStr appendString:@"\n\n\n\n}"];
    
    [multiStr appendString:@"\
     - (void)encodeFromDictionary:(NSDictionary *)dic\n\
     {\n"];
    for (NSInteger i = 0; i < [keyArr count] ; i++)
    {
        NSString *key = [dic allKeys][i];
        NSString *propertyStr = [NSString stringWithFormat:@"self.%@ = EncodeStringFromDic(dic,@\"%@\");\n",key,key];
        [multiStr appendString:propertyStr];
    }
    
    [multiStr appendString:@"}"];
    
    [multiStr appendString:@"DTO Object .m  End=========================================\n"];
    
    
}

@end
