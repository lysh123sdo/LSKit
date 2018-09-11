//
//  LSPluginApplication.m
//  GWBaseLib
//
//  Created by Lyson on 2018/5/21.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import "LSPluginApplication.h"
#import "LSPlugin.h"
#import "LSPluginManager.h"
#import "LSRouter.h"

@implementation LSPluginApplication


+ (BOOL)lsPluginApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                     window:(UIWindow*)window{

    [self initPluginManager];
 
    UINavigationController *navigationController = (UINavigationController*)window.rootViewController;
    
    if (![navigationController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController*)window.rootViewController.navigationController;
    }
    UIViewController *viewController = [self rootViewController];
    
    if (viewController) {
        
        navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
        window.rootViewController = navigationController;
        [window makeKeyAndVisible];
//        else{
//            [navigationController pushViewController:viewController animated:YES];
//        }
    }
    
    
    if (navigationController) {
        [[LSRouter sharedRouter] setNavigationController:navigationController];
    }
    [self initializeOk];
    return YES;
}

+(UIInterfaceOrientationMask)lsPluginApplication:(UIApplication *)application
         supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    NSInteger rotation = UIInterfaceOrientationMaskPortrait;
    
    Class cls = NSClassFromString([self initializeClass]);
    
    LSPluginManager *pluginManager = [cls shareInstance];
    
    NSString *viewControllerClass = [[LSRouter sharedRouter] topClass];
    NSString *pluginId = [pluginManager topViewControllerPlugin:viewControllerClass];
    LSPlugin *plugin = [pluginManager findRunningPluginByPluginId:pluginId];
    
    if (plugin && !plugin.isLibrary && [plugin respondsToSelector:@selector(pluginApplication:supportedInterfaceOrientationsForWindow:)]) {

        id result = [plugin performSelector:@selector(pluginApplication:supportedInterfaceOrientationsForWindow:) withObject:application withObject:window];
        
        rotation = [result integerValue];
    }
    
    return rotation;
}

+(void)initializeOk{
    
    
}

+(NSString*)initializeClass{
    
    return nil;
}


+(UIViewController*)rootViewController{
    
    return nil;
}

+(void)initPluginManager{
    
    Class cls = NSClassFromString([self initializeClass]);
    
    if (!cls) {
        return;
    }
    
    SEL sel = NSSelectorFromString(@"shareInstance");
    
    IMP imp = [cls methodForSelector:sel];
    
    void (*func)(id, SEL) = (void *)imp;
    
    func(cls,sel);
}




@end
