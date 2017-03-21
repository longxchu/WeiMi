//
//  WeiMITest.h
//  weiMi
//
//  Created by 李晓荣  16/8/3.
//  Copyright © 2016年 madaoCN. All rights reserved.
//

#ifndef WeiMiEnviConfig_h
#define WeiMiEnviConfig_h

//超时时间
#define DEFAULT_TIMEOUT 30

//测试环境
#ifdef kDevTest

//测试网络连接
#define TEST_NETWORKING_URL @"www.baidu.com"

//测试环境域名
#define BASE_URL @"http://101.201.122.152"
// 版本号，比如1022
#define VERSION_INT 1

// 版本号
#define VERSION_STRING @"1.0.0"

//网络超时时间
#define TIMEOUT 30

//=================================================================================================
//=================================================================================================

//生产环境
#elif kReleaseH

//测试网络连接
#define TEST_NETWORKING_URL @"www.baidu.com"

//生产环境域名
#define BASE_URL @"http://101.201.122.152"
// 版本号，比如1022
#define VERSION_INT 1

// 版本号
#define VERSION_STRING @"1.0.0"

//网络超时时间
#define TIMEOUT 30

#else

#endif


#endif /* WeiMiEnviConfig_h */
