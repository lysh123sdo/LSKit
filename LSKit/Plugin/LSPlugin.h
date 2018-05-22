//
//  LSPlugin.h
//  LSKitDemo
//
//  Created by Lyson on 2018/5/20.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LSPluginLog(frmt, ...) NSLog((frmt),##__VA_ARGS__)
#else
#define LSPluginLog(frmt, ...)
#endif




/**
 组件代理
 */
@protocol LSPluginDelegate<NSObject>

/// 初始化
-(void)pluginInit;
/// 释放注销组件
-(void)pluginDealloc;
/// 类被注册到组件管理器中,只有在注册时候会调用一次
+(void)pluginInitialize;

@end

@protocol LSPluginApplicationDelegate<NSObject>

#pragma mark - App生命周期代理
/// 启动App
+ (BOOL)pluginApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
///  横竖屏
+(UIInterfaceOrientationMask)pluginApplication:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;

@end


/**
 组件资源
 */
@protocol LSPluginDataSource<NSObject>

/// 组件名
-(NSString*)pluginName;

/// 组件ID
-(NSString*)pluginId;

@end


/**
 组件
 */
@interface LSPlugin : NSObject

/// 开始启动
-(void)start;

/// 停止并注销
-(void)stop;

@end
