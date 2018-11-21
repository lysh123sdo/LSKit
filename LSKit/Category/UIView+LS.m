//
//  UIView+LS.m
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import "UIView+LS.h"
#import "UIDevice+LS.h"

@implementation UIView (LS)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}
- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}

-(UIEdgeInsets)ls_safeEdge{
    
    NSString *deviceType = [UIDevice deviceModel];
    
    if ([deviceType isEqualToString:@"iPhone X"] ||
        [deviceType isEqualToString:@"iPhone XR"] ||
        [deviceType isEqualToString:@"iPhone XS"] ||
        [deviceType isEqualToString:@"iPhone XS Max"]) {
        return UIEdgeInsetsMake(34, 0 , 34, 0);
    }else if([deviceType isEqualToString:@"iPhone Simulator"]){
        
        if (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(1125/3.0,2436/3.0)) ||
            CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375,812))) {
            return UIEdgeInsetsMake(34, 0 , 34, 0);
        }
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
