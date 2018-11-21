//
//  LSTextConfinge.h
//  Pods
//
//  Created by Yvan.Peng on 2018/4/13.
//

#import <Foundation/Foundation.h>

/**
 文字时时切换功能必须调用该方法.
 
 请在[application:didFinishLaunchingWithOptions:launchOptions]方法中调用
 */
@interface LSTextConfinge : NSObject
///=============================================================================
/// @name 启动组件
///=============================================================================

+ (void)startupWithLanguageBundle:(NSString*)bundleName
                      bundleClass:(NSString*)bundleClass
                  defaultLanguage:(NSString*)defaultLanguage
                         fileName:(NSString*)fileName;

///设置语言
+(BOOL)setLanguage:(NSString*)language;
+ (NSString *)staticLanguage;
@end
