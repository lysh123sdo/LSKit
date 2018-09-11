//
//  LSLoggerFormatter.h
//  Pods
//
//  Created by Lyson on 2017/12/21.
//

#import <Foundation/Foundation.h>

@interface LSLoggerFormatter : NSObject

/// 默认初始化
- (instancetype)init;
///自定义格式
- (instancetype)initWithDateFormatter:(NSDateFormatter *)dateFormatter NS_DESIGNATED_INITIALIZER;
@end
