//
//  LSRequestModel.m
//  
//
//  Created by Lyson on 16/3/16.
//
//

#import "LSRequestModel.h"
#import "LSRequestFliter.h"
//默认不加密
#define DefaultLevel Api_NullEncry


@interface LSRequestModel()
{
    LSApiEngine *engine;
    
    LSRequestStatusModel *serializerModel;
    
    LSRequestFliter *fliter;
}

/**
 用户信息
 */
@property (nonatomic , weak) NSString* userInfo;

/**
 成功回调
 */
@property (nonatomic , strong) void (^ success) (id model);

/**
 失败回调
 */
@property (nonatomic , strong) void (^ fail) (id model);

/**
 进度
 */
@property (nonatomic , strong) void (^ progress) (NSProgress *progress);


@end

@implementation LSRequestModel

#pragma mark -请求发起---

+(NSURLSessionTask*)postData:(NSString*)url parameters:(NSDictionary *)parameters success:(void(^)(id model))success fail:(void(^)(id model))fail{

    LSRequestModel *model = [[self alloc] init];
    model.success = success;
    model.fail = fail;
    return [model postDataWithUrl:url paramas:parameters];
}

+(NSURLSessionTask*)getData:(NSString*)url parameters:(NSDictionary *)parameters success:(void(^)(id model))success fail:(void(^)(id model))fail{
    
    LSRequestModel *model = [[self alloc] init];
    model.success = success;
    model.fail = fail;
    return [model getDataWithUrl:url paramas:parameters];
    
}

+(NSURLSessionTask*)uploadFiles:(NSString*)url parameters:(NSDictionary *)parameters files:(NSArray*)files success:(void(^)(id model))success fail:(void(^)(id model))fail progress:(void(^)(NSProgress *progress))progress{
    
    LSRequestModel *model = [[self alloc] init];
    model.success = success;
    model.fail = fail;
    model.progress = progress;
    return [model uploadFilesWithUrl:url paramas:parameters files:files];
}

#pragma mark ----请求发起 end-----


-(instancetype)init{

    if (self = [super init]) {
        
        engine = [self getApiEngine];
        
        serializerModel = [self getResponseSerializer];
        
        fliter = [self getFliter];
    }

    return self;
}

-(LSRequestFliter*)getFliter{
    
    if (!fliter) {
        
        fliter = [[LSRequestFliter alloc] init];
    }
    
    return fliter;
}

-(LSApiEngine*)getApiEngine{

    if (!engine) {
        
        engine = [[LSApiEngine alloc] init];
    }
    
    return engine;
}

-(LSRequestStatusModel*)getResponseSerializer{

    return [LSRequestStatusModel new];
}

/**
 *  提交文字请求数据
 *
 *  @param url URL
 *  @param paramas  提交的数据
 */
-(NSURLSessionTask*)postDataWithUrl:(NSString*)url paramas:(NSDictionary*)paramas{
    
    [engine setUrl:url parameters:paramas files:nil];

   return [LSRequest postData:engine delegate:(id<LSRequestDelegate>)self];
}

/**
 *  提交文字请求数据
 *
 *  @param url URL
 *  @param paramas  提交的数据
 */
-(NSURLSessionTask*)getDataWithUrl:(NSString*)url paramas:(NSDictionary*)paramas{
    
    [engine setUrl:url parameters:paramas files:nil];
    
    return [LSRequest getData:engine delegate:(id<LSRequestDelegate>)self];
}

/**
 *  上传文件
 *
 *  @param url URL
 *  @param paramas  提交的数据
 *  @param files    文件
 */
-(NSURLSessionTask*)uploadFilesWithUrl:(NSString*)url paramas:(NSDictionary*)paramas files:(NSArray*)files{
    
    [engine setUrl:url parameters:paramas files:nil];
    
    return [LSRequest postData:engine delegate:(id<LSRequestDelegate>)self];
}

#pragma mark - 解析操作


-(NSDictionary*)getMapping{

    return nil;
}

-(BOOL)filterHandler{
    
    if (fliter) {
        
        BOOL result = [fliter filterInterception:serializerModel engine:engine];
        
        if (result) {
            return YES;
        }
        
        result = [fliter fliterRedirection:serializerModel engine:engine];
        
        if (result) {
            return YES;
        }
    }
    
    return NO;
}

-(void)convertResponse:(id)response{

    
    
    
    if ([NSJSONSerialization isValidJSONObject:response]) {
        
        //进行映射
        if ([serializerModel isKindOfClass:[LSRequestStatusModel class]]) {
            
           serializerModel = [serializerModel statusModel:self data:response mapping:[self getMapping]];
            
            if ([self filterHandler]) {
                return;
            }
            if (self.success) {
                
                self.success(serializerModel);
            }
            
        }else {
        //不进行映射 解析之后原样返回
            
            if ([self filterHandler]) {
                return;
            }
            
            if (self.success) {
                
                self.success(response);
            }
        }
        
        
    }else{
        
        serializerModel.code = LSRequestError;
        serializerModel.errorCode = LSError_Unknow;
        serializerModel.msg = @"数据格式无法解析";
        
        if ([self filterHandler]) {
            return;
        }
        
        if (self.success) {
            
            self.success(serializerModel);
        }
    }
    
   

}

#pragma mark- 数据请求结果代理

-(void)lsRequestFinish:(LSRequest*)request response:(id)responseObject{
    
    DLog(@"\n<<-----------返回--------------------\n Url == %@\n Res == %@\n------------------------------->>", request.engine.url, responseObject);

    [self convertResponse:responseObject];
}

-(void)lsRequestFail:(LSRequest*)request error:(NSError*)error{
    
    if ([serializerModel isKindOfClass:[LSRequestStatusModel class]]) {
        
        [serializerModel statusModelWithError:error];
        
        if ([self filterHandler]) {
            return;
        }
        
        DLog(@"数据请求失败 : %@",error);
        if (self.fail) {
            self.fail(serializerModel);
        }
    }
  
}

-(void)lsRequest:(LSRequest*)request progress:(NSProgress*)progress{
    
    if (self.progress) {
        
        self.progress(progress);
    }
    
}



-(void)dealloc{
    
    DLog(@"%@释放了",NSStringFromClass([self class]));
}

@end
