//
//  LSRuntimeUtils.m
//  LSKit
//
//  Created by Lyson on 2018/3/5.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import "LSRuntimeUtils.h"
#import <objc/runtime.h>

@implementation LSRuntimeUtils

/**
 方法交互
 **/
+ (void)lsExchangeOriginFun:(SEL)oldSel newFun:(SEL)newSel{
    
    Method originFun = class_getInstanceMethod(self, oldSel);
    Method exchangeFun = class_getInstanceMethod(self, newSel);
    method_exchangeImplementations(originFun, exchangeFun);
}

@end
