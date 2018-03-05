//
//  LSRuntimeUtils.h
//  LSKit
//
//  Created by Lyson on 2018/3/5.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSRuntimeUtils : NSObject

/**
 方法交互
 **/
+ (void)lsExchangeOriginFun:(SEL)oldSel newFun:(SEL)newSel;

@end
