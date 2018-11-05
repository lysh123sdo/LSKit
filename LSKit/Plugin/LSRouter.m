//
//  LSRouter.m
//  LSKit
//
//  Created by Lyson on 2018/5/22.
//

#import "LSRouter.h"
#import <YYKit/YYKit.h>
#import "LSPluginManager.h"
#import "LSRouterParams.h"
#import "NSString+LS.h"
#import "LSRouterFliter.h"

typedef NS_ENUM(NSInteger , LSRouterOpenUrlType){
    
    LSRouterOpenUrlType_Unkown, //未知
    LSRouterOpenUrlType_Router, //自定义路由
    LSRouterOpenUrlType_Url, //网络地址
    LSRouterOpenUrlType_Scheme,//App跳转
    
};

@interface LSBaseRouter()
/// 路由表
@property (readwrite, nonatomic, strong) YYThreadSafeDictionary *routes;
/// http flag 打开网页标记
@property (readwrite, nonatomic , strong) NSString *httpRegex;
/// 路由fag 打开组件sdk标记
@property (readwrite, nonatomic , strong) NSString *pluginRegex;

@property (readwrite, nonatomic , strong) NSString *schemeRegex;

@property (readwrite, nonatomic , strong) LSRouterFliter *filter;

@end

@implementation LSBaseRouter

