//
//  LSPluginApplication.h
//  GWBaseLib
//
//  Created by Lyson on 2018/5/21.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 组件管理器关联Application设置
 */
@interface LSPluginApplication : NSObject

+ (BOOL)lsPluginApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

+(UIInterfaceOrientationMask)lsPluginApplication:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;

+(NSString*)initializeClass;

@end
