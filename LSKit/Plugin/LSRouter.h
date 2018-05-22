//
//  LSRouter.h
//  LSKit
//
//  Created by Lyson on 2018/5/22.
//

#import <Foundation/Foundation.h>



typedef void (^LSRouterOpenCallback)(NSDictionary *params);

@interface LSRouterOptions:NSObject

+ (instancetype)routerOptionsWithPresentationStyle: (UIModalPresentationStyle)presentationStyle
                                   transitionStyle: (UIModalTransitionStyle)transitionStyle
                                     defaultParams: (NSDictionary *)defaultParams
                                            isRoot: (BOOL)isRoot
                                           isModal: (BOOL)isModal;


+ (instancetype)routerOptions;

@property (nonatomic , assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic , assign) UIModalTransitionStyle transitionStyle;
@property (nonatomic , strong) NSDictionary *defaultParams;
@property (readwrite, nonatomic, assign) BOOL shouldOpenAsRootViewController;
@property (readwrite, nonatomic, getter=isModal) BOOL modal;

@end



@interface LSBaseRouter : NSObject

@property (readwrite, nonatomic, strong) UINavigationController *navigationController;

- (void)map:(NSString *)format toController:(Class)controllerClass;

- (void)map:(NSString *)format toController:(Class)controllerClass withOptions:(LSRouterOptions *)options;

- (void)pop:(BOOL)animated format:(NSString*)url extraParams:(NSDictionary *)extraParams;

- (void)pop:(BOOL)animated;

- (void)pop;

- (void)openExternal:(NSString *)url;

- (void)open:(NSString *)url animated:(BOOL)animated;

- (void)open:(NSString *)url;

- (void)open:(NSString *)url animated:(BOOL)animated extraParams:(NSDictionary *)extraParams toCallback:(LSRouterOpenCallback)callback;

@end

@interface LSRouter : LSBaseRouter

+ (instancetype)sharedRouter;

@end
