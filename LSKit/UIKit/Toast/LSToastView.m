//
//  ALToastView.m
//  Toast
//
//  Created by LiuLian on 12-12-19.
//  Copyright (c) 2012年 LiuLian. All rights reserved.
//

#import "LSToastView.h"
#import <QuartzCore/QuartzCore.h>
#import "LSSizeUtils.h"

// Set visibility duration
static const CGFloat kDuration = 2;

// Static toastview queue variable
static NSMutableArray *toasts;

@interface LSToastView ()

@property (nonatomic, readonly) UILabel *textLabel;

- (void)fadeToastOut;
+ (void)nextToastInView:(UIView *)parentView;

@end

@implementation LSToastView

@synthesize textLabel = _textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithText:(NSString *)text {
    if ((self = [self initWithFrame:CGRectZero])) {
        // Add corner radius
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.65];
        self.layer.cornerRadius = 18.0f;
        self.autoresizingMask = UIViewAutoresizingNone;
        self.autoresizesSubviews = NO;
        
        // Init and add label
        _textLabel = [[UILabel alloc] init];
        _textLabel.text = text;
//        _textLabel.font = [UIFont boldSystemFontOfSize:16.f];
        _textLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
//        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];
        _textLabel.adjustsFontSizeToFitWidth = NO;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 0;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [_textLabel sizeToFit];
        [self addSubview:_textLabel];
    }
    
    return self;
}

#pragma mark - Public

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text {
    // Add new instance to queue
    LSToastView *view = [[LSToastView alloc] initWithText:text];
    
    CGFloat lWidth = view.textLabel.frame.size.width;
    CGFloat lHeight = view.textLabel.frame.size.height;
    CGFloat pWidth = parentView.frame.size.width;
    CGFloat pHeight = parentView.frame.size.height;
        
    CGSize textSize = [LSSizeUtils sizeWithContent:text font:view.textLabel.font width:kScreenWidth - 20.f];
    
    // Change toastview frame
    if ((pWidth - lWidth - 20) / 2. <= 0)
    {
        view.frame = CGRectMake(5.0, (pHeight - lHeight - 80) / 2, kScreenWidth - 10.f, textSize.height + 40.0);
        view.textLabel.frame = CGRectMake(5.0, 20.0, kScreenWidth - 20.f, textSize.height);
    }
    else
    {
        view.frame = CGRectMake(5.0, (pHeight - lHeight - 80) / 2, kScreenWidth - 10.f, lHeight + 50);
        view.textLabel.frame = CGRectMake(10.0, 25.0, kScreenWidth - 20.f, 20.0);
    }
    view.alpha = 0.0f;
    view.frame = CGRectMake((kScreenWidth - textSize.width - 60) / 2, 4.0 / 5.0 * kScreenHeight, textSize.width + 60, 36);
    view.textLabel.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    if (toasts == nil) {
        toasts = [[NSMutableArray alloc] initWithCapacity:1];
        [toasts addObject:view];
        [LSToastView nextToastInView:parentView];
    }
    else {
        if (toasts.count > 1) {
            [toasts removeAllObjects];
        }
        [toasts addObject:view];
    }
}

#pragma mark - Private

- (void)fadeToastOut {
    // Fade in parent view
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone
     
                     animations:^{
                         self.alpha = 0.f;
                     }
                     completion:^(BOOL finished){
                         UIView *parentView = self.superview;
                         [self removeFromSuperview];
                         
                         // Remove current view from array
                         [toasts removeObject:self];
                         if ([toasts count] == 0) {
                             toasts = nil;
                         }
                         else
                             [LSToastView nextToastInView:parentView];
                     }];
}


+ (void)nextToastInView:(UIView *)parentView {
    if ([toasts count] > 0) {
        LSToastView *view = [toasts lastObject];
        [toasts removeAllObjects];
        
        // Fade into parent view
        [parentView addSubview:view];
        [UIView animateWithDuration:.1 delay:0 options:UIViewAnimationOptionTransitionNone
                         animations:^{
                             view.alpha = 1.0;
                         } completion:^(BOOL finished){}];
        
        // Start timer for fade out
        [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
    }
}



/**
 * showToast:message:
 *
 * 显示一个Toast提示
 *
 * @Parameters:
 *          view - 需要显示提示的ViewController
 *          message - 显示的Toast消息
 */
+ (void)showToast:(UIView *)view message:(NSString *)msg
{
    
    [LSToastView toastInView:view withText:msg];
//
//    if ( msg && msg.length > 15 ) {
//        [ALToastView toastInView:view withText:msg];
//    }
//
//    else {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//
//        // Configure for text only and offset down
//        hud.mode = MBProgressHUDModeText;
//        hud.label.text = msg;
//        hud.removeFromSuperViewOnHide = YES;
//
//        [hud hideAnimated:YES afterDelay:1];
//    }
}


@end
