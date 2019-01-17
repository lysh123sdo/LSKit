//
//  LSImageResourceServer.m
//  iOS_Image
//
//  Created by SMCB on 2018/2/8.
//

#import "LSImageResourceServer.h"
#import "NSBundle+LS.h"

@implementation LSImageResourceServer

+(UIImage*)imageNameSwift:(NSString *)name moduleName:(NSString*)module file:(const char*)file{
    
    NSString *bundClass = [NSString stringWithFormat:@"%s",file];
    bundClass = [[bundClass componentsSeparatedByString:@"/"] lastObject];
    bundClass = [[bundClass componentsSeparatedByString:@"."] firstObject];
    bundClass = [NSString stringWithFormat:@"%@.%@",module,bundClass];
    Class cls = NSClassFromString(bundClass);
    
    NSBundle *bundle = [NSBundle bundleForClass:cls moduleName:module];
    
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+(UIImage*)imageName:(NSString *)name moduleName:(NSString*)module file:(const char*)file{
    
    NSString *bundClass = [NSString stringWithFormat:@"%s",file];
    bundClass = [[bundClass componentsSeparatedByString:@"/"] lastObject];
    bundClass = [[bundClass componentsSeparatedByString:@"."] firstObject];
    Class cls = NSClassFromString(bundClass);
    
    NSBundle *bundle = [NSBundle bundleForClass:cls moduleName:module];
    
    UIImage *image = [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
    return image;
}

+ (UIImage *)imageName:(NSString *)name file:(const char*)file{
    NSString *bundClass = [NSString stringWithFormat:@"%s",file];
    bundClass = [[bundClass componentsSeparatedByString:@"/"] lastObject];
    bundClass = [[bundClass componentsSeparatedByString:@"."] firstObject];
    Class cls = NSClassFromString(bundClass);
    return [self imageName:name bundleClass:cls index:0];
}

+ (UIImage *)imageWithContentsOfFileName:(NSString *)name {
    
    return [self imageName:name bundleClass:nil index:1];
}

+ (UIImage *)imageSelWithName:(NSString *)name bundle:(NSBundle *)bundle index:(NSInteger)index {
    switch (index) {
            case 0:
            return [UIImage imageNamed:name inBundle:bundle compatibleWithTraitCollection:nil];
            case 1:
            return [UIImage imageWithContentsOfFile:[bundle.bundlePath stringByAppendingPathComponent:name]];
        default:
            return nil;
    }
}

+ (UIImage *)imageName:(NSString *)name bundleClass:(Class)bundleClass index:(NSInteger)index {
    NSParameterAssert(name);
    
    // 首先在mainbundle中找
    NSBundle *fileBundle;
    if (bundleClass) {
        fileBundle = [NSBundle bundleForClass:bundleClass];
    }else{
        fileBundle = [NSBundle mainBundle];
    }
    UIImage *image = [self imageSelWithName:name bundle:fileBundle index:index];
    if (image) return image;
    
    // 在framework中查找
    if (name && [name isKindOfClass:NSString.class] && name.length > 0) {
        
        NSBundle *bundle = [NSBundle bundleForClass:self moduleName:@"iOS_Image"];
        if (bundle) {
            UIImage *image = [self imageSelWithName:name bundle:bundle index:index];
            if (image) return image;
        }
        
        // 如果没查找到,去调用者组件内查找相关图片
        return [self imageFromOtherFrameworkWithName:name index:index];
    }
    return nil;
}

+ (UIImage *)imageFromOtherFrameworkWithName:(NSString *)name index:(NSInteger)index {
//    NSAssert([NSThread currentThread].isMainThread, @"必须在主线程调用");
//    if ([NSThread currentThread].isMainThread == NO) {
//        return nil;
//    }
//    NSString       *sourceString = [[NSThread callStackSymbols] objectAtIndex:3];
//    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
//    NSMutableArray *array        = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
//    [array removeObject:@""];
//
//    NSBundle *bundle;
////#ifdef TARGET_OS_IPHONE
//    if (array.count >= 5) {
//        Class cls = NSClassFromString(array[3]);
//        if (cls == NULL) {
//            cls = NSClassFromString(array[4]);
//        }
////#else
////    if (array.count >= 5) {
////        Class cls = NSClassFromString(array[3]);
////        if (cls == NULL) {
////            cls = NSClassFromString(array[4]);
////        }
////#endif
//
//        if (cls) {
//            // 使用静态库后,二进制文件全部copy到mainbundle中,目前无法找到对应的资源bundle的名字.
//            NSString *frameworkName = array[1];
//            if ([frameworkName isEqualToString:[self appName]]) {
//                bundle = [NSBundle mainBundle];
//            } else {
//                bundle = [NSBundle yyBundleForClass:cls moduleName:frameworkName];
//            }
//        }
//    }
    
    NSBundle *bundle = nil;
//    if (bundle) {
//        UIImage *image = [self imageSelWithName:name bundle:bundle index:index];
//
//        if (image)  return image;
//    }
    
    // 如果还是没找到则去遍历"*.bundle"
    UIImage *image_for = [self imageEnumBundleWithName:name bundle:bundle?bundle:[NSBundle mainBundle] index:index];
    if (image_for) return image_for;
    
    return nil;
}

+ (UIImage *)imageEnumBundleWithName:(NSString *)name bundle:(NSBundle *)bundle index:(NSInteger)index {
    // fix bug
    NSArray *array = [bundle pathsForResourcesOfType:@"bundle" inDirectory:nil];
    for (NSString *path in array) {
        NSBundle *b = [NSBundle bundleWithPath:path];
        UIImage *image = [self imageSelWithName:name bundle:b index:index];
        if (image) {
            return image;
        }
    }
    return nil;
}

+ (NSString *)appName {
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleName"];
}

@end
