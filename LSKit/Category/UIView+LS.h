//
//  UIView+LS.h
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import <UIKit/UIKit.h>



@interface UIView (LS)

@property (nonatomic , assign) CGFloat x;
@property (nonatomic , assign) CGFloat y;
@property (nonatomic , assign) CGFloat width;
@property (nonatomic , assign) CGFloat height;
@property (nonatomic , assign) CGFloat centerX;
@property (nonatomic , assign) CGFloat centerY;
@property (nonatomic , assign) UIEdgeInsets ls_safeEdge;
@end
