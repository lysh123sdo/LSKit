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

/// App启动调动 需要手动管理Application
+ (BOOL)lsPluginApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                     window:(UIWindow*)window;

/// 屏幕旋转调用 需要手动管理Application
+(UIInterfaceOrientationMask)lsPluginApplication:(UIApplication *)application
         supportedInterfaceOrientationsForWindow:(UIWindow *)window;


/// 初始化的组件管理器
+(NSString*)initializeClass;

+(void)initializeOk;

+(UIViewController*)rootViewController;
@end
