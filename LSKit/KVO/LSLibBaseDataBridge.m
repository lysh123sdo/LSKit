
//
//  GWBaseDataBridge.m
//  GWUIKit
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 com.gw. All rights reserved.
//

#import "LSLibBaseDataBridge.h"
#import <objc/runtime.h>

@interface LSLibBaseDataBridge (){
    
    NSMutableDictionary *observers;
    NSMutableDictionary *actions;
    NSMutableArray *keyPaths;
   
    NSMutableArray *addKeyPath;
    NSMutableArray *propertys;
}


@end
@implementation LSLibBaseDataBridge

- (void)dealloc{
    [self removeAllBridge];
    [keyPaths removeAllObjects];
    observers = nil;
    actions = nil;
    keyPaths = nil;
    
    [addKeyPath removeAllObjects];
    addKeyPath = nil;
    [self removeAllKeyPath];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        observers = [[NSMutableDictionary alloc] init];
        actions = [[NSMutableDictionary alloc] init];
        keyPaths = [[NSMutableArray alloc] init];
       
        addKeyPath = [[NSMutableArray alloc] init];
        propertys = [[NSMutableArray alloc] init];
        [self getAllIvarList];
        
    }
    return self;
}

- (void)addBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath action:(SEL)action{
//    @try{
//        [self removeObserver:self forKeyPath:keyPath];
//    }@catch (NSException *error){
//    }@finally{
//    }
    [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    NSHashTable *objs = [observers objectForKey:keyPath];
    if (!objs) {
        objs = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
        [observers setObject:objs forKey:keyPath];
    }
    if (![objs containsObject:observer]) {
        [objs addObject:observer];
    }
    NSString *className;// = NSStringFromClass([observer class]);
    className = [NSString stringWithFormat:@"%@_%p" , keyPath , observer];
    NSMutableArray *actionArr = [actions objectForKey:className];
    if (!actionArr) {
        actionArr = [[NSMutableArray alloc] init];
    }
    if (![actionArr containsObject:NSStringFromSelector(action)]) {
        [actionArr addObject:NSStringFromSelector(action)];
    }
    [actions setObject:actionArr forKey:className];
    if (![keyPaths containsObject:keyPath]) {
        [keyPaths addObject:keyPath];
    }
}

- (void)removeBridgeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    NSHashTable *objs = [observers objectForKey:keyPath];
    if (objs) {
        [objs removeObject:observer];
        NSString *className;// = NSStringFromClass([observer class]);
        className = [NSString stringWithFormat:@"%@_%p" , keyPath , observer];
        [actions removeObjectForKey:className];
    }
}

- (void)removeBridgeObserver:(NSObject *)observer{
    for (int i = 0 ; i < observers.count ; i++) {
        NSString *keyPath = [observers allKeys][i];
        [self removeBridgeObserver:observer forKeyPath:keyPath];
    }
}

- (void)removeBridgeForKeyPath:(NSString *)keyPath{
    NSHashTable *objs = [observers objectForKey:keyPath];
    if (objs) {
        for (int i = (int)objs.count - 1 ; i >= 0 ; i--) {
            id obj = [objs allObjects][i];
            [objs removeObject:obj];
            NSString *className;// = NSStringFromClass([obj class]);
            className = [NSString stringWithFormat:@"%@_%p" , keyPath , obj];
            [actions removeObjectForKey:className];
        }
    }
}

- (void)removeAllBridge{
//    for (int i = 0 ; i < keyPaths.count ; i ++) {
//        NSString *keyPath = keyPaths[i];
//        @try{
//            [self removeObserver:self forKeyPath:keyPath];
//        }@catch (NSException *error){
//        }@finally{
//        }
//    }
    for (int i = 0 ; i < observers.count ; i++) {
        NSString *keyPath = [observers allKeys][i];
        NSHashTable *objs = [observers objectForKey:keyPath];
        if (objs) {
            [objs removeAllObjects];
        }
    }
    [observers removeAllObjects];
    [actions removeAllObjects];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    

    NSHashTable *objs = [observers objectForKey:keyPath];
    if (objs && [[objs allObjects] isKindOfClass:[NSArray class]]) {
        [[objs allObjects] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                @synchronized(self){
                    NSString *className;
                    className = [NSString stringWithFormat:@"%@_%p" , keyPath , obj];
                    NSMutableArray *actionArr = [actions objectForKey:className];
                    [actionArr enumerateObjectsUsingBlock:^(id  _Nonnull actionName, NSUInteger idx, BOOL * _Nonnull stop) {
                        SEL action = NSSelectorFromString(actionName);
                        if (action && [obj respondsToSelector:action]) {
//                            [obj performSelector:action withObject:change];
//
                            if (!obj) { return; }
                           
                            IMP imp = [obj methodForSelector:action];
                            void (*func)(id, SEL) = (void *)imp;
                            func(obj, action);
                            
                            
                        }
                    }];
                }
            }
        }];
    }
  
}

- (void)addKeyPath:(NSString *)key{
    [addKeyPath addObject:key];
}

- (void)removeAllKeyPath{
    [addKeyPath removeAllObjects];
}

- (void)sendSignalWith:(NSString *)key value:(id)value{
    if ([propertys containsObject:key] || [propertys containsObject:[NSString stringWithFormat:@"_%@" , key]]) {
        [self setValue:value forKey:key];
    }else{
        [self observeValueForKeyPath:key ofObject:value change:@{@"new":value,@"old":value} context:nil];
    }
}

//遍历获取Person类所有的成员变量IvarList
- (void) getAllIvarList {
    unsigned int methodCount = 0;
    Ivar * ivars = class_copyIvarList([self class], &methodCount);
    for (unsigned int i = 0; i < methodCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
//        const char * type = ivar_getTypeEncoding(ivar);
        //        NSLog(@"Person拥有的成员变量的类型为%s，名字为 %s ",type, name);
        [propertys addObject:[NSString stringWithFormat:@"%s" , name]];
    }
    free(ivars);
}

@end
