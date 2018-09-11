//
//  LSPluginManager.h
//  LSKitDemo
//
//  Created by Lyson on 2018/5/20.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 组件代理
 */
@protocol LSPluginManagerDelegate<NSObject>

-(void)initializePluginManager;

@end


/**
 组件控制器
 */
@interface LSPluginManager : NSObject<LSPluginManagerDelegate>

-(NSArray*)runningPlugin;

-(void)existApp;

/**
 获取实例对象

 @return LSPluginManager
 */
+(instancetype)shareInstance;

/**
 将组件注册到注册列表
 
 @param pluginId 组件ID
 @param pluginClass 需要注册的组件类
 */
-(BOOL)registerPlugin:(NSString*)pluginId pluginClass:(NSString*)pluginClass;

/// 添加黑名单
-(void)addBlankList:(NSString*)pluginId clssess:(NSArray*)classes;

/**
 注销组件
 
 @param pluginId 组件ID
 */
-(void)unRegisterPluginByPluginId:(NSString*)pluginId;

/**
 启动组件
 
 @param pluginId 组件id
 @param pluginClass 组件类名
 */
-(BOOL)startRunPlugin:(NSString*)pluginId pluginClass:(NSString*)pluginClass;

/**
 停止正在的组件
 
 @param pluginId 组件ID
 */
-(void)stopRunningPluginByPluginId:(NSString*)pluginId;

/// 组件是否已经运行
-(BOOL)pluginIsRunning:(NSString*)pluginId className:(NSString*)className;

/**
 获取一个正在运行的组件
 
 @param pluginId 组件ID
 @return 运行中的组件
 */
-(id)findRunningPluginByPluginId:(NSString*)pluginId;

///通过class找组件ID
-(id)findPluginByClassName:(NSString*)className;

/// 是否需要关闭组件
-(BOOL)sholdStopRunningPlugin:(NSArray*)navViewController;

/**
 判断组件是否已经在注册列表
 
 @param pluginId 组件ID
 @return YES NO
 */
-(BOOL)isInRegisterList:(NSString*)pluginId;

/**
 判断组件是否已经启动
 
 @param pluginId 组件ID
 @return YES NO
 */
-(BOOL)isInRunningList:(NSString*)pluginId;

/**
 获取最顶端运行的控制器所属的组件
 
 @param className 类名
 @return 组件ID
 */
-(NSString*)topViewControllerPlugin:(NSString*)className;

@end
