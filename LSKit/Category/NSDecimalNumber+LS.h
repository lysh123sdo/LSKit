//
//  NSDecimalNumber+LS.h
//  GWBaseLib
//
//  Created by Lyson on 2018/7/20.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (LS)

+(NSComparisonResult)compare:(NSString*)valueA value:(NSString*)valueB;

///加
+(NSString*)addBy:(NSString*)valueA value:(NSString*)valueB;
///减
+(NSString*)subtractingBy:(NSString*)valueA value:(NSString*)valueB;
///乘
+(NSString*)multiplyingBy:(NSString*)valueA value:(NSString*)valueB;
///除
+(NSString*)dividingBy:(NSString*)valueA value:(NSString*)valueB;

@end
