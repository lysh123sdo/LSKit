//
//  GWBaseDataBridge.h
//  GWUIKit
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 com.gw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSLibBaseDataBridge : NSObject

@property(assign , nonatomic)int bridgeNum;
@property(copy , nonatomic)NSString *bridgeString;
@property(copy , nonatomic)NSMutableDictionary *bridgeDict;
@property(copy , nonatomic)NSMutableArray *bridgeArray;

- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath action:(SEL)action;
- (void)removeBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)removeBridgeObserver:(NSObject *)observer;
- (void)removeBridgeForKeyPath:(NSString *)keyPath;
- (void)removeAllBridge;


- (void)addKeyPath:(NSString *)KeyPath;
- (void)removeAllKeyPath;
- (void)sendSignalWith:(NSString *)key value:(id)value;

@end
