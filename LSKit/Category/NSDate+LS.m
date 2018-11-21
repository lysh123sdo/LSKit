//
//  NSDate+LS.m
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import "NSDate+LS.h"
#import <LSKit/LSKit.h>
@implementation NSDate (LS)

+ (NSString *)stringStampDate:(NSString *)timesp format:(NSString *)format {
    
    return [self stringStampDate:timesp format:format gmt:0];
}

+ (NSString *)stringStampDate:(NSString *)timesp withLanguage:(NSString *)language {
    NSString *timeString = [timesp stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (timeString.length < 10) {
        return @"";
    }
    NSString *second = [timeString substringToIndex:10];
    NSString *milliscond = [timeString substringFromIndex:10];
    NSString * timeStampString = [NSString stringWithFormat:@"%@.%@",second,milliscond];
    NSTimeInterval _interval=[timeStampString doubleValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];//timeZoneWithName:@"UTC"
    [dateFormatter setTimeZone:timeZone];
    
    if ([language isEqualToString:@"en"]) {
        dateFormatter.dateFormat = @"hh:ss:mm a";
        NSString * str1 = [dateFormatter stringFromDate:date];
        dateFormatter.dateFormat = @"LLLL dd, yyyy";
        NSString * str = [dateFormatter stringFromDate:date];
        return [NSString stringWithFormat:@"%@ on %@",str1,str];
    }else {
        
        dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm:ss";
        return [dateFormatter stringFromDate:date];
    }
  
}

+ (NSString *)stringStampDate:(NSString *)timesp format:(NSString *)format gmt:(float)gmt {
    NSString *timeString = [timesp stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (timeString.length >= 10) {
        NSString *second = [timeString substringToIndex:10];
        NSString *milliscond = [timeString substringFromIndex:10];
        NSString * timeStampString = [NSString stringWithFormat:@"%@.%@",second,milliscond];
        NSTimeInterval _interval=[timeStampString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:gmt*60*60];//timeZoneWithName:@"UTC"
        [dateFormatter setTimeZone:timeZone];
        [dateFormatter setDateFormat:format]; //@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        NSString *dateString = [dateFormatter stringFromDate:date];
        
        return dateString;
    }
    return @"";
}
+ (NSString *)standardDate2MYDate:(NSString *)string {
    NSString *MYDate = @"";
    if ( string ) {
        NSString *today = [self currentDate:nil];
        NSString *tempStr = @"";
        if ( string.length > 10 ) {
            tempStr = [string substringToIndex:10];
        }
        
        // 当天
        if ( NSOrderedSame == [tempStr compare:today] )
        {
            if ( string.length > 11 ){
                MYDate = [string substringFromIndex:11];
                if ( MYDate.length > 5 ) {
                    MYDate = [MYDate substringToIndex:5];
                }
            }
        }
        // 非当天
        else
        {
            if ( string.length > 10 ){
                MYDate = [string substringToIndex:10];
                MYDate = [MYDate substringFromIndex:5];
            }
        }
    }
    return MYDate;
}

///将时间转换成时间戳
+(NSString*)timestamp:(NSString *)formatTime andFormatter:(NSString *)format gmt:(NSInteger)gmt{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:gmt*60*60];
    
    [formatter setTimeZone:timeZone];
    
    NSDate* date = [formatter dateFromString:formatTime];
  
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    
    return [NSString stringWithFormat:@"%ld",timeSp];
    
}

+ (NSString *)currentDate:(NSString *)dateFormatter {
    NSDate *senddate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ( nil == dateFormatter ) {
        dateFormatter = @"yyyy-MM-dd";
    }
    [formatter setDateFormat:dateFormatter];
    NSString *locationString = [formatter stringFromDate:senddate];
    return locationString;
}

/// 获取当前时间戳
+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}


@end
