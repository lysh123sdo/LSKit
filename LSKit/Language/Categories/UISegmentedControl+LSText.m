//
//  UISegmentedControl+LSText.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import "UISegmentedControl+LSText.h"
#import "LSTextFind.h"
#import "UIView+LSTextCenter.h"

@implementation UISegmentedControl (LSText)

- (void)setTitleKeys:(NSString *)keys{
    if (keys){
        NSArray *array = [keys componentsSeparatedByString:@"|"];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self setTitleKey:obj forSegmentAtIndex:idx];
        }];
    }
}

- (void)insertSegmentWithTitleKey:(NSString *)titleKey atIndex:(NSUInteger)segment animated:(BOOL)animated {
    
    NSArray *array = [titleKey componentsSeparatedByString:LSTextSeparatorSymbol];
    NSString *title = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
    
    [self insertSegmentWithTitle:title atIndex:segment animated:animated];
    
    [self exeinsertSegmentWithTitleKey:titleKey atIndex:@(segment) animated:@(animated)];
    
}

- (void)exeinsertSegmentWithTitleKey:(NSString *)titleKey atIndex:(NSNumber *)segment animated:(NSNumber  *)animated {
    if ([LSTextFind isFindLanguage:self.currentLanguage_lsText target:self]) {
        NSArray *array = [titleKey componentsSeparatedByString:LSTextSeparatorSymbol];
        NSString *title = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
        
        [self insertSegmentWithTitle:title atIndex:segment.unsignedIntegerValue animated:animated.boolValue];
    }
}

- (void)setTitleKey:(NSString *)titleKey forSegmentAtIndex:(NSUInteger)segment {
    
    NSArray *array = [titleKey componentsSeparatedByString:LSTextSeparatorSymbol];
    NSString *title = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
    
    [self setTitle:title forSegmentAtIndex:segment];
    
    [self exesetTitleKey:titleKey forSegmentAtIndex:@(segment)];
 
}

- (void)exesetTitleKey:(NSString *)titleKey forSegmentAtIndex:(NSNumber *)segment {
    if ([LSTextFind isFindLanguage:self.currentLanguage_lsText target:self]) {
        NSArray *array = [titleKey componentsSeparatedByString:LSTextSeparatorSymbol];
        NSString *title = [LSTextFind findKeyText:array language:self.currentLanguage_lsText];
        
        [self setTitle:title forSegmentAtIndex:segment.unsignedIntegerValue];
    }
}
@end
