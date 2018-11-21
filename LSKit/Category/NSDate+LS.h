//
//  NSDate+LS.h
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface NSDate (LS)

/** 时间戳转指定格式日期 */
+ (NSString *)stringStampDate:(NSString *)timesp format:(NSString *)format;
/** 时间戳转指定格式日期（时区转换） */
+ (NSString *)stringStampDate:(NSString *)timesp format:(NSString *)format gmt:(float)gmt;

/** 将标准时间转为客户端需要的形式：不是当天的就显示日期（mm-dd），当天的则显示时间（hh-mm）*/
+ (NSString *)standardDate2MYDate:(NSString *)string;

+ (NSString *)currentDate:(NSString *)dateFormatter;

///将时间转换成时间戳
+(NSString*)timestamp:(NSString *)formatTime andFormatter:(NSString *)format gmt:(NSInteger)gmt;

/// 获取当前时间戳
+(NSString *)getNowTimeTimestamp;

/** 时间戳转指定格式日期 */
+ (NSString *)stringStampDate:(NSString *)timesp withLanguage:(NSString *)language;
@end
