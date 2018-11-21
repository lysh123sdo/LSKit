//
//  UITextView+LSText.h
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/4/11.
//

#import <UIKit/UIKit.h>

@interface UITextView (LSText)
/// replace [setText]
@property(nonatomic, copy) IBInspectable NSString *textKey;
@end
