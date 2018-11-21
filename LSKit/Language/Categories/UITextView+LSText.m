//
//  UITextView+LSText.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import "UITextView+LSText.h"
#import "LSTextFind.h"
#import "UIView+LSTextCenter.h"
#import "NSObject+TextObj.h"
static void *UITextView_LSText_textKey = &UITextView_LSText_textKey;

@implementation UITextView (LSText)
- (void)setTextKey:(NSString *)textKey {
    
    if (textKey) {
        if ([textKey containsString:LSTextSeparatorSymbol] == NO) {
            textKey = [textKey stringByAppendingString:LSTextSeparatorSymbol];
        }
        [self setAssociateValue:textKey withKey:UITextView_LSText_textKey];
        [self lstext_textview_setOriginPropertText];
    }

}

- (NSString *)textKey {
    return [self getAssociatedValueForKey:UITextView_LSText_textKey];
}

- (void)lstext_callStoreMethodNow {
    if ([LSTextFind isFindLanguage:self.currentLanguage_lsText target:self] && self.textKey) {
        [self lstext_textview_setOriginPropertText];
    }
}

- (void)lstext_textview_setOriginPropertText {
    NSArray *array = [self.textKey componentsSeparatedByString:LSTextSeparatorSymbol];
    self.text = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
}

@end
