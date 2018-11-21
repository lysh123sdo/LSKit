//
//  UILabel+LS.h
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import <UIKit/UIKit.h>

@interface UILabel (LS)
/**
 *  改变行间距
 */
- (void)changeLineSpace:(float)space;

/**
 *  改变字间距
 */
- (void)changeWordSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)changeSpaceWithLineSpace:(float)lineSpace WordSpace:(float)wordSpace;
@end
