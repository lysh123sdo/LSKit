//
//  LSLog.h
//  GWBaseLib
//
//  Created by Lyson on 2017/12/22.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Flags accompany each log. They are used together with levels to filter out logs.
 */
typedef NS_OPTIONS(NSUInteger, LSLogFlag){
    /**
     *  0...00001 DDLogFlagError
     */
    LSLogFlagError      = (1 << 0),
    
    /**
     *  0...00010 DDLogFlagWarning
     */
    LSLogFlagWarning    = (1 << 1),
    
    /**
     *  0...00100 DDLogFlagInfo
     */
    LSLogFlagInfo       = (1 << 2),
    
    /**
     *  0...01000 DDLogFlagDebug
     */
    LSLogFlagDebug      = (1 << 3),
    
    /**
     *  0...10000 DDLogFlagVerbose
     */
    LSLogFlagVerbose    = (1 << 4)
};

typedef NS_ENUM(NSUInteger, LSLogLevel){
    /**
     *  No logs
     */
    LSLogLevelOff       = 0,
    
    /**
     *  Error logs only
     */
    LSLogLevelError     = (LSLogFlagError),
    
    /**
     *  Error and warning logs
     */
    LSLogLevelWarning   = (LSLogLevelError   | LSLogFlagWarning),
    
    /**
     *  Error, warning and info logs
     */
    LSLogLevelInfo      = (LSLogLevelWarning | LSLogFlagInfo),
    
    /**
     *  Error, warning, info and debug logs
     */
    LSLogLevelDebug     = (LSLogLevelInfo    | LSLogFlagDebug),
    
    /**
     *  Error, warning, info, debug and verbose logs
     */
    LSLogLevelVerbose   = (LSLogLevelDebug   | LSLogFlagVerbose),
    
    /**
     *  All logs (1...11111)
     */
    LSLogLevelAll       = NSUIntegerMax
};

@interface LSLog : NSObject

///
+(NSInteger)getDDLogLevelByLSLogLevel:(LSLogLevel)logLevel;

+(void)log:(BOOL)asynchronous level:(LSLogLevel)level flag:(LSLogFlag)flag context:(NSInteger)context file:(const char*)file function:(const char*)function line:(int)line tag:(id)tag format:(NSString *)format, ...;

@end
