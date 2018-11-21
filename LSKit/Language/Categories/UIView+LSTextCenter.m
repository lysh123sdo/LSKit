//
//  UIView+LSTextCenter.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/13.
//

#import "UIView+LSTextCenter.h"
#import "LSTextFind.h"
#import "NSObject+TextObj.h"


static void * UITextField_LSText_currentLanguage_lsText = &UITextField_LSText_currentLanguage_lsText;

@implementation UIView (LSTextCenter)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(willMoveToWindow:) with:@selector(swizzle_UIView_Text_WillMoveToWindow:)];
    });
}

- (void)swizzle_UIView_Text_WillMoveToWindow:(nullable UIWindow *)newWindow {
    if (newWindow) {
        [self lstext_callStoreMethodNow];
    }
    
    [self swizzle_UIView_Text_WillMoveToWindow:newWindow];
    //系统UIAppreance 在willMoveToWindow:方法后调用,didMoveToWindow前调用
}

- (void)lstext_callStoreMethodNow {}


- (void)setCurrentLanguage_lsText:(NSString *)currentLanguage_lsText {
    [self setAssociateValue:currentLanguage_lsText withKey:UITextField_LSText_currentLanguage_lsText];
}

- (NSString *)currentLanguage_lsText {
    NSString *language = [self getAssociatedValueForKey:UITextField_LSText_currentLanguage_lsText];
    if (language == nil) {
        language = [LSTextFind currentLanguage];
        self.currentLanguage_lsText = language;
    }
    return language;
}
@end
