//
//  LSPluginApplication.m
//  GWBaseLib
//
//  Created by Lyson on 2018/5/21.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import "LSPluginApplication.h"
@implementation LSPluginApplication


+ (BOOL)lsPluginApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{

    Class cls = NSClassFromString([self initializeClass]);
    
    if (!cls) {
        return YES;
    }
    
    SEL sel = NSSelectorFromString(@"shareInstance");
    
    IMP imp = [cls methodForSelector:sel];
    
    void (*func)(id, SEL) = (void *)imp;

    func(cls,sel);

    return YES;
}

+(UIInterfaceOrientationMask)lsPluginApplication:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    
    
    
    
    return 0;
}

+(NSString*)initializeClass{
    
    return nil;
}

@end
