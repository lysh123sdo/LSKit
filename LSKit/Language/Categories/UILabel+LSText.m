//
//  UILabel+LSText.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/10.
//

#import "UILabel+LSText.h"
#import "LSTextFind.h"
#import "UIView+LSTextCenter.h"
#import "NSObject+TextObj.h"

static void *UILabel_LSText_textKey = &UILabel_LSText_textKey;

@implementation UILabel (LSText)

- (void)setTextKey:(NSString *)textKey {
    
    if (textKey) {
        if ([textKey containsString:LSTextSeparatorSymbol] == NO) {
            textKey = [textKey stringByAppendingString:LSTextSeparatorSymbol];
        }
        [self setAssociateValue:textKey withKey:UILabel_LSText_textKey];
        [self lstext_label_setOriginPropertText];
    }
}

- (NSString *)textKey {
    return [self getAssociatedValueForKey:UILabel_LSText_textKey];
}

- (void)lstext_callStoreMethodNow {
    if (self.textKey && [LSTextFind isFindLanguage:self.currentLanguage_lsText target:self]) {
        [self lstext_label_setOriginPropertText];
    }
}

- (void)lstext_label_setOriginPropertText {
    NSArray *array = [self.textKey componentsSeparatedByString:LSTextSeparatorSymbol];
    self.text = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
}

@end
