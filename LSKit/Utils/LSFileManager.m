//
//  LSFileManager.m
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import "LSFileManager.h"

@interface LSFileManager()
//获取程序的Home目录路径
+(NSString *)getHomeDirectoryPath;

//获取document目录路径
+(NSString *)getDocumentPath;

//获取Cache目录路径
+(NSString *)getCachePath;

//获取Library目录路径
+(NSString *)getLibraryPath;

//获取Tmp目录路径
+(NSString *)getTmpPath;
@end

@implementation LSFileManager


+(NSString *)getHomeDirectoryPath {
    return NSHomeDirectory();
}

+(NSString *)getDocumentPath {
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

+(NSString *)getCachePath {
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

+(NSString *)getLibraryPath {
    NSArray *Paths=NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path=[Paths objectAtIndex:0];
    return path;
}

+(NSString *)getTmpPath {
    return NSTemporaryDirectory();
}

/*返回Documents下的指定文件路径(加创建)*/
+(NSString *)getDirectoryForDocuments:(NSString *)dir {
    NSError* error;
    NSString* path = [[self getDocumentPath] stringByAppendingPathComponent:dir];
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
       
    }
    return path;
}

/*返回Caches下的指定文件路径*/
+(NSString *)getDirectoryForCaches:(NSString *)dir {
    NSError* error;
    NSString* path = [[self getCachePath] stringByAppendingPathComponent:dir];
    
    if(![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error])
    {
        //        DLog(@"create dir error: %@",error.debugDescription);
    }
    return path;
}

/*删除指定文件*/
+(void)DeleteFile:(NSString *)filepath {
    if([[NSFileManager defaultManager]fileExistsAtPath:filepath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filepath error:nil];
    }
}
/*删除Documents目录下所有文件*/
+(void)deleteAllForDocumentsDir:(NSString *)dir {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[self getDirectoryForDocuments:dir] error:nil];
    for (NSString* filename in fileList) {
        [fileManager removeItemAtPath:[self getPathForDocuments:filename inDir:dir] error:nil];
    }
}

/*删除caches目录下所有文件*/
+(void)deleteAllForCachesDir:(NSString *)dir {
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[self getDirectoryForCaches:dir] error:nil];
    for (NSString* filename in fileList) {
        [fileManager removeItemAtPath:[self getPathForCaches:filename inDir:dir] error:nil];
    }
}

/*单个文件大小*/
+(long long)fileSizeAtPath:(NSString*)filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

/*文件夹大小*/
+(float)folderSizeAtPath:(NSString*)folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


+ (NSString *)getPathForDocuments:(NSString *)filename {
    return [[self getDocumentPath] stringByAppendingPathComponent:filename];
}
+(NSString *)getPathForDocuments:(NSString *)filename inDir:(NSString *)dir {
    return [[self getDirectoryForDocuments:dir] stringByAppendingPathComponent:filename];
}
+(NSString *)getPathForCaches:(NSString *)filename {
    return [[self getCachePath] stringByAppendingPathComponent:filename];
}
+(NSString *)getPathForCaches:(NSString *)filename inDir:(NSString *)dir {
    return [[self getDirectoryForCaches:dir] stringByAppendingPathComponent:filename];
}
@end
