//
//  LSFileUploadManager.h
//  GWBaseLib
//
//  Created by kurt on 2018/7/31.
//

#import <Foundation/Foundation.h>
#import <AFNetWorking/AFNetworking.h>
@interface LSFileUploadManager : NSObject

    
@property (copy , nonatomic) NSString *url;

+ (LSFileUploadManager *)shareManager;

- (void)uploadImage:(UIImage *)image progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgressBlock andFinished:(void(^)(id response, NSError *error))responseBlock;
    
- (void)uploadImage:(UIImage *)image fileInfos:(NSDictionary*)fileInfos progress:(nullable void (^)(NSProgress *uploadProgress, NSString *fileName))uploadProgressBlock andFinished:(void(^)(id response,NSString *name, NSError *error))responseBlock;

- (void)cancelUploadImage:(UIImage *)image;

- (void)cancelUploadImageWithName:(NSString *)name;

- (NSString *)getImageName:(UIImage *)image;

+ (NSString*)errorMsgByCode:(NSInteger)code;
@end
