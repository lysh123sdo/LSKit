//
//  LSPlugin.h
//  LSKitDemo
//
//  Created by Lyson on 2018/5/20.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG
#define LSPluginLog(frmt, ...) NSLog((frmt),##__VA_ARGS__)
#else
#define LSPluginLog(frmt, ...)
#endif


@protocol LSPluginDelegate<NSObject>

+(void)pluginRegisterRouters;

-(NSString*)pluginName;

-(NSString*)pluginId;

-(void)start;

-(void)stop;

@end

@interface LSPlugin : NSObject<LSPluginDelegate>

-(void)pluginInit;

-(void)pluginDealloc;

@end
