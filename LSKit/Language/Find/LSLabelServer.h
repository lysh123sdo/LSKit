//
//  LSLabelServer.h
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/2/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/// 分隔符
extern NSString * const LSTextSeparatorSymbol;

/// 立即返回对应的繁简英 LSTextServer(key,format,...)
//extern NSString * LSTextServer(id, NSString *, ...);
NSString * LSTextServer(NSString *key, NSString *formate, ...);
/// 返回所有内容的拼接 'key''LSTextSeparatorSymbol''formate''LSTextSeparatorSymbol''...'
NSString * LSTextChangeLanguage(id, NSString *, ...);

NS_ASSUME_NONNULL_END


/**
 获取当前语言下的文本内容

 @param key 文本内容的键
 @param formate 默认的文本(如果key没有查找到,则返回formate)
 @param ... 拼接的内容
 @return 文本内容
 */
#ifndef LS_TEXT
#define LS_TEXT(key,formate, ...) LSTextServer((key)?:@"", (formate)?:@"", ##__VA_ARGS__, nil)
#endif


/**
 获取当前语言下的文本内容
 
 @discussion 没有立即返回文本内容,而是在View即将展示的时候通过key获取内容,因此有时时改变文本语言的能力

 @param key 文本内容的键
 @param formate 默认的文本(如果key没有查找到,则返回formate)
 @param ... 拼接的内容
 @return @[key, formate]
 
 @see lstext_callStoreMethodNow
 */
#ifndef LS_TEXT_Language
#define LS_TEXT_Language(key, formate, ...) LSTextChangeLanguage((key)?:@"", (formate)?:@"", ##__VA_ARGS__, nil)
#endif
