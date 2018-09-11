//
//  LSDataModelProtocol.h
//  LSKit
//
//  Created by Lyson on 2018/2/7.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSDataModelProtocol <NSObject>

/**
 初始化事件，使用后需要super
 */
-(void)requestInitEvent;

/**
 收到参数

 @param parameter 参数
 @return 返回对应的提交请求数据 或者nil
 */
-(NSData*)receiveParameter:(id)parameter;


/**
 远程监听

 @return 远程监听事件
 */
-(NSArray*)listenerRemoteEvent;

///回调
-(NSString*)responseEvent;

/**
 本地请求数据处理
 */
-(void)localDataTask;

/**
 参数不合法执行事件
 */
-(void)parameterDataTask;


/**
 等待任务

 @return YES 完成等待 NO 继续等待
 */
-(BOOL)requestWaitingTask;


/**
 缓存数据oK 由缓存模块的KVO触发
 */
-(void)cacheDataIsOkTask;

/// 缓存清理操作
-(void)cacheDataClearTask;


/**
 手机无网
 */
-(void)noMobileNetWorkTask;

/**
 服务器
 */
-(void)noServerConnectTask;


/**
 无权限
 */
-(void)noAuthorizationTask;

/**
 无回调监听任务
 */
-(void)noRemoteResponseTask;

/**
 即将启动请求
 */
-(void)willRunTask;

/**
 超时任务
 */
-(void)dataTimeOutTask;

/**
 超时事件设置

 @return 超时时间
 */
-(NSInteger)timeOutCount;


/**
 定义需要的权限 默认YES  不允许NO

 @return YES 有 NO 无
 */
-(BOOL)userAutho;


/**
 定义服务器连接权限 默认

 @return YES OK  不允许NO
 */
-(BOOL)serverConnect;


/**
 定义网络权限

 @return 默认YES  不允许NO
 */
-(BOOL)mobileNet;


/**
 local is

 @return YES  remote is NO
 */
-(BOOL)localOrRemote;


/**
 监听

 @return 是否是监听任务
 */
-(BOOL)isListener;

@end
