//
//  LSRouter.h
//  LSKit
//
//  Created by Lyson on 2018/5/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LSRouterOptions.h"

@protocol LSRouterDelegate<NSObject>

@optional
+(instancetype)allocWithRouterParamsWithParams:(NSDictionary*)parameter;
@optional
-(instancetype)initWithRouterParams:(NSDictionary*)parameter;

@end
/**
 路由控制器
 */
@interface LSBaseRouter : NSObject

@property (readwrite, nonatomic, strong) UINavigationController *navigationController;

- (void)map:(NSString *)format toController:(Class)controllerClass;

/**
 注册一个控制器
 
 @param format URL
 @param controllerClass 绑定跳转的控制器
 @param options 操作
 */
- (void)map:(NSString *)format toController:(Class)controllerClass withOptions:(LSRouterOptions *)options;

/**
 推出一个控制器
 
 @param animated 是否动画 YES NO
 @param url 回调参数URL
 @param extraParams 回调的参数
 */
- (void)pop:(BOOL)animated format:(NSString*)url extraParams:(NSDictionary *)extraParams;

/// 推出一个控制器
- (void)pop:(BOOL)animated;

/// 打开一个远程链接
- (void)openExternal:(NSString *)url;

/**
 打开一个URL
 
 @param url URL
 @param animated 是否动画 YES NO
 */
- (void)open:(NSString *)url animated:(BOOL)animated;

/// 打开一个URL
- (void)open:(NSString *)url;

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
  toCallback:(LSRouterOpenCallback)callback;

///**
// 跳转到制定控制器 并且给该制定控制器传数据
// 
// @param animated YES NO
// @param url URL
// @param extraParams 传递给制定控制器的参数
// */
- (void)popToViewController:(BOOL)animated
                     format:(NSString*)url
                extraParams:(NSDictionary *)extraParams;

/**
 通过URL获取一个对象

 @param url URL
 @param extraParams 参数
 @return 需要获取的对象 未获取到返回nil
 */
-(UIViewController*)openViewController:(NSString*)url extraParams:(NSDictionary *)extraParams;

/// 获取栈顶控制器
-(NSString*)topClass;

@end

@interface LSRouter : LSBaseRouter

+ (instancetype)sharedRouter;

@end
