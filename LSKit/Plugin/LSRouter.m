//
//  LSRouter.m
//  LSKit
//
//  Created by Lyson on 2018/5/22.
//

#import "LSRouter.h"
#import <YYKit/YYKit.h>
#import "LSPluginManager.h"
@interface LSRouterParams : NSObject

@property (readwrite, nonatomic, strong) LSRouterOptions *routerOptions;
@property (readwrite, nonatomic, strong) NSDictionary *openParams;
@property (readwrite, nonatomic, strong) NSDictionary *extraParams;
@property (readwrite, nonatomic, strong) NSDictionary *controllerParams;

@end

@implementation LSRouterParams

- (instancetype)initWithRouterOptions: (LSRouterOptions *)routerOptions openParams: (NSDictionary *)openParams extraParams: (NSDictionary *)extraParams{
    [self setRouterOptions:routerOptions];
    [self setExtraParams: extraParams];
    [self setOpenParams:openParams];
    return self;
}

- (NSDictionary *)controllerParams {
    NSMutableDictionary *controllerParams = [NSMutableDictionary dictionaryWithDictionary:self.routerOptions.defaultParams];
    [controllerParams addEntriesFromDictionary:self.extraParams];
    [controllerParams addEntriesFromDictionary:self.openParams];
    return controllerParams;
}

- (NSDictionary *)getControllerParams {
    return [self controllerParams];
}
@end


@interface LSRouterOptions()


@property (readwrite, nonatomic, strong) Class openClass;
@property (readwrite, nonatomic, copy) LSRouterOpenCallback callback;

@end

@implementation LSRouterOptions

+ (instancetype)routerOptionsWithPresentationStyle: (UIModalPresentationStyle)presentationStyle
                                   transitionStyle: (UIModalTransitionStyle)transitionStyle
                                     defaultParams: (NSDictionary *)defaultParams
                                            isRoot: (BOOL)isRoot
                                           isModal: (BOOL)isModal{
    
    LSRouterOptions *option = [LSRouterOptions new];
    
    option.presentationStyle = presentationStyle;
    option.transitionStyle = transitionStyle;
    option.defaultParams = defaultParams;
    option.shouldOpenAsRootViewController = isRoot;
    option.modal = isModal;
    
    return option;
}


+ (instancetype)routerOptions {
    return [self routerOptionsWithPresentationStyle:UIModalPresentationNone
                                    transitionStyle:UIModalTransitionStyleCoverVertical
                                      defaultParams:nil
                                             isRoot:NO
                                            isModal:NO];
}

@end


@interface LSBaseRouter()
/// 路由表
@property (readwrite, nonatomic, strong) YYThreadSafeDictionary *routes;
/// 通过路由打开的操作记录
@property (readwrite, nonatomic, strong) YYThreadSafeDictionary *routesOpenCount;

@end

@implementation LSBaseRouter

