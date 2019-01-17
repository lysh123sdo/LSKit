//
//  LSImageResourceServer.h
//  iOS_Image
//
//  Created by SMCB on 2018/2/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSImageResourceServer : NSObject
+ (UIImage *)imageName:(NSString *)name file:(const char*)file;
+ (nullable UIImage *)imageWithContentsOfFileName:(NSString *)name;
+(UIImage*)imageName:(NSString *)name moduleName:(NSString*)module file:(const char*)file;
+(UIImage*)imageNameSwift:(NSString *)name moduleName:(NSString*)module file:(const char*)file;
@end

NS_ASSUME_NONNULL_END
