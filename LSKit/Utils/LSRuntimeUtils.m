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

/**获取一个类的属性值**/
+(NSArray*)keysOfClass:(Class)cls{
    
    NSMutableArray *keys = [NSMutableArray arrayWithCapacity:0];
    u_int count;
    
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    
    for (int i = 0 ; i < count; i++) {
        
        const char *propertyName = property_getName(properties[i]);
        
        NSString *str = [NSString stringWithCString:propertyName encoding:NSUTF8StringEncoding];
        
        [keys addObject:str];
    }
    
    free(properties);
    
    return keys;
}

/**获取类的属性值**/
+(NSDictionary*)infosFromObj:(id)data keys:(NSArray*)keys{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    [keys enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSString *value = [data valueForKey:obj];
        [dic setValue:value forKey:obj];
    }];
    return dic;
}

@end
