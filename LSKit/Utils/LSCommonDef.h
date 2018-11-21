//
//  LSCommonDef.h
//  GWBaseLib
//
//  Created by Lyson on 2018/7/18.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#ifndef LSCommonDef_h
#define LSCommonDef_h


#endif /* LSCommonDef_h */

//屏幕宽度
#define kScreenWidth    [[UIScreen mainScreen] bounds].size.width
//屏幕高度
#define kScreenHeight   [[UIScreen mainScreen] bounds].size.height
//屏幕bounds
#define kScreenBounds    [[UIScreen mainScreen] bounds]

#define SelfWeak __weak typeof(self) weakSelf = self;

#define SelfStrong __strong typeof(self) strongSelf = self;

#define UI_IS_LANDSCAPE         ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)

#define UI_IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define kIsIPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define kIsIPHONE4           (kIsIPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define kIsIPHONE5           (kIsIPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define kIsIPHONE6           (kIsIPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define kIsIPHONE6PLUS       (kIsIPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IOS8_AND_HIGHER   ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
