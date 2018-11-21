//
//  NSBundle+LS.m
//  GWBaseLib
//
//  Created by Lyson on 2018/7/18.
//

#import "NSBundle+LS.h"

@implementation NSBundle (LS)

+ (NSBundle *)bundleForClass:(Class)cls moduleName:(NSString *)name {
    
    NSParameterAssert(cls);
    NSParameterAssert(name);
    
    if (cls && name) {
        NSBundle *bundle = [NSBundle bundleForClass:cls];
        NSURL *url = [bundle URLForResource:name withExtension:@"bundle"];
        if (url) {
            return [NSBundle bundleWithURL:url];
        }
    }
    
    return nil;
}

@end
