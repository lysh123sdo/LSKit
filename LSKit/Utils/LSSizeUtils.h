//
//  LSSizeUtils.h
//  LSKit
//
//  Created by Lyson on 2018/3/13.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IsValidateArr(arr) ((arr && [arr isKindOfClass:[NSArray class]] && [arr count] > 0))
#define IsValidateResult(result) ((nil != result && [result isKindOfClass:[NSDictionary class]] && [[result objectForKey:@"result"] isEqualToString:REQUEST_SUCCESSFULLY]))
#define IsValidateDic(dic) (nil != dic && [dic isKindOfClass:[NSDictionary class]] && [dic count] > 0)
#define IsValidateString(str) ((nil != str) && ([str isKindOfClass:[NSString class]]) && ([str length] > 0) && (![str isEqualToString:@"(null)"]) && (![str isEqualToString:@"null"]) &&((NSNull *) str != [NSNull null]))
#define IsValidateBool(num) (num == 0 || num == 1)

#define IsValidateLenString(str , minLength) ((nil != str) && ([str isKindOfClass:[NSString class]]) && ([str length] >= minLength) && (![str isEqualToString:@"(null)"]) && (![str isEqualToString:@"null"]) &&((NSNull *) str != [NSNull null]))

#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height

#define iOS8OrLater kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_8_0
#define iOS9OrLater kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_9_0

#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 定义一个空字符串
#define EmptyString     ([NSString stringWithFormat:@""])
#define ZeroString      (@"0")
#define kDefaultValue    @"--"
#define DownIdentifer   ([NSString stringWithFormat:@"↓"])
#define UpIdentifer     ([NSString stringWithFormat:@"↑"])
#define InfoString(str)  ValidString(str,kDefaultValue)
#define ValidString(str,defaultStr)  (IsValidateString(str))?str:(IsValidateString(defaultStr)?defaultStr:@"")

/******************************************************************
 Get Location String
 *****************************************************************/
#define GetLocalizedString(str) ([NSString stringWithFormat:@"%@", NSLocalizedString(str, nil)])
#define PullRefreshHintStr (GetLocalizedString(@"Pull Down Refreshing Hint"))


// -----------------------------------------------------------------
// 判断系统版本
// -----------------------------------------------------------------
#define IS_IOS7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_SYSTEM_VERSION  ([[[UIDevice currentDevice] systemVersion] floatValue])

#import <UIKit/UIKit.h>

@interface LSSizeUtils : NSObject

/**
 * sizeWithContent:font:width:
 *
 * 计算content的size
 */
+ (CGSize)sizeWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width;

@end
