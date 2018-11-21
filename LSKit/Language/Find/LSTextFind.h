//
//  LSTextFind.h
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/10.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// key format 之间的分割内容
extern NSString * const LSTextSeparatorSymbol;
extern NSString *languageBundleName;
/**
 通过key匹配不通语言环境下的文本内容
 */
@interface LSTextFind : NSObject

/// 通过key查询类容
+ (NSString *)findKeyText:(NSArray *)total language:(NSString *)language;
/// 是否通过key查找
+ (BOOL)isFindLanguage:(NSString *)language target:(__kindof UIView *)view;
/// 返回当前语言
+ (NSString *)currentLanguage;

+(BOOL)resetLanguageKeys;

@end
