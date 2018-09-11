//
//  LSLogger.m
//  GWBaseLib
//
//  Created by Lyson on 2017/12/21.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import "LSLogger.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "LSLog.h"



@interface LSLogger()

@property (nonatomic , strong) DDFileLogger *fileLogger;
@end

@implementation LSLogger

static const int Logger_RefreshFrequency = 60 * 60 * 24; //刷新周期
static const int Logger_MaxNumFileSize = 1024 * 1024 * 20;  //单个文件最大size
static const int Logger_MaxNumOfFiles = 10;    //最大文件数

+(void)startLogger{
    
    [self shareInstance];
}
+(instancetype)shareInstance{
    
    static dispatch_once_t onceToken;
    static LSLogger *_instance;

    dispatch_once(&onceToken, ^{
       
        
        _instance = [[self alloc] init];
    });
    
    return _instance;
}


-(instancetype)init{
    
    if (self = [super init]) {
        
        [self initLoggerConfig];
    }
    return self;
}

-(void)initLoggerConfig{
    
    
    NSInteger logLevel = [LSLog getDDLogLevelByLSLogLevel:LSLogLevelDef];
//    DDLogError(@"AA")'id<DDLogFormatter>
    
    _fileLogger = [[DDFileLogger alloc] init]; // File Logger
    _fileLogger.rollingFrequency = Logger_RefreshFrequency;
    _fileLogger.maximumFileSize = Logger_MaxNumFileSize;
    _fileLogger.logFileManager.maximumNumberOfLogFiles = Logger_MaxNumOfFiles;
    _fileLogger.logFormatter = (id<DDLogFormatter>)[[LSLoggerFormatter alloc] init];
    
    [DDLog addLogger:_fileLogger withLevel:logLevel];
    [DDLog addLogger:[DDTTYLogger sharedInstance] withLevel:logLevel];

}

/**上传文件到服务器**/
-(void)uploadLogFiles:(void(^)(NSArray *filePaths))complete{
    
    NSArray *files = [self fileNamesInLogDir];
    
    __block NSString *fileDir = self.fileLogger.logFileManager.logsDirectory;
    
    __block NSMutableArray *filePathArray = [NSMutableArray arrayWithCapacity:0];
    
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileDir,obj];

        [filePathArray addObject:filePath];
    }];

    complete(filePathArray);
}


/**获取上传文件名**/
-(NSArray*)fileNamesInLogDir{
    
    NSString *fileDir = self.fileLogger.logFileManager.logsDirectory;
    
    NSError *error = nil;
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:fileDir error:&error];
    
    return files;
}

/**清除日志**/
-(void)clearLogs{

    NSArray *files = [self fileNamesInLogDir];
    
    __block NSString *fileDir = self.fileLogger.logFileManager.logsDirectory;
  
    __weak typeof (self) weakSelf = self;
    
    [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",fileDir,obj];
       
        [weakSelf removeFile:filePath];
    }];
}


-(BOOL)removeFile:(NSString*)filePath{
    
   return  [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
