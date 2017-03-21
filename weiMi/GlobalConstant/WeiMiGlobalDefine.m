//
//  WeiMiGlobalDefine.m
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeiMiGlobalDefine.h"
#import "WeiMiSystemInfo.h"

WEIMI_EXTERN NSString* EncodeObjectFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    NSString *value = @"";
    if (NotNilAndNull(temp))   {
        if ([temp isKindOfClass:[NSString class]]) {
            value = temp;
        }else if([temp isKindOfClass:[NSNumber class]]){
            value = [temp stringValue];
        }
        return value;
    }
    return nil;
}

WEIMI_EXTERN NSString* EncodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    NSString *value = defaultStr;
    if (NotNilAndNull(temp))   {
        if ([temp isKindOfClass:[NSString class]]) {
            value = temp;
        }else if([temp isKindOfClass:[NSNumber class]]){
            value = [temp stringValue];
        }
        
        return value;
    }
    return value;
}

WEIMI_EXTERN id safeObjectAtIndex(NSArray *arr, NSInteger index)
{
    if (IsArrEmpty(arr)) {
        return nil;
    }
    
    if ([arr count]-1<index) {
        WeiMiAssert([arr count]-1<index);
        return nil;
    }
    
    return [arr objectAtIndex:index];
}



WEIMI_EXTERN NSString* EncodeStringFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]])
    {
        if ([temp isEqualToString:@"(null)"]) {
            return @"";
        }
        return temp;
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        return [temp stringValue];
    }
    return nil;
}

WEIMI_EXTERN NSNumber* EncodeNumberFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSString class]])
    {
        return [NSNumber numberWithDouble:[temp doubleValue]];
    }
    else if ([temp isKindOfClass:[NSNumber class]])
    {
        return temp;
    }
    return nil;
}

WEIMI_EXTERN NSDictionary *EncodeDicFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSDictionary class]])
    {
        return temp;
    }
    return nil;
}

WEIMI_EXTERN NSArray      *EncodeArrayFromDic(NSDictionary *dic, NSString *key)
{
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSArray class]])
    {
        return temp;
    }
    return nil;
}

WEIMI_EXTERN NSArray      *EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic))
{
    NSArray *tempList = EncodeArrayFromDic(dic, key);
    if ([tempList count])
    {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[tempList count]];
        for (NSDictionary *item in tempList)
        {
            id dto = parseBlock(item);
            if (dto) {
                [array addObject:dto];
            }
        }
        return array;
    }
    return nil;
}

WEIMI_EXTERN void EncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key)
{
    if (IsNilOrNull(dic))
    {
        return;
    }
    
    if (IsStrEmpty(object))
    {
        return;
    }
    
    if (IsStrEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

WEIMI_EXTERN void EncodeUnEmptyObjctToArray(NSMutableArray *arr,id object)
{
    if (IsNilOrNull(arr))
    {
        return;
    }
    
    if (IsNilOrNull(object))
    {
        return;
    }
    
    [arr addObject:object];
}

WEIMI_EXTERN void EncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr)
{
    if (IsNilOrNull(dic))
    {
        return;
    }
    
    if (IsStrEmpty(object))
    {
        object = defaultStr;
    }
    
    if (IsStrEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

void EncodeUnEmptyObjctToDic(NSMutableDictionary *dic,NSObject *object, NSString *key)
{
    if (IsNilOrNull(dic))
    {
        return;
    }
    if (IsNilOrNull(object))
    {
        return;
    }
    if (IsStrEmpty(key))
    {
        return;
    }
    
    [dic setObject:object forKey:key];
}

CGFloat GetAdapterHeight(CGFloat height)
{
    if (IS_IPAD) {
        return height * (320.0/375.0);
    }
    else
    {
        if (IS_IPHONE_4) {
            return height * (320.0/375.0);
        }
        else if (IS_IPHONE_5) {
            return height * (320.0/375.0);
        }
        else if (IS_IPHONE_6) {
            return height;
        }
        else if (IS_IPHONE_6_PLUS) {
            return height * (414.0/375.0);
        }
        else
        {
            return height * (320.0/375.0);
        }
    }
    
}

CGFloat GetAdaapterFontSize(CGFloat size)
{
    if (IS_IPAD) {
        return size;
    }
    else
    {
        if (IS_IPHONE_4) {
            return size;
        }
        else if (IS_IPHONE_5) {
            return size;
        }
        else if (IS_IPHONE_6) {
            return size;
        }
        else if (IS_IPHONE_6_PLUS) {
            return size*1.1;
        }
        else
        {
            return size;
        }
    }
}

NSURL* GetImageURL(NSString *url)
{
    if (!url) {
        return nil;
    }
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", BASE_URL,url]];
}
