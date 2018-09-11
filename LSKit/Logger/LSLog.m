//
//  LSLog.m
//  GWBaseLib
//
//  Created by Lyson on 2017/12/22.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import "LSLog.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation LSLog


+(void)log:(BOOL)asynchronous level:(LSLogLevel)level flag:(LSLogFlag)flag context:(NSInteger)context file:(const char*)file function:(const char*)function line:(int)line tag:(id)tag format:(NSString *)format, ... {
    
    va_list args;
    
    if (format) {
        va_start(args, format);
        
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        
        va_end(args);
        
        
        NSString *dFile = [NSString stringWithFormat:@"%s",file];
        NSString *dFunction = [NSString stringWithFormat:@"%s",function];
        
        DDLogLevel dLevel = [self getDDLogLevelByLSLogLevel:level];
        DDLogFlag dFlag = [self getDDLogFlagByLSLogFlag:flag];
       
        DDLogMessage *msg = [[DDLogMessage alloc] initWithMessage:message level:dLevel flag:dFlag context:context file:dFile function:dFunction line:line tag:tag options:(DDLogMessageOptions)0 timestamp:nil];
      
        [DDLog.sharedInstance log:asynchronous message:msg];
    }
    
    
}


+(DDLogFlag)getDDLogFlagByLSLogFlag:(LSLogFlag)logFlag{
    
    
    switch (logFlag) {
        case LSLogFlagInfo:
            return DDLogFlagInfo;
            break;
            
        case LSLogFlagDebug:
            return DDLogFlagDebug;
            break;
            
            
        case LSLogFlagError:
            return DDLogFlagError;
            break;
            
        case LSLogFlagVerbose:
            return DDLogFlagVerbose;
            break;
            
        case LSLogFlagWarning:
            return DDLogFlagWarning;
            break;
            
            
        default:
            break;
    }
    
    return DDLogFlagVerbose;
    
}

+(NSInteger)getDDLogLevelByLSLogLevel:(LSLogLevel)logLevel{
    
    
    switch (logLevel) {
        case LSLogLevelAll:
            return DDLogLevelAll;
            break;
            
        case LSLogLevelOff:
            return DDLogLevelOff;
            break;
            
            
        case LSLogLevelInfo:
            return DDLogLevelInfo;
            break;
            
        case LSLogLevelDebug:
            return DDLogLevelDebug;
            break;
            
        case LSLogLevelError:
            return DDLogLevelError;
            break;
            
        case LSLogLevelVerbose:
            return DDLogLevelVerbose;
            break;
            
        case LSLogLevelWarning:
            return DDLogLevelWarning;
            break;
            
            
        default:
            break;
    }

    return DDLogLevelVerbose;
    
}

@end
