//
//  LSRouterOptions.m
//  GWBaseLib
//
//  Created by Lyson on 2018/7/17.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import "LSRouterOptions.h"

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
