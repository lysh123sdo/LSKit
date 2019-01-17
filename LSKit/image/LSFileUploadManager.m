//
//  LSFileUploadManager.m
//  GWBaseLib
//
//  Created by kurt on 2018/7/31.
//

#import "LSFileUploadManager.h"


@interface LSFileUploadManager()

@property (nonatomic , strong) AFHTTPSessionManager *manager;

@property (nonatomic , strong) NSMutableDictionary *cacheDict;

@end

@implementation LSFileUploadManager

+ (LSFileUploadManager *)shareManager {
    
    static LSFileUploadManager *_shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shareManager = [[LSFileUploadManager alloc] init];
        
    });
    return _shareManager;
    
}
    
- (void)uploadImage:(UIImage *)image fileInfos:(NSDictionary*)fileInfos progress:(nullable void (^)(NSProgress *uploadProgress, NSString *fileName))uploadProgressBlock andFinished:(void(^)(id response,NSString *name, NSError *error))responseBlock {
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    double scaleNum = (double)300*1024/imageData.length;
//    NSLog(@"图片压缩率：%f",scaleNum);
    
    NSString *fileName = [fileInfos objectForKey:@"fileName"];
    
    if(scaleNum <1){
        
        imageData = UIImageJPEGRepresentation(image, scaleNum);
    }else{
        
        imageData = UIImageJPEGRepresentation(image, 0.1);
        
    }
    
    if ([fileName containsString:@"selfie"]) {
        imageData = UIImageJPEGRepresentation(image, 0.7);
    }
    
    [self requestWithData:imageData fileInfos:fileInfos andUrlString:self.url andParameters:nil progress:^(NSProgress *pro) {
        uploadProgressBlock(pro,fileName);
    } andFinished:^(id response, NSError *error) {
        
        responseBlock(response,fileName,error);
    }];
}


//- (void)uploadImage:(UIImage *)image fileInfos:(NSDictionary*)fileInfos progress:(void (^)(NSProgress *))uploadProgressBlock andFinished:(void (^)(id, NSError *))responseBlock {
//    
//    NSString *fileName = [self getImageName:image];
//    NSData *imageData = UIImageJPEGRepresentation(image, 1);
//    double scaleNum = (double)300*1024/imageData.length;
//    NSLog(@"图片压缩率：%f",scaleNum);
//    
//    if(scaleNum <1){
//        
//        imageData = UIImageJPEGRepresentation(image, scaleNum);
//    }else{
//        
//        imageData = UIImageJPEGRepresentation(image, 0.1);
//        
//    }
//    
//    [self requestWithData:imageData fileInfos:fileInfos andUrlString:self.url andParameters:nil progress:uploadProgressBlock andFinished:responseBlock];
//}

- (void)cancelUploadImage:(UIImage *)image {
    
    NSString *key = [self getImageName:image];
    NSURLSessionUploadTask *task = self.cacheDict[key];
    [task cancel];
    [self.cacheDict removeObjectForKey:key];
}
    
- (void)cancelUploadImageWithName:(NSString *)name {
    
    NSURLSessionUploadTask *task = self.cacheDict[name];
    [task cancel];
    [self.cacheDict removeObjectForKey:name];
}

- (void)requestWithData:(NSData *)data fileInfos:(NSDictionary*)fileInfos andUrlString:(NSString *)urlString andParameters:(id) parameters progress:(void (^)(NSProgress *))uploadProgressBlock andFinished:(void(^)(id response, NSError *error))responseBlock{
    
    NSString *fileName = [fileInfos objectForKey:@"fileName"];
    NSString *key = [fileInfos objectForKey:@"fileKey"];
    NSString *fileType = [fileInfos objectForKey:@"fileType"];
    
    NSMutableURLRequest *request=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:urlString  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
      
         [formData appendPartWithFileData:data name:key fileName:fileName mimeType:fileType];
        
    } error:nil];
    
    
    NSURLSessionUploadTask *task = [self.manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        uploadProgressBlock(uploadProgress);
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        responseBlock(responseObject,error);
    }];
    [task resume];
    [self.cacheDict setObject:task forKey:fileName];
}

- (NSString *)getImageName:(UIImage *)image {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
    [formormat setDateFormat:@"HHmmss"];
    NSString *dateString = [formormat stringFromDate:date];
    NSString *fileName = [NSString  stringWithFormat:@"%@.png",dateString];
    
    return fileName;
}

+ (NSString *)errorMsgByCode:(NSInteger)code {
    
//    EMQErrorCodeState_10012 = 10012, //上传失败,文件不能超过2M
//    EMQErrorCodeState_10013 = 10013, //上传失败,文件为空
    return nil;
}

- (AFHTTPSessionManager *)manager {
    
    if (!_manager) {
        
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:@""] sessionConfiguration:config];
        manager.operationQueue.maxConcurrentOperationCount = 3;
        manager.requestSerializer.timeoutInterval = 10.0f;
        manager.requestSerializer = [AFJSONRequestSerializer new];
        
//        NSMutableString *userAgent = [NSMutableString stringWithString:[[UIWebView new] stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"]];
//        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                                 @"text/json",
                                                                 @"text/javascript",
                                                                 @"text/html",
                                                                 @"application/x-www-form-urlencoded",
                                                                 @"text/plain",
                                                                 @"image/gif",
                                                                 @"image/png",
                                                                 nil];
        _manager = manager;
    }
    return _manager;
}

@end
