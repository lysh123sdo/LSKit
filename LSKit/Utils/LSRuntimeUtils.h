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

/**获取类的属性值**/
+(NSDictionary*)infosFromObj:(id)data keys:(NSArray*)keys;

/**获取一个类的属性值**/
+(NSArray*)keysOfClass:(Class)cls;

@end
