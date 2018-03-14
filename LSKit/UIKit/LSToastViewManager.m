//
//  LSALToastViewManager.m
//  LSKit
//
//  Created by Lyson on 2018/3/14.
//  Copyright © 2018年 LSKit. All rights reserved.
//

#import "LSToastViewManager.h"
#import "LSToastView.h"

@implementation LSToastViewManager

+(void)showToast:(NSString*)msg{
    
    [LSToastView toastInView:[UIApplication sharedApplication].keyWindow.subviews[0] withText:msg];
    
}

@end
