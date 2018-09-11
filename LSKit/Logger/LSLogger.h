//
//  LSLogger.h
//  GWBaseLib
//
//  Created by Lyson on 2017/12/21.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSLoggerFormatter.h"
//#import "DDLog.h"


#ifdef DEBUG
#define LSLogLevelDef  LSLogLevelDebug
#else
#define LSLogLevelDef  LSLogLevelDebug
#endif

#define LSLogError(frmt, ...) [LSLog log : NO                 \
                                   level : LSLogLevelDef                \
                                    flag : LSLogFlagError                \
                                 context : 0                \
                                    file : __FILE__           \
                                function : __FUNCTION__               \
                                    line : __LINE__           \
                                     tag : nil               \
                                  format : (frmt), ## __VA_ARGS__];

#define LSLogWarn(frmt, ...) [LSLog log : NO                 \
                                    level : LSLogLevelDef                \
                                    flag : LSLogFlagWarning                \
                                context : 0                \
                                    file : __FILE__           \
                                function : __FUNCTION__               \
                                    line : __LINE__           \
                                    tag : nil               \
                                    format : (frmt), ## __VA_ARGS__];

#define LSLogInfo(frmt, ...) [LSLog log : NO                 \
                                    level : LSLogLevelDef                \
                                    flag : LSLogFlagInfo                \
                                context : 0                \
                                    file : __FILE__           \
                                function : __FUNCTION__               \
                                    line : __LINE__           \
                                    tag : nil               \
                                format : (frmt), ## __VA_ARGS__];

#define LSLogDebug(frmt, ...) [LSLog log : NO                 \
                                level : LSLogLevelDef                \
                                flag : LSLogFlagDebug                \
                            context : 0                \
                                file : __FILE__           \
                            function : __FUNCTION__               \
                                line : __LINE__           \
                                tag : nil               \
                            format : (frmt), ## __VA_ARGS__];

#define LSLogVerbose(frmt, ...) [LSLog log : NO                 \
                                    level : LSLogLevelDef                \
                                    flag : LSLogFlagVerbose                \
                                context : 0                \
                                    file : __FILE__           \
                                function : __FUNCTION__               \
                                    line : __LINE__           \
                                    tag : nil               \
                                format : (frmt), ## __VA_ARGS__];


/**收集打印日志及bug操作，bug暂用bugly替代**/
@interface LSLogger : NSObject
///开启日志
+(void)startLogger;

/**获取日志文件路径-用以上传**/
-(void)uploadLogFiles:(void(^_Nullable)(NSArray * _Nullable filePaths))complete;

/**清除日志**/
-(void)clearLogs;

@end


