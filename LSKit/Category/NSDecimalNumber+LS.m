//
//  NSDecimalNumber+LS.m
//  GWBaseLib
//
//  Created by Lyson on 2018/7/20.
//  Copyright © 2018年 GWBaseLib. All rights reserved.
//

#import "NSDecimalNumber+LS.h"
#import <LSKit/LSKit.h>
@implementation NSDecimalNumber (LS)


+(NSComparisonResult)compare:(NSString*)valueA value:(NSString*)valueB{
    
    
    if ([NSString isEmpty:valueA]) {
        valueA = @"0";
    }
    
    if ([NSString isEmpty:valueB]) {
        valueB = @"0";
    }
    
    NSDecimalNumber *valueADec = [NSDecimalNumber decimalNumberWithString:valueA];
    NSDecimalNumber *valueBDec = [NSDecimalNumber decimalNumberWithString:valueB];
    
    return [valueADec compare:valueBDec];
}


+(NSString*)addBy:(NSString*)valueA value:(NSString*)valueB{
    
    if ([NSString isEmpty:valueA]) {
        valueA = @"0";
    }
    
    if ([NSString isEmpty:valueB]) {
        valueB = @"0";
    }
    
    NSDecimalNumber *valueADec = [NSDecimalNumber decimalNumberWithString:valueA];
    NSDecimalNumber *valueBDec = [NSDecimalNumber decimalNumberWithString:valueB];
 
    NSString *result = [valueADec decimalNumberByAdding:valueBDec].stringValue;
    
    return result;
}

+(NSString*)subtractingBy:(NSString*)valueA value:(NSString*)valueB{
    
    
    if ([NSString isEmpty:valueA]) {
        valueA = @"0";
    }
    
    if ([NSString isEmpty:valueB]) {
        valueB = @"0";
    }
    
    NSDecimalNumber *valueADec = [NSDecimalNumber decimalNumberWithString:valueA];
    NSDecimalNumber *valueBDec = [NSDecimalNumber decimalNumberWithString:valueB];
    
    NSString *result = [valueADec decimalNumberBySubtracting:valueBDec].stringValue;
    
    return result;
}

+(NSString*)multiplyingBy:(NSString*)valueA value:(NSString*)valueB{
    
    
    if ([NSString isEmpty:valueA]) {
        valueA = @"0";
    }
    
    if ([NSString isEmpty:valueB]) {
        valueB = @"0";
    }
    
    NSDecimalNumber *valueADec = [NSDecimalNumber decimalNumberWithString:valueA];
    NSDecimalNumber *valueBDec = [NSDecimalNumber decimalNumberWithString:valueB];
    
    if (valueBDec.doubleValue == 0) {
        return @"0";
    }
    
    NSString *result = [valueADec decimalNumberByMultiplyingBy:valueBDec].stringValue;
    
    return result;
}

+(NSString*)dividingBy:(NSString*)valueA value:(NSString*)valueB{
    
    if ([NSString isEmpty:valueA]) {
        valueA = @"0";
    }
    
    if ([NSString isEmpty:valueB]) {
        valueB = @"0";
    }
    
    NSDecimalNumber *valueADec = [NSDecimalNumber decimalNumberWithString:valueA];
    NSDecimalNumber *valueBDec = [NSDecimalNumber decimalNumberWithString:valueB];
    
    NSString *result = [valueADec decimalNumberByDividingBy:valueBDec].stringValue;
    
    return result;
}

@end
