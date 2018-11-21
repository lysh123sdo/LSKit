//
//  UISegmentedControl+LSText.h
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import <UIKit/UIKit.h>

@interface UISegmentedControl (LSText)
/// replace [insertSegmentWithTitle:(nullable NSString *)title atIndex:(NSUInteger)segment animated:(BOOL)animated]
- (void)insertSegmentWithTitleKey:(nullable NSString *)titleKey atIndex:(NSUInteger)segment animated:(BOOL)animated;
/// replace [setTitle:(nullable NSString *)title forSegmentAtIndex:(NSUInteger)segment]
- (void)setTitleKey:(nullable NSString *)titleKey forSegmentAtIndex:(NSUInteger)segment;

/**
 @author antony
 */
- (void)setTitleKeys:(nullable NSArray *)dict;
@end
