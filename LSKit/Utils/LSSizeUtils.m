//
//  LSSizeUtils.m
//  LSKit
//
//  Created by Lyson on 2018/3/13.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import "LSSizeUtils.h"


@implementation LSSizeUtils

/**
 * sizeWithContent:font:width:
 *
 * 计算content的size
 */
+ (CGSize)sizeWithContent:(NSString *)content font:(UIFont *)font width:(CGFloat)width {
    if ( IsValidateString(content) && font && width > 0 ) {
        CGRect rect = [content boundingRectWithSize:CGSizeMake(width, 10000.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : font } context:nil];
        return rect.size;
    }
    return CGSizeMake(0, 0);
}


@end
