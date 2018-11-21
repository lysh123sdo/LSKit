//
//  UITextField+LSText.h
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import <UIKit/UIKit.h>

@interface UITextField (LSText)

/// replace text
@property(nonatomic, copy) IBInspectable NSString *textKey;
/// replace placeholder
@property(nonatomic, copy) IBInspectable NSString *placeholderKey;
@end
