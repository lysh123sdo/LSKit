//
//  LSTextFind.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/10.
//

#import "LSTextFind.h"
#import "LSTextConfinge.h"
#import "NSObject+TextObj.h"
#import "UIView+LSTextCenter.h"

@interface LSTextConfinge (LSTextFind)
///当前选择的语言
+ (NSString *)staticLanguage;
///当前的语言包
+ (NSString *)staticBundleName;
///当前的语言文件名
+ (NSString *)languageFileName;

+ (NSString *)lsbundleClass;

@end

@implementation LSTextFind

static NSMutableDictionary *languageKeys;

+ (NSString *)findKeyText:(NSArray *)total language:(NSString *)language {
    // 此处通过key查找实际的文字.
    NSString *format = [self findFromListWithKey:total.firstObject language:language];
    
    if (format == nil) {
        if (total.count > 1) {
            format = total[1];
        } else {
            return nil;
        }
    }
    
    if (total.count > 2) {
       NSArray *array = [total subarrayWithRange:NSMakeRange(2, total.count - 2)];
        
        NSRange range = [format rangeOfString:@"%@"];
        for (NSInteger i = 0;
             range.location != NSNotFound;
             i++, range = [format rangeOfString:@"%@"]) {
            
            format = [format stringByReplacingCharactersInRange:range withString:(i < array.count?array[i]:@"(null)")];
        }
    }
    
    return format;
}

// 此处通过key查找对应语言
+ (NSString *)findFromListWithKey:(NSString *)key language:(NSString *)language {
    
    if (languageKeys == nil) {
        NSString *path = [self currLanguageFilePath];
        if (path == nil || path.length == 0) {
            return nil;
        } else {
            languageKeys = [NSMutableDictionary dictionaryWithContentsOfFile:path];
        }
    }
    
    if (key == nil) {
        return nil;
    }
    
    NSString *value = [languageKeys objectForKey:key];
    
    return value;
}


+(BOOL)resetLanguageKeys{
    
    NSString *path = [self currLanguageFilePath];
    NSDictionary *dics = [NSDictionary dictionaryWithContentsOfFile:path];
    
    if (path == nil || path.length == 0) {
        return NO;
    }
    
    [languageKeys removeAllObjects];
    [languageKeys addEntriesFromDictionary:dics];
    
    return YES;
}

// 判断是否需要加载其它语言
+ (BOOL)isFindLanguage:(NSString *)language target:(__kindof UIView *)view {
    
    if ([LSTextConfinge staticLanguage] == nil || [language isEqualToString:[LSTextConfinge staticLanguage]]) {
        return NO;
    }
    view.currentLanguage_lsText = [LSTextConfinge staticLanguage];
    return YES;
}

+ (NSString *)currentLanguage {
    
    NSString *language = [LSTextConfinge staticLanguage];
    return language;
}

///获取当前设置的语言的路径
+(NSString*)currLanguageFilePath{
    
    NSString *bundleName = [LSTextConfinge staticBundleName];
    Class cls = NSClassFromString([LSTextConfinge lsbundleClass]);
    NSBundle *bundle = [NSBundle bundleForClass:cls moduleName:bundleName];

    NSString *language = [self languageFolder];
   
    NSString *filePath = [bundle pathForResource:language ofType:@"lproj"];
    
    if (!filePath) {
        filePath = [bundle pathForResource:[LSTextConfinge languageFileName] ofType:@"strings"];
        return filePath;
    }
    return [NSString stringWithFormat:@"/%@/%@.strings",filePath,[LSTextConfinge languageFileName]];
}


+(NSString*)languageFolder{
    NSString *language = [self currentLanguage];
    
    if ([language hasPrefix:@"zh-Hans"]) {
        return @"zh-Hans";
    }else if([language hasPrefix:@"en"]){
        return @"en";
    }else if([language hasPrefix:@"zh-Hant"]){
        return @"zh-Hant";
    }
    
    return language;
}

@end

