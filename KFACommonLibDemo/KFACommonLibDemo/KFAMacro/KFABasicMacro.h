//
//  KFABasicMacro.h
//  KFACommonLibDemo
//
//  Created by KFAaron on 2019/2/13.
//  Copyright © 2019 KFAaron. All rights reserved.
//

#ifndef KFABasicMacro_h
#define KFABasicMacro_h

// 屏宽高
#define kScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height)
// 状态栏高度
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

// 判断NSString, NSArrsy, NSDictionary, NSSet, NSNumber
#define IsString(__string) ([(__string) isKindOfClass:[NSString class]])
#define IsStringWithAnyText(__string) (IsString(__string) && ([((NSString *)__string) length] > 0))

#define IsArray(__array) ([(__array) isKindOfClass:[NSArray class]])
#define IsArrayWithAnyItem(__array) (IsArray(__array) && ([((NSArray *)__array) count] > 0))

#define IsDictionary(__dict) ([(__dict) isKindOfClass:[NSDictionary class]])
#define IsDictionaryWithAnyKeyValue(__dict) (IsDictionary(__dict) && ([[((NSDictionary *)__dict) allKeys] count] > 0))

#define IsNumber(__number) ([(__number) isKindOfClass:[NSNumber class]])

// 打印
#ifdef DEBUG
#define KFALog(format, ...) NSLog(format, ## __VA_ARGS__)
#else
#define KFALog(format, ...)
#endif

#ifdef DEBUG
# define KFADetailLog(fmt, ...) NSLog((@"文件名:%s\n" "函数名:%s\n" "行号:%d \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
# define KFADetailLog(...);
#endif

// 内存
#ifndef kfa_weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define kfa_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define kfa_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define kfa_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define kfa_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef kfa_strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define kfa_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define kfa_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define kfa_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define kfa_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif

#endif /* KFABasicMacro_h */
