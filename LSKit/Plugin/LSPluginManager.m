//
//  LSPluginManager.m
//  LSKitDemo
//
//  Created by Lyson on 2018/5/20.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import "LSPluginManager.h"
#import "LSPlugin.h"
#import <YYKit/YYKit.h>


@interface LSPluginManager()

/// 注册的组件
@property (nonatomic , strong) YYThreadSafeDictionary *plugins;
/// 组件下的控制器，对UI组件有用
@property (nonatomic , strong) YYThreadSafeDictionary *pluginClasses;
/// 正在运行的组件
@property (nonatomic , strong) YYThreadSafeDictionary *runningPlugins;

@end

@implementation LSPluginManager

static LSPluginManager *_pluginManager;
static dispatch_once_t _onceToken;

/**
 获取实例对象
 
 @return LSPluginManager
 */
+(instancetype)shareInstance{
    
    dispatch_once(&_onceToken, ^{
       
        _pluginManager = [self new];
    });
    
    return _pluginManager;
}

-(instancetype)init{
    
    if (self = [super init]) {
        
        [self initData];
        
        [self initLifyDelegate];
    }
    return self;
}

-(void)initData{
    
    _plugins = [YYThreadSafeDictionary dictionaryWithCapacity:0];
    _runningPlugins = [YYThreadSafeDictionary dictionaryWithCapacity:0];
    _pluginClasses = [YYThreadSafeDictionary dictionaryWithCapacity:0];
}


-(void)initLifyDelegate{
    
    if ([self respondsToSelector:@selector(initializePluginManager)]) {
        [self performSelector:@selector(initializePluginManager)];
    }
}


/**
 将组件注册到注册列表

 @param pluginId 组件ID
 @param pluginClass 需要注册的组件类
 */
-(BOOL)registerPlugin:(NSString*)pluginId pluginClass:(NSString*)pluginClass{
    
    NSAssert((pluginId != nil && pluginId.length > 0), @"pluginId不能为空");
    NSAssert((pluginClass != nil), @"pluginClass不能为空");
    
    if (![self isPluginClass:pluginClass]) {
        LSPluginLog(@"Class:%@不是LSPlugin的子类,注册失败",pluginClass);
        return NO;
    }
    
    if ([self isInRegisterList:pluginId]) {
        LSPluginLog(@"%@ %@ 已经注册",pluginClass,pluginId);
        return NO;
    }
    
    //注册路由
    Class cls = NSClassFromString(pluginClass);
    
    if ([cls respondsToSelector:@selector(pluginInitialize)]) {
        [cls performSelector:@selector(pluginInitialize)];
    }
    
    [_plugins setValue:pluginClass forKey:pluginId];
    
    return YES;
}


/**
 启动组件

 @param pluginId 组件id
 @param pluginClass 组件类名
 */
-(BOOL)startRunPlugin:(NSString*)pluginId pluginClass:(NSString*)pluginClass{
    
    NSAssert((pluginId != nil && pluginId.length > 0), @"pluginId不能为空");
    NSAssert((pluginClass != nil), @"pluginClass不能为空");
    
    if ([self isInRunningList:pluginId]) {
        LSPluginLog(@"%@ %@ 已经已启动",pluginClass,pluginId);
        return NO;
    }
    
    Class cls = NSClassFromString(pluginClass);
    LSPlugin *plugin = [[cls alloc] init];
    if (![plugin.pluginId isEqualToString:pluginId]) {
        LSPluginLog(@"%@ %@ 启动失败 ID 不匹配",pluginClass,pluginId);
        return NO;
    }
    
    //获取组件所有的控制器 lib库不注册控制器
    if (!plugin.isLibrary && [plugin respondsToSelector:@selector(registerViewControllers)]) {
        NSArray* viewControllers= [plugin performSelector:@selector(registerViewControllers)];
        [self.pluginClasses setValue:viewControllers forKey:pluginId];
    }
    
    [_runningPlugins setValue:plugin forKey:pluginId];
    
    [plugin start];
    
    return YES;
}

