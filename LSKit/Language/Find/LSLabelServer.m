//
//  LSLabelServer.m
//  iOS_Label
//
//  Created by Yvan.Peng on 2018/2/12.
//

#import "LSLabelServer.h"
#import "LSTextFind.h"

NSString * const LSTextSeparatorSymbol = @"**-+-**";

NSString * LSTextServer(NSString *key, NSString *formate, ...) {
    if (formate) {
        va_list args;
        va_start(args, formate);
        NSMutableArray *array = [[NSMutableArray alloc] init];
        id next = va_arg(args, id);
        while (next) {
            [array addObject:next];
            next = va_arg(args, id);
        }
        va_end(args);
        
        NSString *list = [array componentsJoinedByString:LSTextSeparatorSymbol];

        if (list.length > 0) {
            NSArray *total = @[key, formate, list];
            NSString *string = [total componentsJoinedByString:LSTextSeparatorSymbol];
            NSArray *array = [string componentsSeparatedByString:LSTextSeparatorSymbol];
            NSString *text = [LSTextFind findKeyText:array language:[LSTextFind currentLanguage]];
            return text;
        } else {
           NSString *text = [LSTextFind findKeyText:@[key, formate] language:[LSTextFind currentLanguage]];
            return text?:formate;
        }
        
    }
    return nil;
}

NSString * LSTextChangeLanguage(NSString *key, NSString *formate, ...) {
    if (formate) {
        va_list args;
        va_start(args, formate);
        NSMutableArray *array = [[NSMutableArray alloc] init];
        id next = va_arg(args, id);
        while (next) {
            [array addObject:next];
            next = va_arg(args, id);
        }
        va_end(args);
        
        NSString *list = [array componentsJoinedByString:LSTextSeparatorSymbol];
//        NSString *string = key;
        if (list.length > 0) {
//            NSArray *total = @[key, formate, list];
//            string = [total componentsJoinedByString:LSTextSeparatorSymbol];
        } else {
            return [@[key, formate] componentsJoinedByString:LSTextSeparatorSymbol];
        }
        
    }
    return key;
}
