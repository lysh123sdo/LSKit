//
//  UIImage+GW.h
//  GWBaseLib
//
//  Created by Lyson on 2017/12/22.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LS)

/**
 获取一个圆角的图片
 **/
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;

/**
 *  按比例缩小图片
 *
 *  @param scaleSize 缩放比例
 *
 *  @return 缩放后的图片
 */
- (UIImage *)scaleImageByScale:(float)scaleSize;


/**
 *  将图片缩放到一个合适的比例 等比缩放到该尺寸
 */
- (UIImage *)zoomImage:(UIImage *)img toSize:(CGSize)size;

/**
 *  存储图片
 */
- (void)saveImageWithPath:(NSString *)path;

/// 重绘图片颜色
- (UIImage *)imageWithColor:(UIColor *)color;

@end
