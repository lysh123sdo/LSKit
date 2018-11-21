//
//  UIDevice+LS.h
//  EMQUtils
//
//  Created by kurt on 2018/7/13.
//

#import <UIKit/UIKit.h>

@interface UIDevice (LS)
//获取UUID
+ (NSString *)uuidString;

//检查相机权限
+ (BOOL)checkVideoPemission;

//检查照片权限
+ (BOOL)checkPhonetoPemission;

//当前设备
+ (NSString *)deviceModel;

//当前版本
+ (NSString *)currentVersion;

//app名字
+ (NSString *)appName;

+ (NSString *)appBuildVersion;

+ (NSString *)appVersion;
@end
