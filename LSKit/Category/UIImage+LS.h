//
//  UIImage+LS.h
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import <UIKit/UIKit.h>
#define imageStyle @"kImageStyle"

@interface UIImage (LS)

/** 根据名字获取图片 */
+ (NSString *)getImageByName:(NSString *)name;

/** 获取圆形图片 */
-(UIImage *)getCircleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/** 修改图片颜色 */
- (UIImage*) imageWithColor:(UIColor*)color;

/** 获取指定颜色及大小的图片 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/** 获取指定颜色的图片 */
+ (UIImage*) imageWithColor:(UIColor*)color;

/** 根据比例缩放图片 */
- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

/** 修改图片大小 */
- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

/** 根据渲染色获取图片*/
- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

///获取圆形图片
+ (UIImage *)circleImageWithName:(UIImage *)image
                     borderWidth:(CGFloat)borderWidth
                     borderColor:(UIColor *)borderColor;

///根据颜色生产图片
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

///圆角图片
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius;
///圆角图片
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor;

@end
