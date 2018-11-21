//
//  UIButton+LSText.h
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import <UIKit/UIKit.h>

@interface UIButton (LSText)

/// replac [setTitle:(nullable NSString *)title forState:(UIControlState)state]
- (void)setTitleKey:(NSString *)titleKey forState:(UIControlState)state;

/**
 @author antony
 */
- (void)setNormalTitleKey:(NSString *)titleKey;
@end
