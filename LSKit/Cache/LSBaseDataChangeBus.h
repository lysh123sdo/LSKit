//
//  GWBaseDataBridge.h
//  EMQUIKit
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 com.gw. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 数据变动通知处理
 */
@interface LSBaseDataChangeBus : NSObject



/**
 添加变动属性监听

 @param observer 监听者
 @param keyPath key
 @param action 变动后执行函数
 */
- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath action:(SEL)action;
///移除
- (void)removeBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
///移除
- (void)removeBridgeObserver:(NSObject *)observer;
///移除
- (void)removeBridgeForKeyPath:(NSString *)keyPath;
///移除
- (void)removeAllBridge;
///变动通知监听
- (void)sendSignalWith:(NSString *)key value:(id)value;
///添加属性
- (void)addKeyPath:(NSString *)key;
@end
