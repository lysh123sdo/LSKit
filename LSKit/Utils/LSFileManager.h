//
//  LSFileManager.h
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface LSFileManager : NSObject

//返回Documents下的指定文件路径(加创建)
+(NSString *)getDirectoryForDocuments:(NSString *)dir;

//返回Caches下的指定文件路径
+(NSString *)getDirectoryForCaches:(NSString *)dir;

//删除指定文件
+(void)DeleteFile:(NSString *)filepath;

//删除Documents目录下所有文件
+(void)deleteAllForDocumentsDir:(NSString *)dir;

//删除caches目录下所有文件
+(void)deleteAllForCachesDir:(NSString *)dir;

//单个文件大小
+(long long)fileSizeAtPath:(NSString*)filePath;

//文件夹大小
+(float)folderSizeAtPath:(NSString*)folderPath;
@end