- (id)init {
    if ((self = [super init])) {
        self.routes = [YYThreadSafeDictionary dictionaryWithCapacity:0];
        self.routesOpenCount = [YYThreadSafeDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)map:(NSString *)format toController:(Class)controllerClass{
    [self map:format toController:controllerClass withOptions:nil];
}


/**
 注册一个控制器

 @param format URL
 @param controllerClass 绑定跳转的控制器
 @param options 操作
 */
- (void)map:(NSString *)format
toController:(Class)controllerClass
withOptions:(LSRouterOptions *)options{
    
    if (!format) {
        @throw [NSException exceptionWithName:@"RouteNotProvided"
                                       reason:@"Route #format is not initialized"
                                     userInfo:nil];
        return;
    }
    if (!options) {
        options = [LSRouterOptions routerOptions];
    }
    options.openClass = controllerClass;
    [self.routes setObject:options forKey:format];
}


/**
 推出一个控制器

 @param animated 是否动画 YES NO
 @param url 回调参数URL
 @param extraParams 回调的参数
 */
- (void)pop:(BOOL)animated format:(NSString*)url extraParams:(NSDictionary *)extraParams{
    
    LSRouterParams *params = [self routerParamsForUrl:url extraParams: extraParams];
    LSRouterOptions *option = params.routerOptions;
    
    NSString *pluginId = option.pluginId;
    
    if (option.callback) {
        option.callback(extraParams);
    }
    
    NSString *className = [self popViewControllerReturnClassName:animated];
    
    if (pluginId) {
        [self releaseRouterCount:className pluginId:pluginId];
    }
}

- (void)pop:(BOOL)animated{
    
    [self popViewControllerReturnClassName:animated];
}

-(NSString*)popViewControllerReturnClassName:(BOOL)animated{
    
    NSString *className;
    
    if (self.navigationController.presentedViewController) {
        
        className = NSStringFromClass(self.navigationController.presentedViewController.class);
        
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    else {
        
        className = NSStringFromClass(self.navigationController.viewControllers.lastObject.class);
        
        [self.navigationController popViewControllerAnimated:animated];
    }
    
    return className;
}

/// 打开一个远程链接
- (void)openExternal:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)open:(NSString *)url {
    [self open:url animated:YES extraParams:nil toCallback:nil];
}


/**
 打开一个URL

 @param url URL
 @param animated 是否动画 YES NO
 */
- (void)open:(NSString *)url animated:(BOOL)animated{
    [self open:url animated:animated extraParams:nil toCallback:nil];
}


/**
 打开一个URL

 @param url URL
 @param animated 是否动画 YES NO
 @param extraParams 参数
 @param callback 回调
 */
- (void)open:(NSString *)url
    animated:(BOOL)animated
 extraParams:(NSDictionary *)extraParams
  toCallback:(LSRouterOpenCallback)callback
{
    
    LSRouterParams *params = [self routerParamsForUrl:url extraParams: extraParams];
    LSRouterOptions *options = params.routerOptions;
    
    if (callback) {
        options.callback = callback;
        params.routerOptions = options;
    }
    
    if (!self.navigationController) {
        return;
    }

    UIViewController *controller = [self viewController:params];
    
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }

    if ([options isModal]) {
        if ([controller.class isSubclassOfClass:UINavigationController.class]) {
            [self.navigationController presentViewController:controller
                                                    animated:animated
                                                  completion:nil];
        }
        else {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            navigationController.modalPresentationStyle = controller.modalPresentationStyle;
            navigationController.modalTransitionStyle = controller.modalTransitionStyle;
            [self.navigationController presentViewController:navigationController
                                                    animated:animated
                                                  completion:nil];
        }
    }
    else if (options.shouldOpenAsRootViewController) {
        [self.navigationController setViewControllers:@[controller] animated:animated];
    }
    else {
        [self.navigationController pushViewController:controller animated:animated];
    }
}

/**
 通过URL获取一个对象
 
 @param url URL
 @param extraParams 参数
 @return 需要获取的对象 未获取到返回nil
 */
-(UIViewController*)open:(NSString*)url extraParams:(NSDictionary *)extraParams{
    
    LSRouterParams *params = [self routerParamsForUrl:url extraParams: extraParams];

    UIViewController *controller = [self viewController:params];
    
    return controller;
}

/**
 获取一个控制器

 @param params 参数
 @return 控制器
 */
-(UIViewController*)viewController:(LSRouterParams *)params{
    
    NSString *pluginId = params.routerOptions.pluginId;
    
    if (pluginId) {
        //判断组件是否已经启动
        BOOL running = [[LSPluginManager shareInstance] pluginIsRunning:pluginId];
        if (!running) {
            return nil;
        }
    }
   
    UIViewController *controller = [self controllerForRouterParams:params];
    
    if (!controller) {
        return nil;
    }
    
    if (pluginId) {
        //统计通过路由打开组件的类名
        [self countRouter:NSStringFromClass(controller.class) pluginId:pluginId];
    }
    
    return controller;
}

- (UIViewController *)controllerForRouterParams:(LSRouterParams *)params {
    
    SEL CONTROLLER_CLASS_SELECTOR = sel_registerName("allocWithRouterParamsWithParams:");
    SEL CONTROLLER_CLASS_SELECTOR_Swift = sel_registerName("allocWithRouterParamsWithParams:");
    SEL CONTROLLER_SELECTOR = sel_registerName("initWithRouterParams:");
    SEL CONTROLLER_SELECTOR_SWift = sel_registerName("initWithRouterParamsWithParams:");
    
    UIViewController *controller = nil;
    Class controllerClass = params.routerOptions.openClass;
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([controllerClass respondsToSelector:CONTROLLER_CLASS_SELECTOR]) {
        controller = [controllerClass performSelector:CONTROLLER_CLASS_SELECTOR withObject:[params controllerParams]];
    }
    else if ([params.routerOptions.openClass instancesRespondToSelector:CONTROLLER_SELECTOR]) {
        controller = [[params.routerOptions.openClass alloc] performSelector:CONTROLLER_SELECTOR withObject:[params controllerParams]];
    }else if ([params.routerOptions.openClass instancesRespondToSelector:CONTROLLER_SELECTOR_SWift]) {
        controller = [[params.routerOptions.openClass alloc] performSelector:CONTROLLER_SELECTOR_SWift withObject:[params controllerParams]];
    }else if ([controllerClass respondsToSelector:CONTROLLER_CLASS_SELECTOR_Swift]) {
        controller = [controllerClass performSelector:CONTROLLER_CLASS_SELECTOR_Swift withObject:[params controllerParams]];
    }
#pragma clang diagnostic pop
    if (!controller) {
        return nil;
    }
    
    controller.modalTransitionStyle = params.routerOptions.transitionStyle;
    controller.modalPresentationStyle = params.routerOptions.presentationStyle;
    return controller;
}

- (LSRouterParams *)routerParamsForUrl:(NSString *)url extraParams: (NSDictionary *)extraParams {

    NSArray *givenParts = url.pathComponents;
    NSArray *legacyParts = [url componentsSeparatedByString:@"/"];
    if ([legacyParts count] != [givenParts count]) {
        givenParts = legacyParts;
    }

    __block LSRouterParams *openParams = nil;

    [self.routes enumerateKeysAndObjectsUsingBlock:
     ^(NSString *routerUrl, LSRouterOptions *routerOptions, BOOL *stop) {

         NSArray *routerParts = [routerUrl pathComponents];
         if ([routerParts count] == [givenParts count]) {

             NSDictionary *givenParams = [self paramsForUrlComponents:givenParts routerUrlComponents:routerParts];
             if (givenParams) {
                 openParams = [[LSRouterParams alloc] initWithRouterOptions:routerOptions openParams:givenParams extraParams: extraParams];
                 *stop = YES;
             }
         }
     }];

    if (!openParams) {
        return nil;
    }
 
    return openParams;
}

- (NSDictionary *)paramsForUrlComponents:(NSArray *)givenUrlComponents
                     routerUrlComponents:(NSArray *)routerUrlComponents {
    
    __block NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [routerUrlComponents enumerateObjectsUsingBlock:
     ^(NSString *routerComponent, NSUInteger idx, BOOL *stop) {
         
         NSString *givenComponent = givenUrlComponents[idx];
         if ([routerComponent hasPrefix:@":"]) {
             NSString *key = [routerComponent substringFromIndex:1];
             [params setObject:givenComponent forKey:key];
         }
         else if (![routerComponent isEqualToString:givenComponent]) {
             params = nil;
             *stop = YES;
         }
     }];
    return params;
}


/**
 只对有组件的操作进行保存
 统计打开的组件类名的次数

 @param className 打开的类名
 @param pluginId 组件
 */
-(void)countRouter:(NSString*)className pluginId:(NSString*)pluginId{
    
    NSMutableDictionary *openClass = [NSMutableDictionary dictionaryWithDictionary:[self.routesOpenCount objectForKey:pluginId]];
    NSInteger count = [[openClass objectForKey:className] integerValue];
    count++;
    [openClass setValue:@(count) forKey:className];
    [self.routesOpenCount setValue:openClass forKey:pluginId];
}


/**
 减少组件统计数

 @param className 类名
 @param pluginId 组件ID
 */
-(void)releaseRouterCount:(NSString*)className pluginId:(NSString*)pluginId{
    
    NSMutableDictionary *openClass = [NSMutableDictionary dictionaryWithDictionary:[self.routesOpenCount objectForKey:pluginId]];
    
    if (openClass.count <= 0) {
        return;
    }
    
    NSInteger count = [[openClass objectForKey:className] integerValue];
    count--;
    
    if (count <= 0) {
        count = 0;
    }
    
    [openClass setValue:@(count) forKey:className];
    
    BOOL isRunning = [self pluginIsRunning:openClass];
    
    if (!isRunning) {
        
        [self releasePlugin:pluginId];
    }
}

/// 组件是否在运行
-(BOOL)pluginIsRunning:(NSDictionary*)openClass{
    
    __block BOOL result = NO;
    
    [openClass enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
       
        NSInteger count = [obj integerValue];
        
        if (count > 0) {
            result = YES;
            *stop = YES;
        }
        
    }];
    
    return result;
}


/// 关闭组件运行
-(void)releasePlugin:(NSString*)pluginId{
    [[LSPluginManager shareInstance] stopRunningPluginByPluginId:pluginId];
}

-(NSString*)topClass{
    
    UIViewController *viewController = self.navigationController.visibleViewController;
    
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        viewController = ((UINavigationController*)viewController).viewControllers.firstObject;
    }
    
    return NSStringFromClass(viewController.class);
}

@end


@implementation LSRouter

+ (instancetype)sharedRouter {
    static LSRouter *_sharedRouter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedRouter = [[LSRouter alloc] init];
    });
    return _sharedRouter;
}

@end
