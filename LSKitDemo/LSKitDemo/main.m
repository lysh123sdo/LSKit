//
//  main.m
//  LSKitDemo
//
//  Created by Lyson on 2018/4/5.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        NSLog(@"@@@@@1");
        
        int arg = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        
        NSLog(@"@@@@@2");
        
        return arg;
    }
}

//#import <Foundation/Foundation.h>
//
//int main(int argc, char * argv[]) {
//    @autoreleasepool {
//        NSObject *obj = [[NSObject alloc] init];
//        NSLog(@"%@",obj);
//    }
//
//    return 0;
//}
