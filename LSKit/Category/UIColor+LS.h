//
//  UIColor+GW.h
//  GWBaseLib
//
//  Created by Lyson on 2017/12/22.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (LS)

/**
 *  通过0x获取颜色
 *
 *  @param color 0x字符串
 *  @param al 透明度
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(float)al;

/**
 *  通过0x获取颜色
 *
 *  @param color 0x字符串
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/** 根据颜色获取0x字符串 */
+ (NSString*)getHexStringFromUIColor:(UIColor*)color;

/** 随机色 */
+ (UIColor *)randomColor;

@end
