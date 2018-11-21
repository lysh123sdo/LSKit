//
//  UITextField+LSText.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import "UITextField+LSText.h"
#import "LSTextFind.h"
#import "UIView+LSTextCenter.h"
#import "NSObject+TextObj.h"


static void *UITextField_LSText_textKey = &UITextField_LSText_textKey;
static void *UITextField_LSText_placeholderKey = &UITextField_LSText_placeholderKey;

@implementation UITextField (LSText)
- (void)setTextKey:(NSString *)textKey {
    if (textKey) {
        if ([textKey containsString:LSTextSeparatorSymbol] == NO) {
            textKey = [textKey stringByAppendingString:LSTextSeparatorSymbol];
        }
        [self setAssociateValue:textKey withKey:UITextField_LSText_textKey];
        [self lstext_textfield_setOriginPropertText];
    }
}

- (NSString *)textKey {
    return [self getAssociatedValueForKey:UITextField_LSText_textKey];
}

- (void)setPlaceholderKey:(NSString *)placeholderKey {
    
    if (placeholderKey) {
        if ([placeholderKey containsString:LSTextSeparatorSymbol] == NO) {
            placeholderKey = [placeholderKey stringByAppendingString:LSTextSeparatorSymbol];
        }
        
        [self setAssociateValue:placeholderKey withKey:UITextField_LSText_placeholderKey];
        [self lstext_textfield_setOriginPropertPlaceholder];
    }
}

- (NSString *)placeholderKey {
    return [self getAssociatedValueForKey:UITextField_LSText_placeholderKey];
}

- (void)lstext_callStoreMethodNow {
    if ([LSTextFind isFindLanguage:self.currentLanguage_lsText target:self]) {
        if (self.textKey) {
            [self lstext_textfield_setOriginPropertText];
        }
        
        if (self.placeholderKey) {
            [self lstext_textfield_setOriginPropertPlaceholder];
        }
    }
}

- (void)lstext_textfield_setOriginPropertText {
    NSArray *array = [self.textKey componentsSeparatedByString:LSTextSeparatorSymbol];
    self.text = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
}

- (void)lstext_textfield_setOriginPropertPlaceholder {
    NSArray *array = [self.placeholderKey componentsSeparatedByString:LSTextSeparatorSymbol];
    self.placeholder = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
}


@end
