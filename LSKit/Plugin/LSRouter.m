//
//  LSRouter.m
//  LSKit
//
//  Created by Lyson on 2018/5/22.
//

#import "LSRouter.h"
#import <YYKit/YYkit.h>

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

@property (readwrite, nonatomic, strong) YYThreadSafeDictionary *routes;

@end

@implementation LSBaseRouter

- (id)init {
    if ((self = [super init])) {
        self.routes = [YYThreadSafeDictionary dictionaryWithCapacity:0];
    }
    return self;
}

- (void)map:(NSString *)format toController:(Class)controllerClass{
    [self map:format toController:controllerClass withOptions:nil];
}

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
    //TODO:补充保存
    [self.routes setObject:options forKey:format];
}

- (void)pop:(BOOL)animated format:(NSString*)url extraParams:(NSDictionary *)extraParams{
    
    LSRouterParams *params = [self routerParamsForUrl:url extraParams: extraParams];
    LSRouterOptions *option = params.routerOptions;
    
    if (option.callback) {
        option.callback(extraParams);
    }
    
    [self popViewControllerFromRouterAnimated:animated];
}

- (void)pop:(BOOL)animated{
    [self popViewControllerFromRouterAnimated:animated];
}

- (void)pop{
    [self popViewControllerFromRouterAnimated:YES];
}

- (void)popViewControllerFromRouterAnimated:(BOOL)animated{
    if (self.navigationController.presentedViewController) {
        [self.navigationController dismissViewControllerAnimated:animated completion:nil];
    }
    else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}

- (void)openExternal:(NSString *)url {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)open:(NSString *)url {
    [self open:url animated:YES extraParams:nil toCallback:nil];
}

- (void)open:(NSString *)url animated:(BOOL)animated{
    [self open:url animated:animated extraParams:nil toCallback:nil];
}

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
        //TODO:将值赋值给Router
    }

    if (!self.navigationController) {
        return;
    }

    UIViewController *controller = [self controllerForRouterParams:params];

    if (!controller) {
        return;
    }
    
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
