//
//  ALToastView.h
//  Toast
//
//  Created by LiuLian on 12-12-19.
//  Copyright (c) 2012年 LiuLian. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface LSToastView : UIView
{
    @private
    
    UILabel *_textLabel;
}

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text;
/**
 * showToast:message:
 *
 * 显示一个Toast提示
 *
 * @Parameters:
 *          view - 需要显示提示的ViewController
 *          message - 显示的Toast消息
 */
+ (void)showToast:(UIView *)view message:(NSString *)msg;
@end
