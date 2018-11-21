//
//  LSTextConfinge.m
//  Pods
//
//  Created by Yvan.Peng on 2018/4/13.
//

#import "LSTextConfinge.h"
//#import <LSBaseLib/LSBaseLib.h>
//#import "LSNetwokring.h"
#import "LSTextFind.h"
static NSString *ls_updataLanguage;
static NSString *ls_languageBundleName;
static NSString *ls_languageFileName;
static NSString *ls_bundleClass;

@implementation LSTextConfinge


+ (void)startupWithLanguageBundle:(NSString*)bundleName
                      bundleClass:(NSString*)bundleClass
                  defaultLanguage:(NSString*)defaultLanguage
                         fileName:(NSString*)fileName{
    
    ls_languageBundleName = bundleName;
    ls_bundleClass = bundleClass;
    
    if (!defaultLanguage) {
        ls_updataLanguage = [self currDeviceLanguage];
    }else{
        ls_updataLanguage = defaultLanguage;
    }
    
    ls_languageFileName = fileName;
    
    [self setLanguage:ls_updataLanguage];
}

///设置语言
+(BOOL)setLanguage:(NSString*)language{
    ls_updataLanguage = language;
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"LS_Language"];
    return [LSTextFind resetLanguageKeys];
}

///当前选择的语言
+ (NSString *)staticLanguage {
    return ls_updataLanguage;
}

///语言包
+ (NSString *)staticBundleName {
    return ls_languageBundleName;
}

///语言文件
+ (NSString *)languageFileName {
    return ls_languageFileName;
}

///语言bundle所在类
+ (NSString *)lsbundleClass {
    return ls_bundleClass;
}

///获取当前设备的语言
+(NSString*)currDeviceLanguage{

    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    
    return languageName;
}

///当前设备系统支持语言列表
+(NSArray*)currDeviceLanguageList{
    
    NSArray *arr = [NSLocale availableLocaleIdentifiers];
    return arr;
}

@end
