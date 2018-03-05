//
//  LSRunloopSource.h
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/25.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSRunloopContext;


@protocol LSRunloopSourceDelegate<NSObject>


-(void)runLoopScheduleRouting:(LSRunloopContext*)context strRef:(CFStringRef)mode;

-(void)runLoopPerformRouting:(void *)info;

-(void)runLoopCancelRouting:(LSRunloopContext*)context strRef:(CFStringRef)mode;


@end

@interface LSRunloopSource : NSObject

@property (nonatomic , weak) id<LSRunloopSourceDelegate> delegate;

-(instancetype)initWithDelegate:(id<LSRunloopSourceDelegate>)delegate;

-(void)addToCurrentLoop;

-(void)fireRunloop:(CFRunLoopRef)ref;

-(void)removeLoop;

@end


@interface LSRunloopContext : NSObject
{
    CFRunLoopRef        _runLoop;
    LSRunloopSource*        _source;
}
@property (readonly) CFRunLoopRef runLoop;
@property (readonly) LSRunloopSource* source;

- (id)initWithSource:(LSRunloopSource*)src loop:(CFRunLoopRef)loop;
@end
