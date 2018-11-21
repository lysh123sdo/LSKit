//
//  GTAApiEngine.h
//  GTANetProject
//
//  Created by Lyson on 16/3/17.
//  Copyright © 2016年 GTANetProject. All rights reserved.
//

//==================================================================================
//存放杂物
//==================================================================================

#import <Foundation/Foundation.h>

#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#   define ELog(err) {if(err) DLog(@"%@", err)}
#else
#   define DLog(...)
#   define ELog(err)
#endif


/**
 请求配置器
 */
@interface LSApiEngine : NSObject
{
    
    
}

/**
 主机地址
 */
@property (nonatomic , strong , readonly) NSString *host;

/**
 请求链接
 */
@property (nonatomic , strong , readonly) NSString *url;

/**
 api接口
 */
@property (nonatomic , strong , readonly) NSString *api;

/**
 用户信息
 */
@property (nonatomic , strong , readonly) NSString *userInfo;

/**
 请求参数
 */
@property (nonatomic , strong , readonly) NSDictionary *postBody;

/**
 文件
 */
@property (nonatomic , strong , readonly) NSArray *files;

@property (nonatomic , strong ) NSMutableDictionary *httpHeaders;
@property (nonatomic , strong ,readonly) NSMutableDictionary *headers;
/**
 初始化

 @param url api
 @param parameters 参数
 @param files 文件
 @return LSApiEngine初始化返回的对象
 */
-(instancetype)initWithUrl:(NSString*)url parameters:(NSDictionary*)parameters files:(NSArray*)files;

/**
 设置参数

 @param url api
 @param parameters 参数
 @param files 文件
 */
-(void)setUrl:(NSString*)url parameters:(NSDictionary*)parameters files:(NSArray*)files;


/**
 加密，需要加密重写此方法  body请求参数 不同的加密方式定义不同的Engine   返回的数据将作为新的请求参数

 @param body 需要加密的参数
 @return 加密后参数
 */
-(NSDictionary*)encryBody:(NSDictionary*)body;

-(void)addHttpHeader:(NSString*)header key:(NSString*)key;

-(NSDictionary*)encryHeader:(NSDictionary*)header;

/**
 编码，需要编码重写此方法   body请求参数   返回的数据将作为新的请求参数

 @param body 解密参数
 @return 解密后的参数
 */
-(NSDictionary*)unicodeBody:(NSDictionary*)body;


/**
 超时设置

 @return 超时设置
 */
- (NSTimeInterval)requestTimeoutInterval;

-(void)initEvent;
@end
