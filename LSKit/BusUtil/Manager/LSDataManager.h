//
//  QTDataManager.h
//  QuotData
//
//  Created by Lyson on 2017/12/25.
//  Copyright © 2017年 QuotData. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDataModel.h"

/**参数请求Key**/
extern NSString* const LSEvent;
/**参数请求Key**/
extern NSString* const LSParameter;

/**请求唯一标示,客户端使用**/
extern NSString* const LSRequestSeq;


/**
 代理
 */
@protocol LSDataManagerDelegate<NSObject>

/**组件数据接收**/
-(NSString*)pluginDataEvent;

-(NSString*)serverConnectEvent;

-(NSString*)mobileNetworkingEvent;

/**登录状态接收**/
-(NSString*)loginEvent;

/**系统语言字段配置配置**/
-(NSString*)languageEvent;

/**接收参数**/
-(LSDataModel*)dataModelWithParameter:(id)parameter event:(NSString*)event requestIdentifire:(NSString*)requestIdentifire;

@end


/**
 行情模块数据管理器 管理UI界面发送的请求 处理socket接口回调
 */
@interface LSDataManager : NSObject <LSDataManagerDelegate>

@property (nonatomic , strong) NSString *language;
/**
 保持socket请求事件模型
 */
@property (atomic , strong) NSMutableDictionary *socketReqDic;

/**
 获取一个实例对象 --由各个子类做具体实现

 @return LSDataManager实例
 */
+(instancetype)shareInstance;

/**
 释放数据销毁
 */
+(void)deallocInstance;

/**
 config，，组件直接调用config可初始化 不需要调用shareInstance
 */
+(void)config;

/**
 初始化时initEvent，用以初始化一些数据
 */
-(void)initEvent;

/**
 清除所有请求
 */
-(void)clearAllRequest;


/**
 判断请求是否已经存在

 @param requestSeq 请求的Seq
 @return YES 存在 NO 不存在
 */
-(BOOL)requestIsExist:(NSString*)requestSeq;


/**
 根据类名找请求

 @param classs 类名
 @return 请求Model
 */
-(LSDataModel*)findAExistRequest:(Class)classs;

/**
 根据类名移除请求

 @param clss 类名
 */
-(void)removeRequestByClass:(Class)clss;

/**
 移除请求

 @param requestKey 唯一标识
 */
-(void)removeRequestByKey:(NSString*)requestKey;

/**
 存储请求模型

 @param dataModel 模型
 @param key 键值 --唯一标识--假如两个key相同，前者会被后者替换
 */
-(void)setSocketRequestValue:(LSDataModel*)dataModel key:(NSString*)key;



@end
