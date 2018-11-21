//
//  GTABaseRequest.m
//  
//
//  Created by Lyson on 16/3/16.
//
//

#import "LSRequest.h"
#import <AFNetworking/AFNetworking.h>

NSString * const LSUploadFilePathKey = @"com.LSCode.upload.path";
NSString * const LSUploadFileNameKey = @"com.LSCode.upload.name";
NSString * const LSUploadFileTypeKey = @"com.LSCode.upload.type";
NSString * const LSUploadFileKeyKey = @"com.LSCode.upload.key";

@interface LSRequest()
{
    
    
}

/*****
 *request url for severce
 */
@property (nonatomic , strong) NSString *url;

/*****
 *text infos need upload
 */
@property (nonatomic , strong) NSDictionary *postBody;

/*****
 *files need upload
 */
@property (nonatomic , strong) NSArray *postFiles;

@end


@implementation LSRequest

+(AFHTTPSessionManager*)httpManager{
    
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
  
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    });
    
    return manager;
}

/**
 *  提交文件
 *
 *  @param engine
 *  @param delegate
 *
 *  @return
 */
+(NSURLSessionTask*)uploadFileWithUrl:(LSApiEngine*)engine delegate:(id<LSRequestDelegate>)delegate{

    LSRequest *request = [self shareRequest];
    request.engine = engine;
    request.delegate = delegate;
    [request uploadFiles];
    return request.sessionTask;
}

/**
 *  提交文本信息
 *
 *  @param engine
 *  @param delegate
 *
 *  @return
 */
+(NSURLSessionTask*)postData:(LSApiEngine*)engine delegate:(id<LSRequestDelegate>)delegate{
    
    LSRequest *request = [self shareRequest];
    request.engine = engine;
    request.delegate = delegate;
    [request postData];
    
    return request.sessionTask;
}


/**
 *  提交文本信息
 *
 *  @param engine
 *  @param delegate
 *
 *  @return
 */
+(NSURLSessionTask*)getData:(LSApiEngine*)engine delegate:(id<LSRequestDelegate>)delegate{
    
    LSRequest *request = [self shareRequest];
    request.engine = engine;
    request.delegate = delegate;
    [request getData];
    
    return request.sessionTask;
}

/**
 *  更具API下载文件 --
 *
 *  @param engine
 *  @param delegate
 *
 *  @return
 */
+(NSURLSessionTask*)downLoadFiles:(LSApiEngine*)engine delegate:(id<LSRequestDelegate>)delegate{
    
    LSRequest *request = [self shareRequest];
    request.engine = engine;
    request.delegate = delegate;
    [request downLoadFiles];
    
    return request.sessionTask;
}

/**
 *  更具URL下载文件
 *
 *  @param url
 *  @param delegate
 *
 *  @return
 */
+(NSURLSessionTask*)downLoadFilesWithUrl:(NSString*)url delegate:(id<LSRequestDelegate>)delegate{
    
    LSRequest *request = [self shareRequest];
    request.url = url;
    request.delegate = delegate;
    [request downLoadFiles];
    
    return request.sessionTask;
}

+(instancetype)shareRequest{
    
    LSRequest *request = [[self alloc] init];

    return request;

}

-(instancetype)init{

    if (self = [super init]) {
        
        
    }
    
    return self;
}

- (NSTimeInterval)requestTimeoutInterval {
    return self.engine.requestTimeoutInterval;
}

-(NSDictionary*)postBody{

    if (!_postBody) {

        _postBody = self.engine.postBody;
    }
    
    return _postBody;
}

-(NSString*)url{

    if (!_url) {
        
        _url = self.engine.url;
    }
    
    return _url;

}

-(NSArray*)postFiles{
    
    if (!_postFiles) {
        _postFiles = [self.engine.files copy];
    }
    return _postFiles;
}


/**
 **文件上传
 **/
-(void)uploadFiles{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    __weak NSArray *files = self.postFiles;
    
    __block AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    [self.engine.httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [serializer setValue:obj forHTTPHeaderField:key];
        
    }];
    
    NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:self.url parameters:self.postBody constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [files enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
            NSDictionary *dic = (NSDictionary*)obj;
            
            NSString *fileName = [dic objectForKey:LSUploadFileNameKey];
            NSString *key = [dic objectForKey:LSUploadFileKeyKey];
            NSString *type = [dic objectForKey:LSUploadFileTypeKey];
            NSString *filePath = [dic objectForKey:LSUploadFilePathKey];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:key fileName:fileName mimeType:type error:nil];
        }];
        
    } error:nil];
    
    [request setTimeoutInterval:[self requestTimeoutInterval]];
    
    self.sessionTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      
                      dispatch_async(dispatch_get_main_queue(), ^{
                          
                          if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequest:progress:)]) {
                              
                              [self.delegate lsRequest:self progress:uploadProgress];
                          }
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                     
                  }];
    
    [self.sessionTask resume];
    
}

/**
 *  文字信息上传
 */
-(void)getData{
    
    
    AFHTTPSessionManager *manager = [LSRequest httpManager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = [self requestTimeoutInterval];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    
    [self.engine.httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        
    }];
    
    self.sessionTask = [manager GET:self.url parameters:self.postBody progress:^ void (NSProgress *uploadProgress){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequest:progress:)]) {
            
            [self.delegate lsRequest:self progress:uploadProgress];
        }
        
    } success:^ void (NSURLSessionDataTask *task, id _Nullable responseObject){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequestFinish: response:)]) {
            
            [self.delegate lsRequestFinish:self response:responseObject];
        }
        
    } failure:^ void (NSURLSessionDataTask * _Nullable task, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequestFail:error:)]) {
            
            [self.delegate lsRequestFail:self error:error];
        }
        
    }];
    
}

/**
 *  文字信息上传
 */
-(void)postData{

    AFHTTPSessionManager *manager = [LSRequest httpManager];

    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = [self requestTimeoutInterval];
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;

    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];

    [self.engine.httpHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        
    }];
   
    self.sessionTask = [manager POST:self.url parameters:self.postBody progress:^ void (NSProgress *uploadProgress){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequest:progress:)]) {
            
            [self.delegate lsRequest:self progress:uploadProgress];
        }
        
    } success:^ void (NSURLSessionDataTask *task, id _Nullable responseObject){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequestFinish: response:)]) {
            
            [self.delegate lsRequestFinish:self response:responseObject];
        }
        
    } failure:^ void (NSURLSessionDataTask * _Nullable task, NSError *error){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequestFail:error:)]) {
            
            [self.delegate lsRequestFail:self error:error];
        }
        
    }];
    
}

/**
 *  下载文件
 */
-(void)downLoadFiles{

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    self.sessionTask = [manager downloadTaskWithRequest:request progress:^ void (NSProgress *uploadProgress){
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequest:progress:)]) {
            
            [self.delegate lsRequest:self progress:uploadProgress];
        }
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequestGetDestinationUrl:response:)]) {

            return [self.delegate lsRequestGetDestinationUrl:self response:response];
        }
        return nil;
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lsRequest:filePath:error:)]) {
            
            [self.delegate lsRequest:self filePath:filePath error:error];
        }
        
    }];
    [self.sessionTask resume];
    
}

-(void)dealloc{

    DLog(@"%@释放了",NSStringFromClass([self class]));

}

#pragma mark -

@end
