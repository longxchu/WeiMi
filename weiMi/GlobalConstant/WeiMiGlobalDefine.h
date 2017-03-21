//
//  WeiMiGlobalDefine.h
//  weiMi
//
//  Created by 李晓荣 on 16/8/2.
//  Copyright © 2016年 madaoCN. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef WeiMiGlobalDefine_h
#define WeiMiGlobalDefine_h

@class BaseResponse;
//----------------------------------------------------------------------------------------------
#pragma mark - Block functions Block 相关

///block 声明
#ifdef NS_BLOCKS_AVAILABLE
typedef void (^WeiMiBasicBlock)(void);
typedef void (^WeiMiOperationCallBackBlock)(BOOL isSuccess, NSString *errorMsg);
typedef void (^WeiMiCallBackBlockWithResult)(BOOL isSuccess, NSString *errorCode,NSString *errorMsg,id result);
typedef void (^WeiMiArrayBlock)(NSArray *list);

typedef void (^WeiMiCallBackSuccess)(BaseResponse *response);
typedef void (^WeiMiCallBackFailed)(NSString *errorCode,NSString *errorMsg);

#endif

//----------------------------------------------------------------------------------------------
#pragma mark - Thread functions  GCD线程相关

///线程执行方法 GCD
#define PERFORMSEL_BACK(block) dispatch_async(\
dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),\
block)

#define PERFORMSEL_MAIN(block) dispatch_async(dispatch_get_main_queue(),\
block)

///GCD once
#undef	ONCE_GCD
#define ONCE_GCD(once, block) dispatch_once(\
&once, block)


//----------------------------------------------------------------------------------------------

#pragma mark - Assert functions Assert 断言
//WeiMiAssert 断言
#define WeiMiAssert(expression, ...) \
do { if(!(expression)) { \
DLog(@"%@", \
[NSString stringWithFormat: @"Assertion failure: %s in %s on line %s:%d. %@",\
#expression,\
__PRETTY_FUNCTION__,\
__FILE__, __LINE__, \
[NSString stringWithFormat:@"" __VA_ARGS__]]); \
abort(); }\
} while(0)

//----------------------------------------------------------------------------------------------

#pragma mark - KVO property stringFormat functions  KVO 中参数字符串化方法
//# 将宏的参数字符串化，C 函数 strchr 返回字符串中第一个 '.' 字符的位置
#define Keypath(keypath) (strchr(#keypath, '.') + 1)

//----------------------------------------------------------------------------------------------

#pragma mark - Singleton Creation  functions单例创建，统一单例命名调用方式
//单例声明 .h中使用
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;
//单例实现创建 .m中使用
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
return __singleton__; \
}

//----------------------------------------------------------------------------------------------
#pragma mark - Extern and Inline  functions 内联函数  外联函数

/*／WeiMi_EXTERN 外联函数*/
#if !defined(WEIMI_EXTERN)
#  if defined(__cplusplus)
#   define WEIMI_EXTERN extern "C"
#  else
#   define WEIMI_EXTERN extern
#  endif
#endif


/*WeiMi_INLINE 内联函数*/
#if !defined(WEIMI_INLINE)
# if defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
#  define WEIMI_INLINE static inline
# elif defined(__cplusplus)
#  define WEIMI_INLINE static inline
# elif defined(__GNUC__)
#  define WEIMI_INLINE static __inline__
# else
#  define WEIMI_INLINE static
# endif
#endif
//----------------------------------------------------------------------------------------------
#pragma mark - Nil or NULL 为空判断
//是否为空或是[NSNull null]

#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//----------------------------------------------------------------------------------------------
//arc 支持performSelector:
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//----------------------------------------------------------------------------------------------
//日志打印
#ifdef DEBUGLOG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

#ifdef DEBUGLOG
#       define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#       define DLog(...)
#endif

//----------------------------------------------------------------------------------------------
WEIMI_EXTERN NSString* EncodeObjectFromDic(NSDictionary *dic, NSString *key);

WEIMI_EXTERN id        safeObjectAtIndex(NSArray *arr, NSInteger index);

WEIMI_EXTERN NSString     * EncodeStringFromDic(NSDictionary *dic, NSString *key);
WEIMI_EXTERN NSString* EncodeDefaultStrFromDic(NSDictionary *dic, NSString *key,NSString * defaultStr);
WEIMI_EXTERN NSNumber     * EncodeNumberFromDic(NSDictionary *dic, NSString *key);
WEIMI_EXTERN NSDictionary *EncodeDicFromDic(NSDictionary *dic, NSString *key);
WEIMI_EXTERN NSArray      *EncodeArrayFromDic(NSDictionary *dic, NSString *key);
WEIMI_EXTERN NSArray      *EncodeArrayFromDicUsingParseBlock(NSDictionary *dic, NSString *key, id(^parseBlock)(NSDictionary *innerDic));
WEIMI_EXTERN void EncodeUnEmptyStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key);
WEIMI_EXTERN void EncodeUnEmptyObjctToArray(NSMutableArray *arr,id object);
WEIMI_EXTERN void EncodeDefaultStrObjctToDic(NSMutableDictionary *dic,NSString *object, NSString *key,NSString * defaultStr);
WEIMI_EXTERN void EncodeUnEmptyObjctToDic(NSMutableDictionary *dic,NSObject *object, NSString *key);

WEIMI_EXTERN CGFloat GetAdapterHeight(CGFloat height);
WEIMI_EXTERN CGFloat GetAdaapterFontSize(CGFloat size);
//----------------------------------------------------------------------------------------------
/*safe release*/
#undef TT_RELEASE_SAFELY
#define TT_RELEASE_SAFELY(__REF) \
{\
if (nil != (__REF)) \
{\
__REF = nil;\
}\
}
//----------------------------------------------------------------------------------------------
/*本地化转换*/
#undef L
#define L(key) \
[[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"WeiMiBundle"\
ofType:@"bundle"]] localizedStringForKey:(key) value:@"" table:nil]

//----------------------------------------------------------------------------------------------
/*weakSelf 宏*/
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf)  __strong __typeof(&*self)strongSelf = weakSelf;
#define WeakObj(o) __weak typeof(o) o##Weak = o;

//----------------------------------------------------------------------------------------------

/* 字体转换*/
#define kFontSizeWithpx(px) px * 72.0 / 96
#define kFontSizeWithps(ps) kFontSizeWithpx(ps / 2)
#define WeiMiSystemFontWithpx(px) [UIFont systemFontOfSize:kFontSizeWithpx(px)]
#define WeiMiSystemFontWithps(ps) [UIFont systemFontOfSize:kFontSizeWithpx(ps / 2)]

//----------------------------------------------------------------------------------------------
/* 拼凑头像地址*/
WEIMI_EXTERN NSURL* GetImageURL(NSString *url);

//----------------------------------------------------------------------------------------------
/* 读取图片*/
//读取本地图片
#define WEIMI_LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define WEIMI_IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define WEIMI_IMAGENAMED(_pointer) [UIImage imageNamed:_pointer]

//获得头像真实地址
#define WEIMI_IMAGEREMOTEURL(_url) [NSString stringWithFormat:@"%@/%@", BASE_URL, _url]

//占位图片
#define WEIMI_PLACEHOLDER_COMMON [UIImage imageNamed:@"stance"]//PlaceHolder_Rectangle
#define WEIMI_PLACEHOLDER_RECT [UIImage imageNamed:@"stance"]
#endif /* WeiMiGlobalDefine_h */
