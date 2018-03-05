//
//  UIImage+GW.m
//  GWBaseLib
//
//  Created by Lyson on 2017/12/22.
//  Copyright © 2017年 GWBaseLib. All rights reserved.
//

#import "UIImage+LS.h"

@implementation UIImage (LS)

/**
    获取一个圆角的图片
 **/
- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius {
    return [self imageByRoundCornerRadius:radius borderWidth:0 borderColor:nil];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor {
    return [self imageByRoundCornerRadius:radius
                                  corners:UIRectCornerAllCorners
                              borderWidth:borderWidth
                              borderColor:borderColor
                           borderLineJoin:kCGLineJoinMiter];
}

- (UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                              corners:(UIRectCorner)corners
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(UIColor *)borderColor
                       borderLineJoin:(CGLineJoin)borderLineJoin {
    
    if (corners != UIRectCornerAllCorners) {
        UIRectCorner tmp = 0;
        if (corners & UIRectCornerTopLeft) tmp |= UIRectCornerBottomLeft;
        if (corners & UIRectCornerTopRight) tmp |= UIRectCornerBottomRight;
        if (corners & UIRectCornerBottomLeft) tmp |= UIRectCornerTopLeft;
        if (corners & UIRectCornerBottomRight) tmp |= UIRectCornerTopRight;
        corners = tmp;
    }
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -rect.size.height);
    
    CGFloat minSize = MIN(self.size.width, self.size.height);
    if (borderWidth < minSize / 2) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, borderWidth, borderWidth) byRoundingCorners:corners cornerRadii:CGSizeMake(radius, borderWidth)];
        [path closePath];
        
        CGContextSaveGState(context);
        [path addClip];
        CGContextDrawImage(context, rect, self.CGImage);
        CGContextRestoreGState(context);
    }
    
    if (borderColor && borderWidth < minSize / 2 && borderWidth > 0) {
        CGFloat strokeInset = (floor(borderWidth * self.scale) + 0.5) / self.scale;
        CGRect strokeRect = CGRectInset(rect, strokeInset, strokeInset);
        CGFloat strokeRadius = radius > self.scale / 2 ? radius - self.scale / 2 : 0;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:strokeRect byRoundingCorners:corners cornerRadii:CGSizeMake(strokeRadius, borderWidth)];
        [path closePath];
        
        path.lineWidth = borderWidth;
        path.lineJoinStyle = borderLineJoin;
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  按比例缩小图片
 *
 *  @param scaleSize 缩放比例
 *
 *  @return 缩放后的图片
 */
- (UIImage *)scaleImageByScale:(float)scaleSize
{
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width*scaleSize,self.size.height*scaleSize));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scaleSize, self.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/**
 *      将图片缩放到一个合适的比例 等比缩放到该尺寸
 */
- (UIImage *)zoomImage:(UIImage *)img toSize:(CGSize)size
{
    
    CGSize newSize = [UIImage zoomNewSize:size imgSize:img.size];
    UIGraphicsBeginImageContext(newSize);
    [img drawInRect:CGRectMake(0,0, newSize.width, newSize.height)];
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 *  存储图片
 */
- (void)saveImageWithPath:(NSString *)path{
    NSData *imageData = UIImageJPEGRepresentation(self, 1);
    [imageData writeToFile:path atomically:NO];
}

/**
 *    @brief    根据图片比例大小和预计的变换大小获取一个新的图片比例
 *    @return 计算后的此次大小
 */
+(CGSize)zoomNewSize:(CGSize)size imgSize:(CGSize)imgSize
{
    
    int width = imgSize.width;
    int height = imgSize.height;
    
    CGSize newSize ;
    if (size.width > width && size.height > height) {
        
        newSize = CGSizeMake(width, height);
        
    }else if (size.width < width && size.height > height){
        //图片的宽大于需要的宽， 以需要的宽为准
        
        int newHeight =size.width * height/width;
        
        newSize = CGSizeMake(size.width, newHeight);
        
    }else if(size.width > width && size.height < height){
        
        int newWdith = size.height * width / height ;
        newSize = CGSizeMake(newWdith, size.height);
        
    }else if (width < height){
        
        int newWdith = size.height * width / height ;
        newSize = CGSizeMake(newWdith, size.height);
        
    }else if (width > height){
        
        int newHeight =size.width * height/width;
        newSize = CGSizeMake(size.width, newHeight);
    }else{
        newSize = size;
    }
    return newSize;
}


@end
