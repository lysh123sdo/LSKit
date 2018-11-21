//
//  UIButton+LSText.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import "UIButton+LSText.h"
#import "LSTextFind.h"
#import "UIView+LSTextCenter.h"
#import "NSObject+TextObj.h"

static void *UIButton_LSText_titleKey = &UIButton_LSText_titleKey;

@implementation UIButton (LSText)

- (NSString*)titleKeyByState:(NSInteger)state {
    
    NSMutableDictionary *titlekeys = [self getAssociatedValueForKey:UIButton_LSText_titleKey];
    
    NSString *title = [titlekeys objectForKey:[NSString stringWithFormat:@"%zd",state]];
    
    return title;
}

- (void)setTitleKey:(NSString*)titleKey state:(NSInteger)state{
    
    
    NSMutableDictionary *titlekeys = [self getAssociatedValueForKey:UIButton_LSText_titleKey];
    
    if (!titlekeys) {
        titlekeys = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    
    [titlekeys setValue:titleKey forKey:[NSString stringWithFormat:@"%zd",state]];
    
    [self setAssociateValue:titlekeys withKey:UIButton_LSText_titleKey];
    
}




- (void)setNormalTitleKey:(NSString *)titleKey{
    [self setTitleKey:titleKey forState:UIControlStateNormal];
}

- (void)setTitleKey:(NSString *)titleKey forState:(UIControlState)state {
    
    if (titleKey) {
        NSArray *array = [titleKey componentsSeparatedByString:LSTextSeparatorSymbol];
        NSString *title = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
        [self setTitle:title forState:state];
        
        [self setTitleKey:titleKey state:state];
   
    }
}

- (void)lstext_callStoreMethodNow {
    
    NSMutableDictionary *titlekeys = [self getAssociatedValueForKey:UIButton_LSText_titleKey];
    
    __weak typeof(self) weakSelf = self;
    if (titlekeys && [LSTextFind isFindLanguage:self.currentLanguage_lsText target:self]) {
        
        [titlekeys enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            NSString *titleKey = obj;
            NSNumber *objKey = [NSNumber numberWithInt:[key intValue]];
            [weakSelf exesetTitleKey:titleKey forState:objKey];
            
        }];
   
    }
}


- (void)exesetTitleKey:(NSString *)titleKey forState:(NSNumber *)state {
    
    NSArray *array = [titleKey componentsSeparatedByString:LSTextSeparatorSymbol];
    NSString *title = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
    [self setTitle:title forState:state.unsignedIntegerValue];
}
@end
