//
//  LSRunloopSource.m
//  Plug-in2Demo
//
//  Created by Lyson on 2018/1/25.
//  Copyright © 2018年 Plug-in2Demo. All rights reserved.
//

#import "LSRunloopSource.h"



@implementation LSRunloopContext

- (id)initWithSource:(LSRunloopSource*)src loop:(CFRunLoopRef)loop{
    
    if (self = [super init]) {
        
        _source = src;
        _runLoop = loop;
        
    }
    return self;
}

@end


@interface LSRunloopSource()
{
    
    CFRunLoopSourceRef runLoopSource;
  
}

@end


@implementation LSRunloopSource

void RunLoopSourceScheduleRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
    
    LSRunloopSource* obj = (__bridge LSRunloopSource*)info;
   
    LSRunloopContext *context = [[LSRunloopContext alloc] initWithSource:obj loop:rl];
    [obj.delegate runLoopScheduleRouting:context strRef:mode];
}

void RunLoopSourcePerformRoutine (void *info)
{
    LSRunloopSource*  obj = (__bridge LSRunloopSource*)info;
    [obj.delegate runLoopPerformRouting:info];
//    [obj sourceFired];
}

void RunLoopSourceCancelRoutine (void *info, CFRunLoopRef rl, CFStringRef mode)
{
   
    LSRunloopSource* obj = (__bridge LSRunloopSource*)info;
    
    LSRunloopContext *context = [[LSRunloopContext alloc] initWithSource:obj loop:rl];
    [obj.delegate runLoopScheduleRouting:context strRef:mode];

}


-(instancetype)initWithDelegate:(id<LSRunloopSourceDelegate>)delegate{
    
    if (self = [super init]) {
        
        self.delegate = delegate;
        
        CFRunLoopSourceContext context = {0, (__bridge void *)(self), NULL, NULL, NULL, NULL, NULL,
            &RunLoopSourceScheduleRoutine,
            RunLoopSourceCancelRoutine,
            RunLoopSourcePerformRoutine};
        
        runLoopSource = CFRunLoopSourceCreate(NULL, 0, &context);
    }
    
    return self;
}

-(void)fireRunloop:(CFRunLoopRef)ref{
    
    CFRunLoopSourceSignal(runLoopSource);
    CFRunLoopWakeUp(ref);
}

-(void)addToCurrentLoop{
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopAddSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
}

-(void)removeLoop{
    
    
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopStop(runLoop);
    CFRunLoopRemoveSource(runLoop, runLoopSource, kCFRunLoopDefaultMode);
    
}

@end