/**
 注销组件

 @param pluginId 组件ID
 */
-(void)unRegisterPluginByPluginId:(NSString*)pluginId{
    
    if (![self isInRegisterList:pluginId]) {
        return;
    }
    
    //注销组件执行
    NSString *pluginClass = [self.plugins objectForKey:pluginId];
    Class cls = NSClassFromString(pluginClass);
    if ([cls respondsToSelector:@selector(pluginUnInitialize)]) {
        [cls performSelector:@selector(pluginUnInitialize)];
    }
    
    [self.plugins removeObjectForKey:pluginId];
}

/**
 停止正在的组件

 @param pluginId 组件ID
 */
-(void)stopRunningPluginByPluginId:(NSString*)pluginId{
    
    if (![self isInRunningList:pluginId]) {
        return;
    }
    
    LSPlugin *plugin = [self.runningPlugins objectForKey:pluginId];
    [plugin stop];
    
    [self.pluginClasses removeObjectForKey:pluginId];
    [self.runningPlugins removeObjectForKey:pluginId];
}


/// 组件是否已经运行
-(BOOL)pluginIsRunning:(NSString*)pluginId{
    
    //是否注册
    BOOL isInRegister = [self isInRegisterList:pluginId];
    if (!isInRegister) {
        return NO;
    }
    
    //是否已经运行
    BOOL isInRunningList = [self isInRunningList:pluginId];
    if (isInRunningList) {
        return YES;
    }
    
    //启动
    NSString *pluginClass = [self findPluginClassByPluginId:pluginId];
    BOOL run = [self startRunPlugin:pluginId pluginClass:pluginClass];
   
    return run;
}

/// 从注册表中获取类名
-(NSString*)findPluginClassByPluginId:(NSString*)pluginId{
    return [self.plugins objectForKey:pluginId];
}


/**
 获取一个正在运行的组件

 @param pluginId 组件ID
 @return 运行中的组件
 */
-(id)findRunningPluginByPluginId:(NSString*)pluginId{
    
    if (![self isInRunningList:pluginId]) {
        return nil;
    }
    
    return [self.runningPlugins objectForKey:pluginId];
}

-(NSArray*)runningPlugin{
    return self.runningPlugins.allKeys;
}

/**
 判断组件是否已经启动
 
 @param pluginId 组件ID
 @return YES NO
 */
-(BOOL)isInRunningList:(NSString*)pluginId{
    
    __block BOOL result = NO;
    __weak NSString *weakPluginId = pluginId;
    [_runningPlugins enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([weakPluginId isEqualToString:key]) {
            
            result = YES;
            *stop = YES;
        }
        
    }];
    
    return result;
}

/**
 判断组件是否已经在注册列表

 @param pluginId 组件ID
 @return YES NO
 */
-(BOOL)isInRegisterList:(NSString*)pluginId{
    
    __block BOOL result = NO;
    __weak NSString *weakPluginId = pluginId;
    [_plugins enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        if ([weakPluginId isEqualToString:key]) {
            
            result = YES;
            *stop = YES;
        }
        
    }];
    
    return result;
}


/**
 判断是否是规定格式的组件

 @param pluginClass 组件类
 @return YES NO
 */
-(BOOL)isPluginClass:(NSString*)pluginClass{
    
    Class pluginC = NSClassFromString(pluginClass);
    
    if ([pluginC isSubclassOfClass:[LSPlugin class]]) {
        return YES;
    }
    return NO;
}

/**
 获取最顶端运行的控制器所属的组件

 @param className 类名
 @return 组件ID
 */
-(NSString*)topViewControllerPlugin:(NSString*)className{
    
    NSArray *keys = [self.pluginClasses allKeys];
    
    for (NSString * key in keys) {
    
        NSArray *viewControllers = [self.pluginClasses objectForKey:key];
        
        for (NSString *viewControllerClass in viewControllers) {
            
            if ([viewControllerClass isEqualToString:className]) {
                return key;
            }
        }
    }
    
    return nil;
}
@end
