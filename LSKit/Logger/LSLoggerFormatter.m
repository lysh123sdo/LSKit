//
//  LSLoggerFormatter.m
//  Pods
//
//  Created by Lyson on 2017/12/21.
//

#import "LSLoggerFormatter.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface LSLoggerFormatter ()<DDLogFormatter> {
    NSDateFormatter *_dateFormatter;
}

@end

@implementation LSLoggerFormatter

- (instancetype)init {
    return [self initWithDateFormatter:nil];
}

- (instancetype)initWithDateFormatter:(NSDateFormatter *)aDateFormatter {
    if ((self = [super init])) {
        if (aDateFormatter) {
            _dateFormatter = aDateFormatter;
        } else {
            _dateFormatter = [[NSDateFormatter alloc] init];
            [_dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4]; // 10.4+ style
            [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
        }
    }
    
    return self;
}

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *dateAndTime = [_dateFormatter stringFromDate:(logMessage->_timestamp)];
    
    return [NSString stringWithFormat:@"%@  %@  %lu  %@  %@",logMessage->_fileName,logMessage->_function,(unsigned long)logMessage->_line, dateAndTime, logMessage->_message];
}

@end
