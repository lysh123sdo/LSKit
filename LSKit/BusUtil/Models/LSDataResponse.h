//
//  TDDataResponse.h
//  TradeData
//
//  Created by Lyson on 2018/1/12.
//  Copyright © 2018年 TradeData. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define GWDataManagerLog(frmt, ...) NSLog((frmt),##__VA_ARGS__)
#else
#define GWDataManagerLog(frmt, ...)
#endif

@interface LSDataResponse : NSObject

/**
 回到数据

 @param data 数据
 @param statusCode 状态码
 @param headCodes 头部请求码
 @param msg 提示消息
 @param event 回调的事件
 @return 成功失败，--默认成功
 */
+(BOOL)responsePackege:(id)data statusCode:(NSInteger)statusCode headCodes:(NSDictionary*)headCodes msg:(NSString*)msg event:(NSString*)event;

/**
 回到数据
 
 @param data 数据
 @param statusCode 状态码
 @param headCodes 头部请求码
 @param msg 提示消息
 @param event 回调的事件
 @return 成功失败，--默认成功
 @cache 是否缓存
 */
+(BOOL)responsePackege:(id)data statusCode:(NSInteger)statusCode headCodes:(NSDictionary*)headCodes msg:(NSString*)msg event:(NSString*)event level:(int)level cache:(BOOL)cache;

/**
 获取模型属性表

 @param cls 模型对象
 @return 属性表
 */
+(NSArray*)keysOfClass:(Class)cls;

/**
 从属性表中获取数据

 @param data 需要获取的模型对象
 @param keys 需要获取数据的键值表
 @return 获取后的数据
 */
+(NSDictionary*)infosFromObj:(id)data keys:(NSArray*)keys;

@end