- (id)init {
    if ((self = [super init])) {
        self.routes = [YYThreadSafeDictionary dictionaryWithCapacity:0];
        self.httpRegex = @"^http[s]{0,1}://";
        self.pluginRegex = @"^router://";
        self.schemeRegex = [NSString stringWithFormat:@"^[a-zA-Z]*://"];
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
- (void)map:(NSString *)format toController:(Class)controllerClass withOptions:(LSRouterOptions *)options{
    
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

    UIViewController *tempViewController;
    BOOL isBreak = NO;
    
    for (NSInteger i = self.navigationController.viewControllers.count - 1; i>= 0 ; i--) {
        
        UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:i];
        
        if (isBreak) {
            tempViewController = viewController;
            break;
        }
        
        if ([viewController isKindOfClass:option.openClass]) {
            isBreak = YES;
        }
    }
    
    if (tempViewController && isBreak) {
        [self.navigationController popToViewController:tempViewController animated:YES];
    }else{
        [self popViewControllerReturnClassName:animated];
    }
   
    if (option.callback) {
        option.callback(extraParams);
    }
    
    BOOL should = [[LSPluginManager shareInstance] sholdStopRunningPlugin:self.navigationController.viewControllers];
    
    if (should) {
        
        NSString *pluginId = [[LSPluginManager shareInstance] findPluginByClassName:params.className];
        
        [[LSPluginManager shareInstance] stopRunningPluginByPluginId:pluginId];
    }
}


/**
 跳转到制定控制器 并且给该制定控制器传数据

 @param animated YES NO
 @param url URL
 @param extraParams 传递给制定控制器的参数
 */
- (void)popToViewController:(BOOL)animated
                     format:(NSString*)url
                extraParams:(NSDictionary *)extraParams{
    
    LSRouterParams *params = [self routerParamsForUrl:url extraParams: extraParams];

    Class pluginClass = params.routerOptions.openClass;
    NSArray *viewControllers = [self.navigationController viewControllers];
    
    if (self.navigationController.presentationController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    
    for (UIViewController *viewController in viewControllers) {
        
        if ([viewController isKindOfClass:pluginClass]) {
          
            SEL popSel = sel_registerName("routerPopExtraParameters:");
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            if ([viewController respondsToSelector:popSel]) {
                [viewController performSelector:popSel withObject:extraParams];
            }
            
            [self.navigationController popToViewController:viewController animated:animated];
            
            return;
            
        }
        
    }
    
}

- (void)pop:(BOOL)animated{
    
    [self popViewControllerReturnClassName:animated];
}

-(NSString*)popViewControllerReturnClassName:(BOOL)animated{
    
    NSString *className;
    
    UINavigationController *controller = self.navigationController;
    
    if (controller.presentedViewController) {
        
        className = NSStringFromClass(controller.presentedViewController.class);
        
        if ([controller.presentedViewController isKindOfClass:[UINavigationController class]]){
            controller = (UINavigationController*)controller.presentedViewController;
            
            if (controller.viewControllers.count >=2 ) {
                [controller popViewControllerAnimated:animated];
            }else{
                [controller dismissViewControllerAnimated:animated completion:nil];
            }
            
        }else{
            [controller dismissViewControllerAnimated:animated completion:nil];
        }
        
    }
    else {
        
        className = NSStringFromClass(self.navigationController.viewControllers.lastObject.class);
        
        [controller popViewControllerAnimated:animated];
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
 
    if (!self.navigationController) {
        return;
    }
    
    LSRouterParams *params = [self routerParamsForUrl:url extraParams:extraParams];
    LSRouterOptions *options = params.routerOptions;
    options.callback = callback;
    params.routerOptions = options;
    params.animated = animated;
    params.routerUrl = url;
    
    params = [self routerBeforeFilter:params];
    
    [self openControllerByParameters:params];
}

-(void)releaseFilter{
    
    self.filter = nil;
}

-(void)openControllerByParameters:(LSRouterParams*)params{
    
    UIViewController *controller = [self viewController:params];
   
    if (!controller) {
        return;
    }
    
    BOOL animated = params.animated;
    
    LSRouterOptions *options = params.routerOptions;
    
    if (controller) {
        
        NSString *pluginId = [[LSPluginManager shareInstance] findPluginByClassName:NSStringFromClass(options.openClass)];
       
        BOOL should = [[LSPluginManager shareInstance] pluginIsRunning:pluginId className:params.routerOptions.className];
        
        if (!should) {
            return;
        }
    }
    
    UINavigationController *navController = self.navigationController;
    
    if (self.navigationController.presentedViewController) {
        
        if ([self.navigationController.presentedViewController isKindOfClass:[UINavigationController class]]) {
            navController = (UINavigationController*)self.navigationController.presentedViewController;
        }else{
            [self.navigationController dismissViewControllerAnimated:animated completion:nil];
        }
    }
    
    if ([options isModal]) {
        if ([controller.class isSubclassOfClass:UINavigationController.class]) {
            [navController presentViewController:controller
                                        animated:animated
                                      completion:nil];
        }
        else {
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
            navigationController.modalPresentationStyle = controller.modalPresentationStyle;
            navigationController.modalTransitionStyle = controller.modalTransitionStyle;
            [navController presentViewController:navigationController
                                        animated:animated
                                      completion:nil];
        }
    }
    
    else if (options.shouldOpenAsRootViewController) {
        [navController setViewControllers:@[controller] animated:animated];
    }
    else {
        [navController pushViewController:controller animated:animated];
    }
}

/**
 通过URL获取一个对象
 
 @param url URL
 @param extraParams 参数
 @return 需要获取的对象 未获取到返回nil
 */
-(UIViewController*)openViewController:(NSString*)url extraParams:(NSDictionary *)extraParams{
    
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
    
    
    NSString *className = NSStringFromClass(params.routerOptions.openClass);
    
    NSString *pluginId = [[LSPluginManager shareInstance] findPluginByClassName:className];
    
    NSLog(@"@@@@@@@@@@@@@@@ : %@",pluginId);
    
    if (pluginId) {
        //判断组件是否已经启动
        BOOL running = [[LSPluginManager shareInstance] pluginIsRunning:pluginId className:NSStringFromClass(params.routerOptions.openClass)];
        if (!running) {
            return nil;
        }
    }
   
    UIViewController *controller = [self controllerForRouterParams:params];
    if (!controller) {
        return nil;
    }
   
    return controller;
}

- (UIViewController *)controllerForRouterParams:(LSRouterParams *)params {
    
    SEL CONTROLLER_CLASS_SELECTOR = sel_registerName("allocWithRouterParamsWithParams:");
    SEL CONTROLLER_SELECTOR = sel_registerName("initWithRouterParams:");

    UIViewController *controller = nil;
    Class controllerClass = params.routerOptions.openClass;

    if ([controllerClass respondsToSelector:CONTROLLER_CLASS_SELECTOR]) {
 
        controller = [controllerClass allocWithRouterParamsWithParams:[params controllerParams]];
  
    }else if ([params.routerOptions.openClass instancesRespondToSelector:CONTROLLER_SELECTOR]) {
        controller = [[params.routerOptions.openClass alloc] initWithRouterParams:[params controllerParams]];
    }else{
        controller = [[params.routerOptions.openClass alloc] init];
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
         if ([url hasPrefix:routerUrl]) {

             NSDictionary *givenParams = [self paramsForUrlComponents:givenParts routerUrlComponents:routerParts];
             openParams = [[LSRouterParams alloc] initWithRouterOptions:routerOptions openParams:givenParams extraParams: extraParams];
             *stop = YES;
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

/// 匹配URL类型
-(NSInteger)routerUrl:(NSString*)url{

    NSRegularExpression *routerRegex = [NSRegularExpression regularExpressionWithPattern:self.pluginRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *routerResult = [routerRegex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
    if (routerResult.range.length) {
        return LSRouterOpenUrlType_Router;
    }
    
    NSRegularExpression *httpRegex = [NSRegularExpression regularExpressionWithPattern:self.httpRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *httpResult = [httpRegex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
    if (httpResult.range.length) {
        return LSRouterOpenUrlType_Url;
    }
    
    NSRegularExpression *schemeRegex = [NSRegularExpression regularExpressionWithPattern:self.schemeRegex options:NSRegularExpressionCaseInsensitive error:nil];
    NSTextCheckingResult *schemeResult = [schemeRegex firstMatchInString:url options:0 range:NSMakeRange(0, [url length])];
    if (schemeResult.range.length) {
        return LSRouterOpenUrlType_Scheme;
    }
   
    return LSRouterOpenUrlType_Unkown;
}

-(LSRouterParams*)routerBeforeFilter:(LSRouterParams*)param{
    
    LSRouterOptions *option = param.routerOptions;
    
    if (![NSString isEmpty:option.routerBeforeFilter]) {
        
        Class cls = NSClassFromString(option.routerBeforeFilter);
        
        LSRouterFliter *filter = [[cls alloc] init];
        
        ///跳转拦截
        if ([filter routerInterception]) {
            return nil;
        }
    
        //跳转加参数
        NSDictionary *addParameter = [filter routerFilterParameter];
        if (addParameter && [addParameter isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithDictionary:param.extraParams];
            [data addEntriesFromDictionary:addParameter];
            param.extraParams = data;
        }
        
        //跳转重定向
        if ([filter routerRedirect]) {
            filter.parameter = param;
            self.filter = filter;
            [filter routerRedirectTask];
            return nil;
        }
    }
    
    return param;
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
