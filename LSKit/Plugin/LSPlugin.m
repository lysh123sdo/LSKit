//
//  LSPlugin.m
//  LSKitDemo
//
//  Created by Lyson on 2018/5/20.
//  Copyright © 2018年 LSKitDemo. All rights reserved.
//

#import "LSPlugin.h"

@interface LSPlugin()

@end

@implementation LSPlugin


+(void)pluginRegisterRouters{
    
    
}


-(void)pluginInit{
    
    
}

-(void)pluginDealloc{
    
    
}

-(BOOL)isLibrary{
    return YES;
}

-(NSString*)pluginName{
    
    return nil;
}

-(NSString*)pluginId{
    
    return nil;
}

-(void)start{
    [self pluginInit];
}

-(void)stop{
    [self pluginDealloc];
}

-(void)dealloc{
    LSPluginLog(@"释放了 %@ %@ %@",[self pluginName],[self pluginId],self.description);
}
@end
