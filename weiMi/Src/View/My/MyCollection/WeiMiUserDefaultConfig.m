//
//  WeiMiUserDefaultConfig.m
//  weiMi
//
//  Created by 梁宪松 on 16/8/17.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#import "WeiMiUserDefaultConfig.h"

#import <objc/runtime.h>
#import "WeiMiGlobalDefine.h"
#import "NSString+WeiMiNSString.h"

@interface WeiMiUserDefaultConfig()

@property (strong) NSUserDefaults *defaults;

@end

@implementation WeiMiUserDefaultConfig

- (void)registerDefaultSettings
{
    //记录默认设置的值
//    self.token = @"madao";
}

- (void)dealloc
{
    [self unRegisterObserverForSettings];
}

- (id)init
{
    self = [super init];
    if (self)
    {
        [self registerDefaultSettings];
        [self initSettingFromUserDefaults];
        [self registerObserverForSettings];
    }
    return self;
}


+ (void)addObserver:(id)observer selector:(SEL)sel forSetting:(NSString *)settingName
{
    [[NSNotificationCenter defaultCenter] addObserver:observer
                                             selector:sel
                                                 name:[self notificationForProperty:settingName]
                                               object:nil];
}

+ (void)removeObserver:(id)observer forSetting:(NSString *)settingName
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer
                                                    name:[self notificationForProperty:settingName]
                                                  object:nil];
}

+ (WeiMiUserDefaultConfig *)currentConfig
{
    static dispatch_once_t once;
    static WeiMiUserDefaultConfig * __singleton__ = nil;
    dispatch_once( &once, ^{ __singleton__ = [[WeiMiUserDefaultConfig alloc] init]; } );
    return __singleton__;
}

#pragma mark -
#pragma mark engine

//初始化
- (void)initSettingFromUserDefaults
{
    NSArray *propertyNameArr = [self getPropertiesNameList];
    
    for (NSString *propertyName in propertyNameArr)
    {
        NSString *key = [[self class] keyForProperty:propertyName];
        id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
        if (value)
        {
            NSString *selStr = [propertyName getterToSetter];
            SEL sel = NSSelectorFromString(selStr);
            if ([self respondsToSelector:sel])
            {
                SuppressPerformSelectorLeakWarning
                ([self performSelector:sel withObject:value]);
            }
        }
    }
}

- (NSArray *)getPropertiesNameList
{
    NSMutableArray *nameArr = [[NSMutableArray alloc] init];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i< outCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc]
                                  initWithCString:property_getName(property)
                                  encoding:NSUTF8StringEncoding];
        if ([propertyName length]) [nameArr addObject:propertyName];
    }
    free(properties);
    
    return nameArr;
}

/**
 *  注册监听者
 */
- (void)registerObserverForSettings
{
    NSArray *propertyNameArr = [self getPropertiesNameList];
    
    for (NSString *propertyName in propertyNameArr)
    {
        [self addObserver:self
               forKeyPath:propertyName
                  options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                  context:NULL];
    }
}

/**
 *  注销监听者
 */
- (void)unRegisterObserverForSettings
{
    NSArray *propertyNameArr = [self getPropertiesNameList];
    for (NSString *properName in propertyNameArr)
    {
        [self removeObserver:self forKeyPath:properName];
    }
}

/**
 *  key
 */
+ (NSString *)keyForProperty:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"config.%@",propertyName];
}

/**
 *  notificationName
 */
+ (NSString *)notificationForProperty:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"SETTING_KEY_%@_CHANGE_MESSAGE",propertyName];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    id _oldValue = [change objectForKey:NSKeyValueChangeOldKey];
    id _newValue = [change objectForKey:NSKeyValueChangeNewKey];
    
    // 值发生了变动
    if (_oldValue != _newValue) {
        NSString *cacheKey = [WeiMiUserDefaultConfig keyForProperty:keyPath];
        NSString *notifiKey = [WeiMiUserDefaultConfig notificationForProperty:keyPath];
        
        if (_newValue && ![_newValue isKindOfClass:[NSNull class]])
        {
            [[NSUserDefaults standardUserDefaults] setObject:_newValue
                                                      forKey:cacheKey];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:cacheKey];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:notifiKey
                                                            object:nil];
    }
}


@end
