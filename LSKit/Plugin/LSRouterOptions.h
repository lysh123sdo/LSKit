//
//  LSRouterOptions.h
//  GWBaseLib
//
//  Created by Lyson on 2018/7/17.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^LSRouterOpenCallback)(NSDictionary *params);

@interface LSRouterOptions : NSObject

+ (instancetype)routerOptionsWithPresentationStyle: (UIModalPresentationStyle)presentationStyle
                                   transitionStyle: (UIModalTransitionStyle)transitionStyle
                                     defaultParams: (NSDictionary *)defaultParams
                                            isRoot: (BOOL)isRoot
                                           isModal: (BOOL)isModal;


+ (instancetype)routerOptions;

@property (readwrite, nonatomic, strong) Class openClass;
@property (readwrite, nonatomic, strong) LSRouterOpenCallback callback;
@property (nonatomic , assign) UIModalPresentationStyle presentationStyle;
@property (nonatomic , assign) UIModalTransitionStyle transitionStyle;
@property (nonatomic , strong) NSDictionary *defaultParams;
@property (readwrite, nonatomic, assign) BOOL shouldOpenAsRootViewController;
@property (readwrite, nonatomic, getter=isModal) BOOL modal;
@property (readwrite, nonatomic , strong) NSString *routerBeforeFilter;
@property (readwrite, nonatomic , strong) NSString *routerAfterFilter;

@end
