//
//  LSRequestModel.h
//  
//
//  Created by Lyson on 16/3/16.
//
//
//===============================
//模型实体基础类 ---用于获取、解析与映射数据 所有模型都继承该类
//===============================

#import <Foundation/Foundation.h>

#import "LSApiEngine.h"
#import "LSRequest.h"
#import "LSRequestStatusModel.h"
/**
 模型实体基础类 ---用于获取、解析与映射数据 所有模型都继承该类
 */
@interface LSRequestModel : NSObject<LSRequestDelegate>




/**
 POST方法

 @param url api
 @param parameters 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+(NSURLSessionTask*)postData:(NSString*)url
                  parameters:(NSDictionary *)parameters
                     success:(void(^)(id model))success
                        fail:(void(^)(id model))fail;


/**
 get请求

 @param url api
 @param parameters 参数
 @param success 成功回调
 @param fail 失败回调
 @return task
 */
+(NSURLSessionTask*)getData:(NSString*)url
                 parameters:(NSDictionary *)parameters
                    success:(void(^)(id model))success
                       fail:(void(^)(id model))fail;


/**
 文件上传

 @param url api
 @param parameters 参数
 @param files 文件
 @param success 成功回到
 @param fail 失败回调
 @param progress 进度
 @return task
 */
+(NSURLSessionTask*)uploadFiles:(NSString*)url
                     parameters:(NSDictionary *)parameters
                          files:(NSArray*)files
                        success:(void(^)(id model))success
                           fail:(void(^)(id model))fail
                       progress:(void(^)(NSProgress *progress))progress;

-(LSApiEngine*)getApiEngine;

-(LSRequestStatusModel*)getResponseSerializer;

@end

